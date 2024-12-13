import gleam/io
import loan/loan

pub fn main() {
  let loan =
    loan.Loan(
      initial_principal: 3_000_000,
      remaining_principal: 3_000_000,
      interest: 0.03,
      term: 360,
      period: 12,
    )
  let amortized_payment = loan.amortization_schedule(loan)
  io.debug(amortized_payment)
}
