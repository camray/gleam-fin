import gleam/float
import gleam/int
import gleam/list
import gleam/result

pub type Loan {
  Loan(
    /// amount of the loan in cents at the start of the loan
    initial_principal: Int,
    /// amount of the loan in cents that currently remain
    remaining_principal: Int,
    /// annual interest rate
    interest: Float,
    /// number of individual payments to be made over the life of the loan
    term: Int,
    /// number of payments in a period for which to apply interest
    /// e.g. 12 for monthly
    /// e.g. 4 for quarterly
    period: Int,
  )
}

pub type ScheduleItem {
  ScheduleItem(
    /// the payment number
    payment_number: Int,
    /// the amount of the payment in cents
    payment_amount: Int,
    /// the amount of the payment that goes to interest in cents
    interest_payment: Int,
    /// the amount of the payment that goes to principal in cents
    principal_payment: Int,
    /// the remaining principal balance of the loan in cents
    remaining_principal: Int,
  )
}

/// Calculate the individual amortized payment for a loan
///
/// Returns the amortized payment in cents
pub fn amortized_payment(loan: Loan) -> Result(Int, Nil) {
  let amount = int.to_float(loan.initial_principal) /. 100.0
  let rate = loan.interest /. int.to_float(loan.period)
  let n = int.to_float(loan.term)

  use pow <- result.try(float.power(1.0 +. rate, n))
  let monthly_payment = amount /. { { pow -. 1.0 } /. { rate *. pow } }

  Ok(float.round(monthly_payment *. 100.0))
}

/// Calculate the interest payment for a loan
///
/// Returns the interest payment in cents
pub fn interest_payment(loan: Loan) -> Int {
  float.round(
    {
      { int.to_float(loan.remaining_principal) /. 100.0 *. loan.interest }
      /. int.to_float(loan.period)
    }
    *. 100.0,
  )
}

/// Calculate the amortization schedule for a loan
pub fn amortization_schedule(loan: Loan) -> Result(List(ScheduleItem), Nil) {
  use schedule <- result.try(internal_amortization_schedule(loan, []))
  Ok(list.reverse(schedule))
}

/// Calculate the total interest paid over the life of a loan in cents
pub fn total_interest_paid(loan: Loan) -> Int {
  let schedule = amortization_schedule(loan)
  let unwrapped_schedule = result.unwrap(schedule, [])
  list.fold(unwrapped_schedule, 0, fn(total, item) {
    total + item.interest_payment
  })
}

/// Calculate the total amount paid over the life of a loan in cents
/// including principal and interest
pub fn total_paid(loan: Loan) -> Int {
  let schedule = amortization_schedule(loan)
  let unwrapped_schedule = result.unwrap(schedule, [])
  list.fold(unwrapped_schedule, 0, fn(total, item) {
    total + item.payment_amount
  })
}

fn internal_amortization_schedule(
  loan: Loan,
  amortization: List(ScheduleItem),
) -> Result(List(ScheduleItem), Nil) {
  use scheduled_payment_amount <- result.try(amortized_payment(loan))
  let payment_number = list.length(amortization) + 1
  let interest = interest_payment(loan)
  let remaining_principal =
    loan.remaining_principal - { scheduled_payment_amount - interest }
  let payment_amount = case scheduled_payment_amount > remaining_principal {
    True -> loan.remaining_principal + interest
    False -> scheduled_payment_amount
  }
  let principal_payment = payment_amount - interest

  case remaining_principal > 0 {
    True -> {
      let new_loan = Loan(..loan, remaining_principal:)
      let new_schedule_item =
        ScheduleItem(
          payment_number:,
          payment_amount:,
          interest_payment: interest,
          principal_payment:,
          remaining_principal:,
        )

      internal_amortization_schedule(new_loan, [
        new_schedule_item,
        ..amortization
      ])
    }
    False -> Ok(amortization)
  }
}
