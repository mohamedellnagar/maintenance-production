import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/utils/formatters.dart';
import 'calculation_engine.dart';

/// خدمة توليد تقارير PDF من الملخص المالي.
///
/// ملاحظة: لعرض العربية بشكل صحيح داخل PDF يلزم تضمين خط عربي (TTF) في
/// `assets/fonts` وتمريره عبر `pw.ThemeData.withFont`. في هذا الـ MVP يُصدَّر
/// التقرير بعناوين لاتينية وأرقام لضمان عمله دون اتصال ودون خطوط إضافية،
/// بينما تُعرض التقارير كاملةً بالعربية داخل التطبيق.
class ReportService {
  /// بناء تقرير ملخص مالي شامل بصيغة PDF.
  Future<Uint8List> buildFinancialSummary(FinancialSummary s) async {
    final doc = pw.Document();
    final cur = s.currency;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('WealthOS — Financial Report',
                style: pw.TextStyle(
                    fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text('Base currency: $cur',
                style: const pw.TextStyle(color: PdfColors.grey700)),
            pw.Divider(),
            pw.SizedBox(height: 10),
            _kv('Net Worth', Fmt.money(s.netWorth, cur), bold: true),
            _kv('Total Assets', Fmt.money(s.totalAssets, cur)),
            _kv('Total Liabilities', Fmt.money(s.totalLiabilities, cur)),
            _kv('Cash', Fmt.money(s.cash, cur)),
            pw.SizedBox(height: 10),
            _kv('Monthly Income', Fmt.money(s.monthlyIncome, cur)),
            _kv('Monthly Expenses', Fmt.money(s.monthlyExpenses, cur)),
            _kv('Monthly Cash Flow', Fmt.money(s.monthlyCashFlow, cur)),
            pw.SizedBox(height: 10),
            _kv('Saving Rate', Fmt.percent(s.savingRate)),
            _kv('Liquidity Ratio', Fmt.percent(s.liquidityRatio)),
            _kv('Debt Ratio', Fmt.percent(s.debtRatio)),
            _kv('Financial Health', '${s.healthScore}/100'),
            pw.SizedBox(height: 16),
            pw.Text('Assets Allocation',
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              children: [
                _row(['Type', 'Value'], header: true),
                for (final slice in s.allocation)
                  _row([slice.type.name, Fmt.money(slice.value, cur)]),
              ],
            ),
            if (s.contributionsTotal > 0) ...[
              pw.SizedBox(height: 12),
              _kv('Family Contributions (excluded from net worth)',
                  Fmt.money(s.contributionsTotal, cur)),
            ],
            pw.Spacer(),
            pw.Text(
              'Generated offline by WealthOS. All data stays on device.',
              style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 10),
            ),
          ],
        ),
      ),
    );

    return doc.save();
  }

  pw.Widget _kv(String key, String value, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(key,
              style: pw.TextStyle(
                  fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.Text(value,
              style: pw.TextStyle(
                  fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
                  fontSize: bold ? 15 : 12)),
        ],
      ),
    );
  }

  pw.TableRow _row(List<String> cells, {bool header = false}) {
    return pw.TableRow(
      decoration: header
          ? const pw.BoxDecoration(color: PdfColors.grey200)
          : null,
      children: [
        for (final c in cells)
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(c,
                style: pw.TextStyle(
                    fontWeight:
                        header ? pw.FontWeight.bold : pw.FontWeight.normal)),
          ),
      ],
    );
  }
}
