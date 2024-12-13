import gleam/list
import gleam/result
import gleeunit
import gleeunit/should
import loan/loan

pub fn main() {
  gleeunit.main()
}

pub fn amortized_payment_test() {
  let loan = loan.Loan(10_000_000, 10_000_000, 0.06, 360, 12)
  loan.amortized_payment(loan)
  |> should.equal(Ok(59_955))
}

pub fn interest_payment_test() {
  // $30000 over 12 months at a 3% rate is $75 / month interest
  let loan = loan.Loan(3_000_000, 3_000_000, 0.03, 360, 12)
  loan.interest_payment(loan)
  |> should.equal(7500)
}

pub fn amortization_schedule_test() {
  let loan =
    loan.Loan(
      initial_principal: 3_000_000,
      remaining_principal: 3_000_000,
      interest: 0.03,
      term: 360,
      period: 12,
    )
  let schedule = loan.amortization_schedule(loan)
  should.be_ok(schedule)

  let unwrapped_schedule = result.unwrap(schedule, [])
  should.equal(list.length(unwrapped_schedule), 360)

  let first_payment =
    result.unwrap(
      list.first(unwrapped_schedule),
      loan.ScheduleItem(999, 999, 999, 999, 999),
    )
  should.equal(first_payment.payment_amount, 12_648)
  should.equal(first_payment.interest_payment, 7500)
  should.equal(first_payment.principal_payment, 5148)
  should.equal(first_payment.remaining_principal, 2_994_852)

  let last_payment =
    result.unwrap(
      list.last(unwrapped_schedule),
      loan.ScheduleItem(999, 999, 999, 999, 999),
    )
  should.equal(last_payment.payment_number, 360)
  should.equal(last_payment.payment_amount, 12_720)
  should.equal(last_payment.principal_payment, 12_688)
  should.equal(last_payment.interest_payment, 32)
  should.equal(last_payment.remaining_principal, 72)
}
