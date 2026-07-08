import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/contribution.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';
import '../../widgets/form_fields.dart';

/// شاشة المساهمات العائلية (لا تُحتسب ضمن صافي الثروة).
class ContributionsScreen extends ConsumerWidget {
  const ContributionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(contributionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(S.contributions)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add),
        label: const Text(S.add),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.accent.withValues(alpha: 0.1),
            padding: const EdgeInsets.all(12),
            child: const Text(
              'مبالغ دفعتها لكنها ليست أصلًا مملوكًا لك (مثل بناء بيت العائلة). '
              'تظهر هنا فقط ولا تدخل في صافي الثروة.',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (list) => list.isEmpty
                  ? const EmptyState(
                      title: S.emptyState,
                      subtitle: S.noDataAddFirst,
                      icon: Icons.volunteer_activism_outlined)
                  : ListView(
                      padding: const EdgeInsets.all(12),
                      children: [
                        for (final c in list)
                          Card(
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFFBF1DA),
                                child: Icon(Icons.volunteer_activism,
                                    color: AppColors.accent),
                              ),
                              title: Text(c.title),
                              subtitle: Text([
                                if (c.beneficiary != null) c.beneficiary!,
                                if (c.date != null) Fmt.date(c.date!),
                              ].join(' • ')),
                              trailing: Text(Fmt.money(c.amount, c.currency),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              onLongPress: () async {
                                await ref
                                    .read(contributionRepoProvider)
                                    .delete(c.id!);
                                bumpRefreshFromWidget(ref);
                              },
                            ),
                          ),
                        const SizedBox(height: 80),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Contribution>(
      context: context,
      builder: (_) => const _ContributionDialog(),
    );
    if (result != null) {
      await ref.read(contributionRepoProvider).create(result);
      bumpRefreshFromWidget(ref);
    }
  }
}

class _ContributionDialog extends StatefulWidget {
  const _ContributionDialog();

  @override
  State<_ContributionDialog> createState() => _ContributionDialogState();
}

class _ContributionDialogState extends State<_ContributionDialog> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _beneficiary = TextEditingController();
  String _currency = 'AED';
  DateTime? _date;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _beneficiary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('مساهمة جديدة'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'العنوان')),
            const SizedBox(height: 12),
            MoneyField(controller: _amount, hint: 'المبلغ'),
            const SizedBox(height: 12),
            TextField(
                controller: _beneficiary,
                decoration:
                    const InputDecoration(labelText: 'المستفيد (اختياري)')),
            const SizedBox(height: 12),
            CurrencyDropdown(
                value: _currency,
                onChanged: (v) => setState(() => _currency = v)),
            const SizedBox(height: 12),
            DatePickerField(
              value: _date,
              hint: 'التاريخ (اختياري)',
              onChanged: (d) => setState(() => _date = d),
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
              Contribution(
                title: _title.text.trim(),
                amount: amount,
                currency: _currency,
                beneficiary: _beneficiary.text.trim().isEmpty
                    ? null
                    : _beneficiary.text.trim(),
                date: _date,
              ),
            );
          },
          child: const Text(S.save),
        ),
      ],
    );
  }
}
