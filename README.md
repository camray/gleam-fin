# gleam loan

[![Package Version](https://img.shields.io/hexpm/v/loan)](https://hex.pm/packages/loan)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/loan/)

```sh
gleam add loan@1
```
```gleam
import loan

pub fn main() {
  let loan =
    loan.Loan(
      initial_principal: 3_000_000,
      remaining_principal: 3_000_000,
      interest: 0.03,
      term: 360,
      period: 12,
    )
  let amortization_schedule = loan.amortization_schedule(loan)
  io.debug(amortization_schedule)

  let amortized_payment = loan.amortized_payment(loan)
  io.debug(amortized_payment)

  let interest_payment = loan.interest_payment(loan)
  io.debug(interest_payment)

  let total_interest = loan.total_interest_paid(loan)
  io.debug(total_interest)

  io.debug(loan.initial_principal)
  io.debug(loan.remaining_principal)
  io.debug(loan.interest)
  io.debug(loan.term)
  io.debug(loan.period)
}
```

Further documentation can be found at <https://hexdocs.pm/loan>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
