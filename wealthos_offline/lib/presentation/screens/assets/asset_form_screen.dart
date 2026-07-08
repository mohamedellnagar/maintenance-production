import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/localization/app_strings.dart';
import '../../../data/models/asset.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';
import '../../widgets/form_fields.dart';

/// شاشة إضافة/تعديل أصل.
class AssetFormScreen extends ConsumerStatefulWidget {
  const AssetFormScreen({super.key, this.asset});
  final Asset? asset;

  @override
  ConsumerState<AssetFormScreen> createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends ConsumerState<AssetFormScreen> {
  late final TextEditingController _name;
  late final TextEditingController _purchaseValue;
  late final TextEditingController _currentValue;
  late final TextEditingController _notes;

  AssetType _type = AssetType.cash;
  OwnershipStatus _ownership = OwnershipStatus.owned;
  String _currency = 'AED';
  DateTime? _purchaseDate;
  int? _linkedLiabilityId;

  bool get _isEdit => widget.asset != null;

  @override
  void initState() {
    super.initState();
    final a = widget.asset;
    _name = TextEditingController(text: a?.name ?? '');
    _purchaseValue =
        TextEditingController(text: a != null ? a.purchaseValue.toStringAsFixed(0) : '');
    _currentValue =
        TextEditingController(text: a != null ? a.currentValue.toStringAsFixed(0) : '');
    _notes = TextEditingController(text: a?.notes ?? '');
    _type = a?.type ?? AssetType.cash;
    _ownership = a?.ownershipStatus ?? OwnershipStatus.owned;
    _currency = a?.currency ?? 'AED';
    _purchaseDate = a?.purchaseDate;
    _linkedLiabilityId = a?.linkedLiabilityId;
  }

  @override
  void dispose() {
    _name.dispose();
    _purchaseValue.dispose();
    _currentValue.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final current = double.tryParse(_currentValue.text.trim());
    if (name.isEmpty || current == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل الاسم والقيمة الحالية على الأقل')),
      );
      return;
    }
    final repo = ref.read(assetRepoProvider);
    final model = Asset(
      id: widget.asset?.id,
      name: name,
      type: _type,
      purchaseValue: double.tryParse(_purchaseValue.text.trim()) ?? 0,
      currentValue: current,
      currency: _currency,
      purchaseDate: _purchaseDate,
      ownershipStatus: _ownership,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      linkedLiabilityId: _linkedLiabilityId,
      lastValuationDate: DateTime.now(),
      createdAt: widget.asset?.createdAt,
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
    final liabilitiesAsync = ref.watch(liabilitiesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? '${S.edit} ${S.assets}' : 'أصل جديد')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LabeledField(
            label: S.name,
            child: TextField(controller: _name),
          ),
          LabeledField(
            label: S.type,
            child: EnumDropdown<AssetType>(
              value: _type,
              items: AssetType.values,
              labelOf: (t) => t.label,
              onChanged: (t) => setState(() => _type = t),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LabeledField(
                  label: S.purchaseValue,
                  child: MoneyField(controller: _purchaseValue),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LabeledField(
                  label: S.currentValue,
                  child: MoneyField(controller: _currentValue),
                ),
              ),
            ],
          ),
          LabeledField(
            label: S.currency,
            child: CurrencyDropdown(
              value: _currency,
              onChanged: (v) => setState(() => _currency = v),
            ),
          ),
          LabeledField(
            label: S.purchaseDate,
            child: DatePickerField(
              value: _purchaseDate,
              onChanged: (d) => setState(() => _purchaseDate = d),
            ),
          ),
          LabeledField(
            label: S.ownershipStatus,
            child: EnumDropdown<OwnershipStatus>(
              value: _ownership,
              items: OwnershipStatus.values,
              labelOf: (t) => t.label,
              onChanged: (t) => setState(() => _ownership = t),
            ),
          ),
          LabeledField(
            label: S.linkedLiability,
            child: liabilitiesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
              data: (list) => DropdownButtonFormField<int?>(
                value: _linkedLiabilityId,
                isExpanded: true,
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('بدون')),
                  for (final l in list)
                    DropdownMenuItem<int?>(value: l.id, child: Text(l.name)),
                ],
                onChanged: (v) => setState(() => _linkedLiabilityId = v),
              ),
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
