# QA Checklist

Status legend: **Pass (auto)** = covered by an automated test in this repo;
**Pass (code)** = verified by code review / analyzer; **Not Executed** = needs a
device or the Android SDK, which is unavailable in the authoring sandbox.

## Installation
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Debug APK builds | `flutter build apk --debug` succeeds | Not Executed | Android SDK unavailable |
| App installs & launches | Cold start to Dashboard/Onboarding | Not Executed | device |
| App id / label | `com.wealthos.wealthos`, "WealthOS" | Pass (code) | manifest + gradle |

## Onboarding
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Gate until completed | Redirects to `/onboarding` | Pass (auto) | `onboarding_test.dart` |
| Language → currency → account | Flow completes, settings saved | Pass (auto) | onboarding + settings tests |

## Accounts
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Create/edit/archive | Persisted; archived hidden by default | Pass (auto) | `database_test.dart` |
| Balance derived | opening + transactions, never stored | Pass (auto) | `financial_calculations_test.dart` |
| Non-base currency rejected | Validation failure | Pass (auto) | `database_test.dart` |

## Transactions
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Income/expense/transfer/adjustment | Correct per-account effect | Pass (auto) | `accounting_model_test.dart` |
| Transfer atomic | Bad destination rolls back | Pass (auto) | `database_test.dart` |
| Soft delete + restore | Row kept; balance updates | Pass (auto) | `database_test.dart`, `transaction_details_test.dart` |
| Duplicate-submit guard | One record per submit | Pass (code) | form disables while submitting |

## Liabilities
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Card purchase vs repayment | Charge ≠ expense; repayment ≠ income | Pass (auto) | `accounting_model_test.dart` |
| Outstanding shown positive | Liability debt positive in UI | Pass (auto) | `accounting_model_test.dart` |

## Dashboard
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Net worth / cash flow | Correct, reactive | Pass (auto) | `reactive_test.dart` |
| Budget / Bills / Goals cards | Reactive; hidden when empty | Pass (auto) | budget/recurring/goals widget tests |
| Empty state | Friendly CTA when no data | Pass (auto) | `empty_dashboard_test.dart` |

## Budget
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Actual vs plan, rollover, close/reopen | Correct math; closed read-only | Pass (auto) | `budget_calculator_test.dart`, `budget_test.dart` |
| Linked goal saving item | Shows contributed/withdrawn this month | Pass (auto) | `integrity_test.dart` seeds it |
| Closed month after old edit | Live actuals change; insight raised | Pass (auto) | `budget_reactive_test.dart` |

## Recurring
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Generation idempotent; resumes after restart | No duplicates; occurrences on reopen | Pass (auto) | `recurring_generation_test.dart`, `persistence_test.dart` |
| Post once, no double-post | Guard rejects second post | Pass (auto) | `recurring_test.dart` |
| Reachable under More tab | One tap from More; deep links work | Pass (code) | router + `qa_test.dart` (More) |

## Goals
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Allocation ≤ eligible liquid | Over-allocation rejected | Pass (auto) | `goals_test.dart` |
| Withdraw/transfer bounded & atomic | Total allocated preserved | Pass (auto) | `goals_test.dart`, `goals_reactive_test.dart` |
| Transfer paired delete/restore | Both legs move together | Pass (auto) | `goals_test.dart` |
| Fund cache == ledger | Verified & repairable | Pass (auto) | `goals_test.dart`, `integrity_test.dart` |
| Debt goal: saved vs actual reduced | Distinct indicators | Pass (auto) | `goal_progress_calculator_test.dart` |

## Settings
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Language / theme / currency | Persist & apply | Pass (auto) | settings tests |
| Auto-create recurring toggle | Off by default; persists | Pass (auto) | recurring tests |
| Biometric toggle | Stored securely; gate honours it | Not Executed | device (secure storage + biometrics) |

## Localization
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| ar/en full coverage | No hardcoded strings | Pass (code) | gen_l10n; analyzer |
| RTL/LTR | Correct direction & order | Pass (auto) | `qa_test.dart` |
| Arabic nav labels not clipped | Fits 5 tabs + More | Pass (auto) | `qa_test.dart` |

## Accessibility
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Status by text, not color only | Track/overspend/overdue textual | Pass (code) | enum-label extensions |
| Large text 2.0 no overflow | Reflows via Wrap/Flexible | Pass (auto) | `qa_test.dart` |
| Touch targets / contrast | Material 3 defaults | Not Executed | device visual audit |
| Screen-reader labels | Buttons have text labels | Not Executed | device (TalkBack) |

## Security
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Privacy screen (recents/screenshots) | FLAG_SECURE blocks capture | Pass (code) | `MainActivity.kt` |
| No backup of local DB | allowBackup=false + extraction rules | Pass (code) | manifest + xml |
| No network permission | Offline; nothing leaves device | Pass (code) | manifest has no INTERNET |
| No secrets in repo | key.properties / keystores gitignored | Pass (code) | `.gitignore` |
| No sensitive logging | Balances/notes/accounts not logged | Pass (code) | dev-only logger; no financial logs |

## Migration
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| v1→v5, v2→v5, v3→v5, v4→v5, fresh | Lands at v5; tables/columns present | Pass (auto) | budget/recurring/goals/database tests |
| FK + integrity check | `foreign_key_check` empty; `integrity_check` ok | Pass (auto) | `integrity_test.dart` |
| Invariants after seed | cache==ledger, no orphan paid occ, alloc≤tx, valid links | Pass (auto) | `integrity_test.dart` |

## Performance
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| Cold start (seeded 10k tx) | < ~2 s to interactive | Not Executed | device |
| Dashboard / lists scroll | 60 fps; no jank | Not Executed | device; lists are query-limited |
| Stream updates | Sub-frame on write | Not Executed | device |

## Release Build
| Test | Expected | Status | Notes |
| --- | --- | --- | --- |
| `build apk --release` | Succeeds (debug-signed fallback) | Not Executed | Android SDK unavailable |
| `build appbundle --release` | Produces AAB | Not Executed | needs SDK + upload key |
| Signing config | Loaded from gitignored key.properties | Pass (code) | `build.gradle.kts` |
