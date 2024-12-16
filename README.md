# gleam loan

[![Package Version](https://img.shields.io/hexpm/v/gleam_loan)](https://hex.pm/packages/gleam_loan)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gleam_loan/)

```sh
gleam add gleam_loan@1
```
```gleam
import gleam_loan

pub fn main() {
  let loan =
    gleam_loan.Loan(
      initial_principal: 3_000_000,
      remaining_principal: 3_000_000,
      interest: 0.03,
      term: 360,
      period: 12,
    )
  let amortization_schedule = gleam_loan.amortization_schedule(loan)
  io.debug(amortization_schedule)

  let amortized_payment = gleam_loan.amortized_payment(loan)
  io.debug(amortized_payment)

  let interest_payment = gleam_loan.interest_payment(loan)
  io.debug(interest_payment)

  io.debug(loan.initial_principal)
  io.debug(loan.remaining_principal)
  io.debug(loan.interest)
  io.debug(loan.term)
  io.debug(loan.period)
}
```

Further documentation can be found at <https://hexdocs.pm/gleam_loan>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
