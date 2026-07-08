import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/income.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';
import '../../widgets/form_fields.dart';

/// شاشة الدخل — مصادر الدخل وفتراتها التاريخية (Salary History).
class IncomeScreen extends ConsumerWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(incomeSourcesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(S.income)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addSource(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('مصدر دخل'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (sources) => sources.isEmpty
            ? const EmptyState(
                title: S.emptyState,
                subtitle: S.noDataAddFirst,
                icon: Icons.south_west)
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (final s in sources) _SourceCard(source: s),
                  const SizedBox(height: 80),
                ],
              ),
      ),
    );
  }

  Future<void> _addSource(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<IncomeSource>(
      context: context,
      builder: (_) => const _SourceDialog(),
    );
    if (result != null) {
      await ref.read(incomeRepoProvider).createSource(result);
      bumpRefreshFromWidget(ref);
    }
  }
}

class _SourceCard extends ConsumerWidget {
  const _SourceCard({required this.source});
  final IncomeSource source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync =
        ref.watch(_incomeHistoryProvider(source.id!));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.positive.withValues(alpha: 0.12),
                  child: const Icon(Icons.attach_money,
                      color: AppColors.positive, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(source.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${source.type.label} • ${source.currency}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.negative),
                  onPressed: () async {
                    await ref.read(incomeRepoProvider).deleteSource(source.id!);
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
                    ...history.reversed.map((h) => _PeriodRow(
                          amount: h.amount,
                          currency: source.currency,
                          from: h.fromDate,
                          to: h.toDate,
                          onDelete: () async {
                            await ref
                                .read(incomeRepoProvider)
                                .deleteHistory(h.id!);
                            ref.invalidate(_incomeHistoryProvider(source.id!));
                            bumpRefreshFromWidget(ref);
                          },
                        )),
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
    final result = await showDialog<IncomeHistory>(
      context: context,
      builder: (_) => _PeriodDialog(sourceId: source.id!, isIncome: true),
    );
    if (result != null) {
      await ref.read(incomeRepoProvider).addHistory(result);
      ref.invalidate(_incomeHistoryProvider(source.id!));
      bumpRefreshFromWidget(ref);
    }
  }
}

/// مزوّد عائلي لتاريخ فترات مصدر دخل محدّد.
final _incomeHistoryProvider =
    FutureProvider.family<List<IncomeHistory>, int>((ref, sourceId) {
  ref.watch(refreshProvider);
  return ref.watch(incomeRepoProvider).history(sourceId);
});

/// صف فترة تاريخية مشترك بين الدخل والمصروف.
class _PeriodRow extends StatelessWidget {
  const _PeriodRow({
    required this.amount,
    required this.currency,
    required this.from,
    required this.to,
    required this.onDelete,
  });

  final double amount;
  final String currency;
  final DateTime from;
  final DateTime? to;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final toLabel = to == null ? S.now : Fmt.monthYear(to!);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.history, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text('${Fmt.monthYear(from)} ← $toLabel',
                style: const TextStyle(fontSize: 13)),
          ),
          Text(Fmt.money(amount, currency),
              style: const TextStyle(fontWeight: FontWeight.w600)),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close, size: 16),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

/// حوار إضافة مصدر دخل.
class _SourceDialog extends StatefulWidget {
  const _SourceDialog();

  @override
  State<_SourceDialog> createState() => _SourceDialogState();
}

class _SourceDialogState extends State<_SourceDialog> {
  final _name = TextEditingController();
  IncomeType _type = IncomeType.salary;
  String _currency = 'AED';

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('مصدر دخل جديد'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: S.name)),
          const SizedBox(height: 12),
          EnumDropdown<IncomeType>(
            value: _type,
            items: IncomeType.values,
            labelOf: (t) => t.label,
            onChanged: (t) => setState(() => _type = t),
          ),
          const SizedBox(height: 12),
          CurrencyDropdown(
              value: _currency, onChanged: (v) => setState(() => _currency = v)),
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
              IncomeSource(
                  name: _name.text.trim(), type: _type, currency: _currency),
            );
          },
          child: const Text(S.save),
        ),
      ],
    );
  }
}

/// حوار إضافة فترة (دخل أو مصروف).
class _PeriodDialog extends StatefulWidget {
  const _PeriodDialog({required this.sourceId, required this.isIncome});
  final int sourceId;
  final bool isIncome;

  @override
  State<_PeriodDialog> createState() => _PeriodDialogState();
}

class _PeriodDialogState extends State<_PeriodDialog> {
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
            if (widget.isIncome) {
              Navigator.pop(
                context,
                IncomeHistory(
                    sourceId: widget.sourceId,
                    amount: amount,
                    fromDate: _from,
                    toDate: _current ? null : _to),
              );
            }
          },
          child: const Text(S.save),
        ),
      ],
    );
  }
}
