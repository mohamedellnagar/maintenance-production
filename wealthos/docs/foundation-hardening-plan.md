# Foundation Hardening — Findings & Plan

Based on a direct read of the code (not the prior report). Each item lists the
verified problem and the fix.

## Findings (verified in code)

1. **Balance display logic leaks into widgets.** `account_detail_page`,
   `accounts_list_page` and `transaction_tile` pass `colorBySign:
   account.isLiability` and rely on `MoneyText` calling `.abs`. There is no
   single domain concept for signed vs. display vs. net-worth balances. A
   liability's current balance renders as a **negative** number, not the
   outstanding (positive) amount the spec wants.
2. **Opening-balance UX.** `add_account_page` negates liability input inline and
   labels it "Amount owed" (`accountsOwedAmount`). Spec wants an "Outstanding
   balance" label and the conversion centralised in the domain.
3. **Adjustment UX is a raw signed delta.** The user types the delta directly.
   Spec wants: show current calculated balance → enter the *actual* new balance
   → show the difference → require a reason → block a zero-change save → store
   the delta.
4. **No Transaction Details screen** and transactions are not tappable anywhere.
5. **No Edit Transaction** flow and the repository has no `update`.
6. **No delete confirmation / restore.** `softDelete` exists; there is no
   `restore`, no confirmation dialog, no undo.
7. **Integrity gaps** in `transactions_repository`: archived accounts and
   archived categories are accepted; income/expense category *type* is not
   checked against the transaction type; a category can be attached to a
   transfer/adjustment; transaction currency is not checked against the account
   or base currency.
8. **`accountByIdProvider` is a `FutureProvider`** → the account-detail screen
   does not react to archive/rename. Transaction detail has no provider at all.
9. **Liability scenarios (credit card / loan) are representable but undocumented
   and untested**, and the UI gives no guidance, so recording them looks
   ambiguous.

## Plan

- **Accounting model (domain):** add `AccountBalance` (`signedBalanceMinor`,
  `displayBalanceMinor`, `netWorthContributionMinor`); `BalanceCalculator`
  returns it and gains an `excludeTransactionId` option (for editing
  adjustments). Add `openingBalanceForInput()` and an `AdjustmentCalculator`
  (delta = desired signed − calculated signed). `MoneyText` gains a
  `displayBalance`/`preferSignForDirection` mode fed only by domain values —
  no ad-hoc `abs` in feature widgets.
- **Liability operations (domain + docs):** keep the four DB transaction types.
  Add a `TransactionSemantic` classifier (credit-card purchase, liability
  repayment, loan drawdown, liability charge, …) for labels/icons, and document
  the mapping in `business-rules.md` + new `accounting-model.md`. Repayment =
  transfer into the liability; charge/interest = expense on the liability; loan
  receipt = transfer *from* the liability.
- **Opening balance:** liability field labelled "Outstanding balance" /
  "الرصيد المستحق"; positive input converted to a signed opening in the domain.
- **Adjustment:** rebuilt flow using `AdjustmentCalculator`, with calculated
  balance shown, difference previewed, reason required, no-op blocked.
- **Screens:** `TransactionDetailsPage` (all fields + per-account effect +
  status) reachable from dashboard, account detail and lists; a shared
  `TransactionFormPage` for create **and** edit; delete with confirmation +
  undo/restore.
- **Repository hardening:** `TransactionsRepository` validates against loaded
  accounts/category (existence, not archived, currency == base, category type
  matches, category only on cash-flow) inside the same DB transaction; adds
  `update` (atomic) and `restore`. `AccountsRepository.watchById` for
  reactivity.
- **Reactivity:** `accountByIdProvider` and a new `transactionByIdProvider`
  become streams; balances/net worth/dashboard already stream via Drift.
- **Integrity note:** cross-table rules (archived / category-type) depend on
  other tables, so they are enforced in the repository/domain with real
  database tests, per the spec's fallback. Schema stays v1 (no column changes);
  foreign keys are already `PRAGMA`-enabled and this is now covered by a test.
- **Tests:** new unit (account balance, adjustment, opening balance, semantics),
  database (liability scenarios, edit, delete/restore, archived/category
  rejection, FK enforcement, summaries exclude deleted) and widget (details,
  edit, delete, adjustment) tests.
- **Docs:** update README, CHANGELOG, architecture, database, business-rules,
  testing, roadmap; add `accounting-model.md`.
