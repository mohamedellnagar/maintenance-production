# Accounting Model

How WealthOS represents money internally, what it shows the user, and how each
operation moves balances. All rules live in the domain layer
(`AccountBalance`, `BalanceCalculator`, `TransactionEffect`,
`AdjustmentCalculator`, `NetWorthCalculator`) and are exhaustively unit- and
database-tested. Widgets never re-derive them.

## Three balance concepts

For every account the domain computes three distinct values (`AccountBalance`):

| concept | meaning | asset | liability |
| --- | --- | --- | --- |
| `signedBalanceMinor` | internal value on one number line | positive when you own money | **negative** when you owe |
| `displayBalanceMinor` | what the user sees | same as signed | the outstanding debt, as a **positive** number |
| `netWorthContributionMinor` | contribution to net worth | = signed | = signed (negative) |

The single signed number line lets one formula handle every account type.

## Asset balances

```
Bank opening 10,000  → signed +10,000, display 10,000, net-worth +10,000
```
Spending reduces the signed balance; an overdrawn asset shows a negative display.

## Liability balances

The user enters an **outstanding balance** (positive, intuitive); the domain
stores it negated (`AccountBalance.signedOpeningBalance`).

```
Loan outstanding 30,000  → stored signed -30,000
  display balance   = 30,000   (shown as "Outstanding balance")
  net-worth contrib = -30,000
```

## Net worth (spec example)

```
Bank        signed +10,000   → Total Assets      = 10,000
Loan        signed -30,000   → Total Liabilities = 30,000
Net Worth = Total Assets − Total Liabilities = 10,000 − 30,000 = −20,000
          = Σ net-worth contributions = +10,000 + (−30,000) = −20,000
```

## How each operation moves balances

Signed delta applied by `TransactionEffect` (all four DB types are kept; the
UI labels them with `TransactionSemantic`):

| operation | DB type | source | destination | cash flow? |
| --- | --- | --- | --- | --- |
| Income | income | +amount | — | income |
| Expense | expense | −amount | — | expense |
| Transfer (asset↔asset) | transfer | −amount | +amount | no |
| **Credit-card purchase** | expense on the card | −amount (debt ↑) | — | expense |
| **Liability charge / interest** | expense on the liability | −amount (debt ↑) | — | expense |
| **Liability repayment** | transfer asset → liability | −amount (cash ↓) | +amount (debt ↓) | no |
| **Loan draw-down / receipt** | transfer liability → asset | −amount (debt ↑) | +amount (cash ↑) | no |
| **Adjustment** | adjustment | +signed delta | — | no |

### Credit-card purchase
`expense` booked against the card. Signed balance goes more negative (debt up)
and it counts in monthly expenses under its category. No phantom cash account is
touched.

### Credit-card / loan repayment
`transfer` from a bank (asset) into the liability. Cash goes down, debt goes
down, and it is **not** income or expense (so a purchase already recorded is not
counted a second time). Runs inside one database transaction.

### Loan receipt
`transfer` **from** the loan (liability) into the bank (asset). Cash up, debt up,
net worth unchanged.

### Loan interest / fees
`expense` booked against the loan: debt up and counted as an expense.

### Balance adjustment
The user enters the **actual** balance; the domain computes
`delta = desiredSigned − calculatedSigned` (`AdjustmentCalculator`). The UI shows
the current calculated balance, the difference, requires a reason, and blocks a
zero-change save. Adjustments are excluded from cash-flow reports.

```
Asset: calculated 5,000, actual 4,500 → delta −500
Liability: calculated signed −3,000 (owed 3,000), actual owed 3,500 → delta −500
```

## Deletion & restore

Financial rows are soft-deleted (`deleted_at`). A deleted transaction
contributes zero to every balance, net worth and monthly total. **Restore**
clears `deleted_at` on the same row (never a new row), bringing its effect back.
Deleting a transfer removes both endpoints' effects atomically; deleting an
adjustment reverses its delta.

## Why these values live in the domain

Balance sign conversions must never be re-implemented ad hoc inside widgets (no
scattered `abs()`), so a liability always displays consistently and net worth
always reconciles. Presentation widgets (`AccountBalanceText`, `MoneyText`,
`TransactionTile`) consume domain-computed values and only choose colors.
