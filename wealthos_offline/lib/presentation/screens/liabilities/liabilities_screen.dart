import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/liability.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';
import 'liability_form_screen.dart';

/// شاشة قائمة الالتزامات.
class LiabilitiesScreen extends ConsumerWidget {
  const LiabilitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(liabilitiesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(S.liabilities)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LiabilityFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text(S.add),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              title: S.emptyState,
              subtitle: S.noDataAddFirst,
              icon: Icons.credit_card_outlined,
            );
          }
          final total = list
              .where((l) => l.status != LiabilityStatus.paidOff)
              .fold<double>(0, (s, l) => s + l.remainingAmount);
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                color: AppColors.negative.withValues(alpha: 0.07),
                child: ListTile(
                  leading: const Icon(Icons.trending_down,
                      color: AppColors.negative),
                  title: const Text(S.totalLiabilities),
                  trailing: Text(Fmt.money(total),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.negative)),
                ),
              ),
              ...list.map((l) => _LiabilityTile(liability: l)),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }
}

class _LiabilityTile extends ConsumerWidget {
  const _LiabilityTile({required this.liability});
  final Liability liability;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = liability;
    final progress = l.originalAmount > 0
        ? (1 - l.remainingAmount / l.originalAmount).clamp(0.0, 1.0)
        : 0.0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('${l.type.label} • ${l.status.label}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Text(Fmt.money(l.remainingAmount, l.currency),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.negative)),
              ],
            ),
            if (l.originalAmount > 0) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.negative.withValues(alpha: 0.12),
                  color: AppColors.positive,
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('مسدّد ${(progress * 100).round()}%',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                if (l.dueDate != null)
                  Text('استحقاق ${Fmt.date(l.dueDate!)}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                const Spacer(),
                if (l.status == LiabilityStatus.active)
                  TextButton.icon(
                    onPressed: () => _pay(context, ref),
                    icon: const Icon(Icons.payments_outlined, size: 18),
                    label: const Text('سداد'),
                  ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => LiabilityFormScreen(liability: l)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      size: 20, color: AppColors.negative),
                  onPressed: () async {
                    await ref.read(liabilityRepoProvider).delete(l.id!);
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

  Future<void> _pay(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(
        text: liability.monthlyPayment > 0
            ? liability.monthlyPayment.toStringAsFixed(0)
            : '');
    final amount = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('سداد دفعة — ${liability.name}'),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'المبلغ'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text(S.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, double.tryParse(ctrl.text)),
            child: const Text(S.confirm),
          ),
        ],
      ),
    );
    if (amount != null && amount > 0) {
      await ref.read(liabilityRepoProvider).addPayment(liability.id!, amount);
      bumpRefreshFromWidget(ref);
    }
  }
}
