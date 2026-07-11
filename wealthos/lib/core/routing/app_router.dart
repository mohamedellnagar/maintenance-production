import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/home_shell.dart';
import '../../features/accounts/presentation/account_detail_page.dart';
import '../../features/accounts/presentation/accounts_list_page.dart';
import '../../features/accounts/presentation/add_account_page.dart';
import '../../features/budgets/presentation/budget_create_page.dart';
import '../../features/budgets/presentation/budget_item_details_page.dart';
import '../../features/budgets/presentation/budget_item_form_page.dart';
import '../../features/budgets/presentation/budget_month_page.dart';
import '../../features/budgets/presentation/close_month_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/recurring/presentation/occurrence_details_page.dart';
import '../../features/recurring/presentation/recurring_home_page.dart';
import '../../features/recurring/presentation/recurring_rule_details_page.dart';
import '../../features/recurring/presentation/recurring_rule_form_page.dart';
import '../../features/settings/application/settings_providers.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/transactions/presentation/transaction_details_page.dart';
import '../../features/transactions/presentation/transaction_form_page.dart';

abstract final class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String dashboard = '/';
  static const String budget = '/budget';
  static const String recurring = '/recurring';
  static const String accounts = '/accounts';
  static const String settings = '/settings';

  static const String addAccount = '/accounts/add';
  static const String accountDetail = '/accounts/:id';
  static const String addTransaction = '/transactions/add';
  static const String transactionDetail = '/transactions/:id';
  static const String editTransaction = '/transactions/:id/edit';

  static const String budgetCreate = '/budget/create';
  static const String budgetClose = '/budget/close';
  static const String budgetItemAdd = '/budget/items/add';
  static const String budgetItemDetail = '/budget/items/:id';
  static const String budgetItemEdit = '/budget/items/:id/edit';

  static const String recurringAdd = '/recurring/add';
  static const String recurringRuleDetail = '/recurring/rules/:id';
  static const String recurringRuleEdit = '/recurring/rules/:id/edit';
  static const String occurrenceDetail = '/recurring/occurrences/:id';

  static String accountDetailPath(String id) => '/accounts/$id';
  static String transactionDetailPath(String id) => '/transactions/$id';
  static String editTransactionPath(String id) => '/transactions/$id/edit';
  static String budgetItemDetailPath(String id) => '/budget/items/$id';
  static String budgetItemEditPath(String id) => '/budget/items/$id/edit';
  static String recurringRuleDetailPath(String id) => '/recurring/rules/$id';
  static String recurringRuleEditPath(String id) => '/recurring/rules/$id/edit';
  static String occurrenceDetailPath(String id) => '/recurring/occurrences/$id';
}

final _rootKey = GlobalKey<NavigatorState>();

/// Builds the app router. Redirects to onboarding until it is completed.
final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(settingsProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  GoRoute pushRoute(String path, Widget Function(GoRouterState state) build) =>
      GoRoute(
        path: path,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => build(state),
      );

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.dashboard,
    refreshListenable: refresh,
    redirect: (context, state) {
      final settingsAsync = ref.read(settingsProvider);
      if (!settingsAsync.hasValue) return null;
      final onboarded = settingsAsync.value?.onboardingCompleted ?? false;
      final atOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!onboarded) return atOnboarding ? null : AppRoutes.onboarding;
      if (atOnboarding) return AppRoutes.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (_, _) => const DashboardPage(),
                routes: [
                  pushRoute(
                    'transactions/add',
                    (_) => const TransactionFormPage(),
                  ),
                  pushRoute(
                    'transactions/:id/edit',
                    (s) => TransactionFormPage(
                      transactionId: s.pathParameters['id'],
                    ),
                  ),
                  pushRoute(
                    'transactions/:id',
                    (s) => TransactionDetailsPage(
                      transactionId: s.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.budget,
                builder: (_, _) => const BudgetMonthPage(),
                routes: [
                  pushRoute('create', (_) => const BudgetCreatePage()),
                  pushRoute('close', (_) => const CloseMonthPage()),
                  pushRoute('items/add', (_) => const BudgetItemFormPage()),
                  pushRoute(
                    'items/:id/edit',
                    (s) => BudgetItemFormPage(itemId: s.pathParameters['id']),
                  ),
                  pushRoute(
                    'items/:id',
                    (s) =>
                        BudgetItemDetailsPage(itemId: s.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.recurring,
                builder: (_, _) => const RecurringHomePage(),
                routes: [
                  pushRoute('add', (_) => const RecurringRuleFormPage()),
                  pushRoute(
                    'rules/:id/edit',
                    (s) =>
                        RecurringRuleFormPage(ruleId: s.pathParameters['id']),
                  ),
                  pushRoute(
                    'rules/:id',
                    (s) => RecurringRuleDetailsPage(
                      ruleId: s.pathParameters['id']!,
                    ),
                  ),
                  pushRoute(
                    'occurrences/:id',
                    (s) => OccurrenceDetailsPage(
                      occurrenceId: s.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.accounts,
                builder: (_, _) => const AccountsListPage(),
                routes: [
                  pushRoute('add', (_) => const AddAccountPage()),
                  pushRoute(
                    ':id',
                    (s) =>
                        AccountDetailPage(accountId: s.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (_, _) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
