import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts/presentation/account_detail_page.dart';
import '../../features/accounts/presentation/accounts_list_page.dart';
import '../../features/accounts/presentation/add_account_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/settings/application/settings_providers.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/transactions/presentation/transaction_details_page.dart';
import '../../features/transactions/presentation/transaction_form_page.dart';

abstract final class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String dashboard = '/';
  static const String accounts = '/accounts';
  static const String addAccount = '/accounts/add';
  static const String accountDetail = '/accounts/:id';
  static const String addTransaction = '/transactions/add';
  static const String transactionDetail = '/transactions/:id';
  static const String editTransaction = '/transactions/:id/edit';
  static const String settings = '/settings';

  static String accountDetailPath(String id) => '/accounts/$id';
  static String transactionDetailPath(String id) => '/transactions/$id';
  static String editTransactionPath(String id) => '/transactions/$id/edit';
}

/// Builds the app router. Redirects to onboarding until it is completed.
final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(settingsProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    refreshListenable: refresh,
    redirect: (context, state) {
      final settingsAsync = ref.read(settingsProvider);
      // Wait for settings to load before deciding.
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
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (_, _) => const DashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.accounts,
        builder: (_, _) => const AccountsListPage(),
      ),
      GoRoute(
        path: AppRoutes.addAccount,
        builder: (_, _) => const AddAccountPage(),
      ),
      GoRoute(
        path: AppRoutes.accountDetail,
        builder: (_, state) =>
            AccountDetailPage(accountId: state.pathParameters['id']!),
      ),
      // Literal `/transactions/add` must precede the `:id` routes.
      GoRoute(
        path: AppRoutes.addTransaction,
        builder: (_, _) => const TransactionFormPage(),
      ),
      GoRoute(
        path: AppRoutes.editTransaction,
        builder: (_, state) =>
            TransactionFormPage(transactionId: state.pathParameters['id']),
      ),
      GoRoute(
        path: AppRoutes.transactionDetail,
        builder: (_, state) =>
            TransactionDetailsPage(transactionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsPage(),
      ),
    ],
  );
});
