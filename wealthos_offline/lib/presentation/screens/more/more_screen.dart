import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../audit/audit_screen.dart';
import '../backup/backup_screen.dart';
import '../chat/chat_screen.dart';
import '../contributions/contributions_screen.dart';
import '../expenses/expenses_screen.dart';
import '../goals/goals_screen.dart';
import '../income/income_screen.dart';
import '../reminders/reminders_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/currency_screen.dart';
import '../settings/settings_screen.dart';

class _MoreItem {
  const _MoreItem(this.label, this.icon, this.color, this.builder);
  final String label;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;
}

/// شاشة "المزيد" — بوابة لبقية الوحدات.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = <_MoreItem>[
      _MoreItem(S.income, Icons.south_west, AppColors.positive,
          (_) => const IncomeScreen()),
      _MoreItem(S.expenses, Icons.north_east, AppColors.negative,
          (_) => const ExpensesScreen()),
      _MoreItem(S.goals, Icons.flag_outlined, AppColors.accent,
          (_) => const GoalsScreen()),
      _MoreItem(S.reports, Icons.description_outlined, AppColors.neutral,
          (_) => const ReportsScreen()),
      _MoreItem(S.contributions, Icons.volunteer_activism_outlined,
          AppColors.accent, (_) => const ContributionsScreen()),
      _MoreItem(S.chat, Icons.chat_bubble_outline, AppColors.primary,
          (_) => const ChatScreen()),
      _MoreItem(S.reminders, Icons.notifications_outlined, AppColors.neutral,
          (_) => const RemindersScreen()),
      _MoreItem(S.currency, Icons.currency_exchange, AppColors.primary,
          (_) => const CurrencyScreen()),
      _MoreItem(S.backup, Icons.backup_outlined, AppColors.neutral,
          (_) => const BackupScreen()),
      _MoreItem('سجل التدقيق', Icons.fact_check_outlined,
          AppColors.textSecondary, (_) => const AuditScreen()),
      _MoreItem(S.settings, Icons.settings_outlined, AppColors.textSecondary,
          (_) => const SettingsScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text(S.more)),
      body: GridView.count(
        padding: const EdgeInsets.all(14),
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
        children: [
          for (final item in items)
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: item.builder)),
              child: Card(
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: item.color, size: 26),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(item.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
