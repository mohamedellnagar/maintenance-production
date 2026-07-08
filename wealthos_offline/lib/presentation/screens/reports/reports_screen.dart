import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/providers.dart';

/// شاشة التقارير — ملخصات مالية وتصدير PDF.
class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(financialSummaryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(S.reports),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: S.exportPdf,
            onPressed: () => _exportPdf(context, ref),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (s) => ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _reportCard(S.netWorthReport, Icons.account_balance, [
              (S.netWorth, Fmt.money(s.netWorth, s.currency)),
              (S.totalAssets, Fmt.money(s.totalAssets, s.currency)),
              (S.totalLiabilities, Fmt.money(s.totalLiabilities, s.currency)),
            ]),
            _reportCard(S.cashFlowReport, Icons.swap_vert, [
              (S.monthlyIncome, Fmt.money(s.monthlyIncome, s.currency)),
              (S.monthlyExpenses, Fmt.money(s.monthlyExpenses, s.currency)),
              (S.monthlyCashFlow, Fmt.money(s.monthlyCashFlow, s.currency)),
              (S.savingRate, Fmt.percent(s.savingRate)),
            ]),
            _reportCard(S.financialHealthReport, Icons.favorite_outline, [
              (S.financialHealth, '${s.healthScore}/100 (${s.healthLabel})'),
              (S.liquidityRatio, Fmt.percent(s.liquidityRatio)),
              (S.debtRatio, Fmt.percent(s.debtRatio)),
            ]),
            _reportCard(S.assetsReport, Icons.pie_chart_outline, [
              for (final slice in s.allocation)
                (slice.type.label, Fmt.money(slice.value, s.currency)),
              if (s.allocation.isEmpty) ('—', '—'),
            ]),
            if (s.contributionsTotal > 0)
              _reportCard(S.contributionsReport, Icons.volunteer_activism, [
                (S.familyContribution,
                    Fmt.money(s.contributionsTotal, s.currency)),
              ]),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _exportPdf(context, ref),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text(S.exportPdf),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _reportCard(String title, IconData icon, List<(String, String)> rows) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            const Divider(),
            for (final r in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r.$1,
                        style:
                            const TextStyle(color: AppColors.textSecondary)),
                    Text(r.$2,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    final summary = await ref.read(calculationEngineProvider).compute();
    final bytes =
        await ref.read(reportServiceProvider).buildFinancialSummary(summary);
    await Printing.sharePdf(bytes: bytes, filename: 'wealthos_report.pdf');
  }
}
