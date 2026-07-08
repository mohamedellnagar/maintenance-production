import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/goal.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';
import '../../widgets/form_fields.dart';

/// شاشة الأهداف المالية.
class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(goalsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(S.goals)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addGoal(context, ref),
        icon: const Icon(Icons.add),
        label: const Text(S.add),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (goals) => goals.isEmpty
            ? const EmptyState(
                title: S.emptyState,
                subtitle: S.noDataAddFirst,
                icon: Icons.flag_outlined)
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (final g in goals) _GoalCard(goal: g),
                  const SizedBox(height: 80),
                ],
              ),
      ),
    );
  }

  Future<void> _addGoal(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Goal>(
      context: context,
      builder: (_) => const _GoalDialog(),
    );
    if (result != null) {
      await ref.read(goalRepoProvider).create(result);
      bumpRefreshFromWidget(ref);
    }
  }
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({required this.goal});
  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final g = goal;
    final monthly = g.requiredMonthlySaving();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(g.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                _statusChip(g.status),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: g.progressRatio,
                minHeight: 10,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${Fmt.money(g.currentProgress, g.currency)} من ${Fmt.money(g.targetAmount, g.currency)} '
              '(${(g.progressRatio * 100).round()}%)',
              style: const TextStyle(fontSize: 13),
            ),
            if (g.targetDate != null)
              Text('الموعد: ${Fmt.date(g.targetDate!)}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            if (monthly > 0)
              Text('ادخار شهري مطلوب: ${Fmt.money(monthly, g.currency)}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _updateProgress(context, ref),
                  child: const Text('تحديث التقدّم'),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.negative),
                  onPressed: () async {
                    await ref.read(goalRepoProvider).delete(g.id!);
                    bumpRefreshFromWidget(ref);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(GoalStatus status) {
    final color = switch (status) {
      GoalStatus.achieved => AppColors.positive,
      GoalStatus.paused => AppColors.textSecondary,
      GoalStatus.active => AppColors.accent,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status.label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Future<void> _updateProgress(BuildContext context, WidgetRef ref) async {
    final ctrl =
        TextEditingController(text: goal.currentProgress.toStringAsFixed(0));
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تحديث التقدّم'),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'المبلغ المُدّخر حاليًا'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text(S.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, double.tryParse(ctrl.text)),
            child: const Text(S.save),
          ),
        ],
      ),
    );
    if (value != null) {
      final achieved = value >= goal.targetAmount;
      await ref.read(goalRepoProvider).update(goal.copyWith(
            currentProgress: value,
            status: achieved ? GoalStatus.achieved : goal.status,
          ));
      bumpRefreshFromWidget(ref);
    }
  }
}

class _GoalDialog extends StatefulWidget {
  const _GoalDialog();

  @override
  State<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<_GoalDialog> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  String _currency = 'AED';
  DateTime? _targetDate;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('هدف جديد'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'اسم الهدف')),
            const SizedBox(height: 12),
            MoneyField(controller: _amount, hint: 'المبلغ المستهدف'),
            const SizedBox(height: 12),
            CurrencyDropdown(
                value: _currency,
                onChanged: (v) => setState(() => _currency = v)),
            const SizedBox(height: 12),
            DatePickerField(
              value: _targetDate,
              hint: 'تاريخ الهدف (اختياري)',
              onChanged: (d) => setState(() => _targetDate = d),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(S.cancel)),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_amount.text.trim());
            if (_title.text.trim().isEmpty || amount == null) return;
            Navigator.pop(
              context,
              Goal(
                title: _title.text.trim(),
                targetAmount: amount,
                currency: _currency,
                targetDate: _targetDate,
              ),
            );
          },
          child: const Text(S.save),
        ),
      ],
    );
  }
}
