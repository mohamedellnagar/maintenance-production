import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/localization/app_strings.dart';
import '../../../data/models/liability.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';
import '../../widgets/form_fields.dart';

/// شاشة إضافة/تعديل التزام.
class LiabilityFormScreen extends ConsumerStatefulWidget {
  const LiabilityFormScreen({super.key, this.liability});
  final Liability? liability;

  @override
  ConsumerState<LiabilityFormScreen> createState() =>
      _LiabilityFormScreenState();
}

class _LiabilityFormScreenState extends ConsumerState<LiabilityFormScreen> {
  late final TextEditingController _name;
  late final TextEditingController _original;
  late final TextEditingController _remaining;
  late final TextEditingController _monthly;
  late final TextEditingController _notes;

  LiabilityType _type = LiabilityType.loan;
  LiabilityStatus _status = LiabilityStatus.active;
  String _currency = 'AED';
  DateTime? _startDate;
  DateTime? _dueDate;
  int? _linkedAssetId;

  bool get _isEdit => widget.liability != null;

  @override
  void initState() {
    super.initState();
    final l = widget.liability;
    _name = TextEditingController(text: l?.name ?? '');
    _original =
        TextEditingController(text: l != null ? l.originalAmount.toStringAsFixed(0) : '');
    _remaining =
        TextEditingController(text: l != null ? l.remainingAmount.toStringAsFixed(0) : '');
    _monthly =
        TextEditingController(text: l != null ? l.monthlyPayment.toStringAsFixed(0) : '');
    _notes = TextEditingController(text: l?.notes ?? '');
    _type = l?.type ?? LiabilityType.loan;
    _status = l?.status ?? LiabilityStatus.active;
    _currency = l?.currency ?? 'AED';
    _startDate = l?.startDate;
    _dueDate = l?.dueDate;
    _linkedAssetId = l?.linkedAssetId;
  }

  @override
  void dispose() {
    _name.dispose();
    _original.dispose();
    _remaining.dispose();
    _monthly.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final remaining = double.tryParse(_remaining.text.trim());
    if (name.isEmpty || remaining == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل الاسم والمبلغ المتبقي على الأقل')),
      );
      return;
    }
    final repo = ref.read(liabilityRepoProvider);
    final model = Liability(
      id: widget.liability?.id,
      name: name,
      type: _type,
      originalAmount: double.tryParse(_original.text.trim()) ?? remaining,
      remainingAmount: remaining,
      currency: _currency,
      startDate: _startDate,
      dueDate: _dueDate,
      monthlyPayment: double.tryParse(_monthly.text.trim()) ?? 0,
      linkedAssetId: _linkedAssetId,
      status: _status,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      createdAt: widget.liability?.createdAt,
    );
    if (_isEdit) {
      await repo.update(model);
    } else {
      await repo.create(model);
    }
    bumpRefreshFromWidget(ref);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final assetsAsync = ref.watch(assetsProvider);
    return Scaffold(
      appBar:
          AppBar(title: Text(_isEdit ? '${S.edit} ${S.liabilities}' : 'التزام جديد')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LabeledField(label: S.name, child: TextField(controller: _name)),
          LabeledField(
            label: S.type,
            child: EnumDropdown<LiabilityType>(
              value: _type,
              items: LiabilityType.values,
              labelOf: (t) => t.label,
              onChanged: (t) => setState(() => _type = t),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LabeledField(
                  label: S.originalAmount,
                  child: MoneyField(controller: _original),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LabeledField(
                  label: S.remainingAmount,
                  child: MoneyField(controller: _remaining),
                ),
              ),
            ],
          ),
          LabeledField(
            label: S.monthlyPayment,
            child: MoneyField(controller: _monthly),
          ),
          LabeledField(
            label: S.currency,
            child: CurrencyDropdown(
              value: _currency,
              onChanged: (v) => setState(() => _currency = v),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LabeledField(
                  label: S.startDate,
                  child: DatePickerField(
                    value: _startDate,
                    onChanged: (d) => setState(() => _startDate = d),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LabeledField(
                  label: S.dueDate,
                  child: DatePickerField(
                    value: _dueDate,
                    onChanged: (d) => setState(() => _dueDate = d),
                  ),
                ),
              ),
            ],
          ),
          LabeledField(
            label: S.status,
            child: EnumDropdown<LiabilityStatus>(
              value: _status,
              items: LiabilityStatus.values,
              labelOf: (t) => t.label,
              onChanged: (t) => setState(() => _status = t),
            ),
          ),
          LabeledField(
            label: S.linkedAsset,
            child: assetsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
              data: (list) {
                // احترازًا من أصل مرتبط تم حذفه (قيمة غير موجودة في القائمة).
                final ids = list.map((a) => a.id).toSet();
                final safeValue =
                    ids.contains(_linkedAssetId) ? _linkedAssetId : null;
                return DropdownButtonFormField<int?>(
                  value: safeValue,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<int?>(
                        value: null, child: Text('بدون')),
                    for (final a in list)
                      DropdownMenuItem<int?>(value: a.id, child: Text(a.name)),
                  ],
                  onChanged: (v) => setState(() => _linkedAssetId = v),
                );
              },
            ),
          ),
          LabeledField(
            label: S.notes,
            child: TextField(controller: _notes, maxLines: 3),
          ),
          const SizedBox(height: 8),
          SaveButton(onPressed: _save),
        ],
      ),
    );
  }
}
