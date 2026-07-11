# Business Rules

The rules the app guarantees. All are covered by tests (see `docs/testing.md`).

## Money

- Stored as **integer minor units** (fils/cents). `100.50 AED → 10050`. Never
  `double` in storage or arithmetic.
- `Money` = `{ amountMinor, currencyCode }`. Supports `+ - unary- < <= > >=`,
  equality, `abs`, formatting, and safe parsing.
- Mixing currencies in any arithmetic/comparison throws
  `CurrencyMismatchException`.
- Parsing (`Money.parse`) accepts thousands separators, ASCII and Arabic-Indic
  digits, and negative values; it rejects empty/garbage input and amounts with
  more fractional digits than the currency allows. Conversion to minor units is
  exact (via `Decimal`, then quantised) — no floating-point drift.

## Currency

- Exactly one **base currency** per user; default **AED**. Others are defined
  but not yet selectable.
- Every account carries a currency. In this phase all accounts **must** use the
  base currency — enforced at account creation (rejected otherwise).

## Accounts

- Types: `cash, bank, wallet, creditCard, investment, asset, loan, other`.
- Accounting classification: `asset` or `liability`. Defaults:
  cash/bank/wallet/investment/asset → asset; creditCard/loan → liability;
  `other` → user chooses.
- The **current balance is never stored** as an editable field. It is always
  derived from the opening balance plus every non-deleted transaction touching
  the account (`BalanceCalculator`). A cached balance may be added later behind
  the same interface, with rebuild/verification.

### Sign convention (why one formula fits every account)

Balances live on a **single signed number line**: assets are positive, an amount
owed on a liability is **negative**. A credit card with 500 owed has
`opening_balance_minor = -50000`. This lets one delta rule cover all types:

| type | effect on balance |
| --- | --- |
| income | `+amount` on source account |
| expense | `-amount` on source account |
| transfer | `-amount` on source, `+amount` on destination |
| adjustment | `+amount` (already signed) on source account |

Consequences that fall out naturally and are tested:

- On a **liability**, an expense (charge) makes the balance more negative → you
  owe more; an income (payment) makes it less negative → you owe less. This is
  the explicit, unambiguous rule for **income used with a liability account**.
- A transfer's debit and credit are symmetric across the same number line.

The **Add Account** screen collects an "amount owed" (positive) for liabilities
and stores its negation, so users never type a minus sign.

## Transactions

Effect rules (above) are the single source of truth (`TransactionEffect`).

- **Income / Expense** — require a source account. `amount_minor > 0`; an
  expense is **never** stored as a negative number — direction comes from the
  type.
- **Transfer** — requires source and destination (must differ). Debits source,
  credits destination. It is **not** income or expense. It is written inside one
  database transaction; account existence is checked within that transaction, so
  a bad reference rolls the whole thing back (atomicity).
- **Adjustment** — corrects a balance. The user enters the **actual new
  balance**; the app computes and stores `delta = desiredSigned −
  calculatedSigned` (`AdjustmentCalculator`), shows the difference, requires a
  non-empty reason, and blocks a zero-change save. `amount_minor` is that
  **signed** delta (may be negative) — the one deliberate exception to the "> 0"
  rule. Adjustments are excluded from cash-flow reports.

### Liability operations (credit cards, loans)

The four transaction types represent every liability operation without a
misleading phantom-cash entry; the UI labels them via `TransactionSemantic`.
See `accounting-model.md` for worked examples and tests.

- **Credit-card purchase** = an `expense` on the card → debt up, counted as an
  expense under its category.
- **Liability charge / loan interest** = an `expense` on the liability → debt up.
- **Liability / card repayment** = a `transfer` from an asset into the liability
  → cash down, debt down, **not** income or expense (so a purchase already
  recorded is never double-counted).
- **Loan receipt / draw-down** = a `transfer` from the liability into an asset →
  cash up, debt up, net worth unchanged.
- Income booked on a liability reduces what is owed (the documented
  income-on-liability rule).

### Cross-table integrity (enforced in the repository)

Rules that depend on other tables are enforced inside the same database
transaction as the write, so a violation rolls everything back:

- a transaction cannot reference an **archived** account (source or transfer
  destination) or an **archived** category;
- a category is only allowed on income/expense, and its **type must match**
  (income category for income, expense category for expense);
- the transaction currency must equal each account's currency and the base
  currency;
- `account_id` / `destination_account_id` must reference existing accounts
  (also guarded by SQLite foreign keys, which are `PRAGMA`-enabled).

Structural rules (amount ≠ 0, direction-by-type, transfer needs two distinct
endpoints, adjustment needs a reason, no category on transfer/adjustment) are
enforced by both `TransactionValidator` and SQL `CHECK` constraints.

### Editing

A transaction can be edited (amount, date, account, category, note, transfer
destination, or an adjustment's actual balance/reason). Editing re-runs **all**
validation — including after a type change — and rewrites the single row inside
one database transaction, so balances always recompute correctly and no stale
accounting rights survive. Transfers stay a single row, so both endpoints move
atomically.

### Opening balances

Entered once at account creation as a positive, intuitive amount (a liability's
**outstanding balance**), converted to the signed opening in the domain
(`AccountBalance.signedOpeningBalance`). Not editable as a standalone "current
balance" — use an **adjustment** to correct a balance later, preserving a reason.

### Soft delete & restore

Financial rows are never hard-deleted; `deleted_at` is set and deleted rows are
excluded from every balance, report and list. **Restore** clears `deleted_at` on
the same row (never a new transaction). A repeated delete is an idempotent
success. Deleting a transfer removes both endpoints' effect; deleting an
adjustment reverses its delta.

## Net worth & cash flow

- **Total Assets** = Σ balances of asset-classified accounts.
- **Total Liabilities** = −Σ balances of liability-classified accounts (shown as
  a positive "owed" figure).
- **Net Worth** = Total Assets − Total Liabilities = Σ all account balances.
- **Monthly income / expense** = Σ `amount_minor` of non-deleted income /
  expense transactions in the selected month. Transfers and adjustments are
  excluded (they are not cash flow).
