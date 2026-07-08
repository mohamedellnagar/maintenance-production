import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/providers.dart';

/// شاشة إعدادات العملات وأسعار التحويل (تُدخَل يدويًا في الـ MVP).
class CurrencyScreen extends ConsumerWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenciesAsync = ref.watch(currenciesProvider);
    final ratesAsync = ref.watch(ratesProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final base = settingsAsync.valueOrNull?.baseCurrency ?? 'AED';

    return Scaffold(
      appBar: AppBar(title: const Text(S.currency)),
      body: currenciesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (currencies) {
          final rates = ratesAsync.valueOrNull ?? [];
          final rateFor = {for (final r in rates) r.currencyCode: r.rateToBase};
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                color: AppColors.primary.withValues(alpha: 0.06),
                child: ListTile(
                  leading: const Icon(Icons.star, color: AppColors.primary),
                  title: const Text('العملة الأساسية'),
                  trailing: Text(base,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'أدخل سعر تحويل كل عملة مقابل عملتك الأساسية (كم تساوي وحدة واحدة).',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
              for (final c in currencies.where((c) => c.code != base))
                Card(
                  child: ListTile(
                    title: Text('${c.code} — ${c.name}'),
                    subtitle: Text(rateFor[c.code] != null
                        ? '1 ${c.code} = ${rateFor[c.code]} $base'
                        : 'لم يُحدَّد سعر'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editRate(
                          context, ref, c.code, base, rateFor[c.code]),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _editRate(BuildContext context, WidgetRef ref, String code,
      String base, double? current) async {
    final ctrl = TextEditingController(text: current?.toString() ?? '');
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('1 $code = ؟ $base'),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'السعر مقابل $base'),
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
    if (value != null && value > 0) {
      await ref.read(currencyRepoProvider).setRate(code, value);
      bumpRefreshFromWidget(ref);
    }
  }
}
