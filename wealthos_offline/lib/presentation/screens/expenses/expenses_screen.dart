import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/expense.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';
import '../../widgets/form_fields.dart';

/// شاشة المصروفات — فئات المصروف وفتراتها التاريخية (Expense History).
class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(expenseCategoriesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(S.expenses)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addCategory(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('فئة مصروف'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (cats) => cats.isEmpty
            ? const EmptyState(
                title: S.emptyState,
                subtitle: S.noDataAddFirst,
                icon: Icons.north_east)
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (final c in cats) _CategoryCard(category: c),
                  const SizedBox(height: 80),
                ],
              ),
      ),
    );
  }

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<ExpenseCategory>(
      context: context,
      builder: (_) => const _CategoryDialog(),
    );
    if (result != null) {
      await ref.read(expenseRepoProvider).createCategory(result);
      bumpRefreshFromWidget(ref);
    }
  }
}

final _expenseHistoryProvider =
    FutureProvider.family<List<ExpenseHistory>, int>((ref, categoryId) {
  ref.watch(refreshProvider);
  return ref.watch(expenseRepoProvider).history(categoryId);
});

class _CategoryCard extends ConsumerWidget {
  const _CategoryCard({required this.category});
  final ExpenseCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(_expenseHistoryProvider(category.id!));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.negative.withValues(alpha: 0.1),
                  child: const Icon(Icons.shopping_cart_outlined,
                      color: AppColors.negative, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${category.type.label} • ${category.currency}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.negative),
                  onPressed: () async {
                    await ref
                        .read(expenseRepoProvider)
                        .deleteCategory(category.id!);
                    bumpRefreshFromWidget(ref);
                  },
                ),
              ],
            ),
            const Divider(),
            historyAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
              data: (history) => Column(
                children: [
                  if (history.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('لا توجد فترات بعد',
                          style: TextStyle(color: AppColors.textSecondary)),
                    )
                  else
                    ...history.reversed.map((h) {
                      final toLabel =
                          h.toDate == null ? S.now : Fmt.monthYear(h.toDate!);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.history,
                                size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                  '${Fmt.monthYear(h.fromDate)} ← $toLabel',
                                  style: const TextStyle(fontSize: 13)),
                            ),
                            Text(Fmt.money(h.amount, category.currency),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () async {
                                await ref
                                    .read(expenseRepoProvider)
                                    .deleteHistory(h.id!);
                                ref.invalidate(
                                    _expenseHistoryProvider(category.id!));
                                bumpRefreshFromWidget(ref);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: () => _addPeriod(context, ref),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('إضافة فترة'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPeriod(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<ExpenseHistory>(
      context: context,
      builder: (_) => _ExpensePeriodDialog(categoryId: category.id!),
    );
    if (result != null) {
      await ref.read(expenseRepoProvider).addHistory(result);
      ref.invalidate(_expenseHistoryProvider(category.id!));
      bumpRefreshFromWidget(ref);
    }
  }
}

class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog();

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  final _name = TextEditingController();
  ExpenseType _type = ExpenseType.living;
  String _currency = 'AED';

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('فئة مصروف جديدة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: S.name)),
          const SizedBox(height: 12),
          EnumDropdown<ExpenseType>(
            value: _type,
            items: ExpenseType.values,
            labelOf: (t) => t.label,
            onChanged: (t) => setState(() => _type = t),
          ),
          const SizedBox(height: 12),
          CurrencyDropdown(
              value: _currency,
              onChanged: (v) => setState(() => _currency = v)),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(S.cancel)),
        ElevatedButton(
          onPressed: () {
            if (_name.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              ExpenseCategory(
                  name: _name.text.trim(), type: _type, currency: _currency),
            );
          },
          child: const Text(S.save),
        ),
      ],
    );
  }
}

class _ExpensePeriodDialog extends StatefulWidget {
  const _ExpensePeriodDialog({required this.categoryId});
  final int categoryId;

  @override
  State<_ExpensePeriodDialog> createState() => _ExpensePeriodDialogState();
}

class _ExpensePeriodDialogState extends State<_ExpensePeriodDialog> {
  final _amount = TextEditingController();
  DateTime _from = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _to;
  bool _current = true;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة فترة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MoneyField(controller: _amount, hint: 'المبلغ الشهري'),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('${S.from}: '),
              Expanded(
                child: DatePickerField(
                  value: _from,
                  allowClear: false,
                  onChanged: (d) => setState(() => _from = d ?? _from),
                ),
              ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('مستمرة حتى الآن'),
            value: _current,
            onChanged: (v) => setState(() {
              _current = v;
              if (v) _to = null;
            }),
          ),
          if (!_current)
            Row(
              children: [
                const Text('${S.to}: '),
                Expanded(
                  child: DatePickerField(
                    value: _to,
                    onChanged: (d) => setState(() => _to = d),
                  ),
                ),
              ],
            ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(S.cancel)),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_amount.text.trim());
            if (amount == null) return;
            Navigator.pop(
              context,
              ExpenseHistory(
                  categoryId: widget.categoryId,
                  amount: amount,
                  fromDate: _from,
                  toDate: _current ? null : _to),
            );
          },
          child: const Text(S.save),
        ),
      ],
    );
  }
}
