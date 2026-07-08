import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../providers/providers.dart';

/// قائمة منسدلة لاختيار العملة (تقرأ العملات من قاعدة البيانات).
class CurrencyDropdown extends ConsumerWidget {
  const CurrencyDropdown({super.key, required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenciesAsync = ref.watch(currenciesProvider);
    return currenciesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('$e'),
      data: (list) {
        final codes = list.map((c) => c.code).toList();
        final safe = codes.contains(value) ? value : (codes.isNotEmpty ? codes.first : value);
        return DropdownButtonFormField<String>(
          value: safe,
          items: [
            for (final c in list)
              DropdownMenuItem(value: c.code, child: Text('${c.code} — ${c.name}')),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        );
      },
    );
  }
}

/// حقل اختيار تاريخ.
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint = 'اختر التاريخ',
    this.allowClear = true,
  });

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String hint;
  final bool allowClear;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(1970),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
      icon: const Icon(Icons.calendar_today, size: 18),
      label: Row(
        children: [
          Text(value == null ? hint : Fmt.date(value!)),
          if (allowClear && value != null) ...[
            const Spacer(),
            InkWell(
              onTap: () => onChanged(null),
              child: const Icon(Icons.clear, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}

/// قائمة منسدلة عامة للـ enums مع دوال label.
class EnumDropdown<T> extends StatelessWidget {
  const EnumDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      items: [
        for (final item in items)
          DropdownMenuItem(value: item, child: Text(labelOf(item))),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

/// حقل إدخال مبلغ مالي.
class MoneyField extends StatelessWidget {
  const MoneyField({super.key, required this.controller, this.hint});
  final TextEditingController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(hintText: hint ?? '0', prefixIcon: const Icon(Icons.payments_outlined)),
    );
  }
}

/// زر حفظ عريض.
class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.onPressed, this.label = S.save});
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.check),
        label: Text(label),
      ),
    );
  }
}
