import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/expense.dart';
import '../../../data/models/goal.dart';
import '../../../data/models/income.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';
import '../main_shell.dart';

/// معالج الإعداد المالي الأولي (Onboarding Wizard) — يبني الملف المالي خطوة بخطوة.
class OnboardingWizard extends ConsumerStatefulWidget {
  const OnboardingWizard({super.key});

  @override
  ConsumerState<OnboardingWizard> createState() => _OnboardingWizardState();
}

class _OnboardingWizardState extends ConsumerState<OnboardingWizard> {
  final _controller = PageController();
  int _page = 0;
  bool _saving = false;

  // بيانات مجمّعة.
  final _nameCtrl = TextEditingController();
  final _birthYearCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController();
  final _expensesCtrl = TextEditingController();
  final _goalTitleCtrl = TextEditingController();
  final _goalAmountCtrl = TextEditingController();

  String _currency = 'AED';
  DateTime _analysisStart = DateTime(DateTime.now().year - 3, 1);

  final Map<String, bool> _flags = {
    'assets': false,
    'debts': false,
    'realEstate': false,
    'vehicle': false,
    'investments': false,
    'contributions': false,
    'family': false,
  };

  static const _pageCount = 6;

  @override
  void dispose() {
    _controller.dispose();
    _nameCtrl.dispose();
    _birthYearCtrl.dispose();
    _salaryCtrl.dispose();
    _expensesCtrl.dispose();
    _goalTitleCtrl.dispose();
    _goalAmountCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pageCount - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  void _prev() {
    if (_page > 0) {
      _controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    final settingsRepo = ref.read(settingsRepoProvider);
    final incomeRepo = ref.read(incomeRepoProvider);
    final expenseRepo = ref.read(expenseRepoProvider);
    final goalRepo = ref.read(goalRepoProvider);

    final current = await settingsRepo.get();
    await settingsRepo.save(current.copyWith(
      userName: _nameCtrl.text.trim(),
      birthYear: int.tryParse(_birthYearCtrl.text.trim()),
      baseCurrency: _currency,
      analysisStartDate: _analysisStart,
      hasFamily: _flags['family']!,
      onboardingCompleted: true,
    ));

    final salary = double.tryParse(_salaryCtrl.text.trim());
    if (salary != null && salary > 0) {
      final sourceId = await incomeRepo.createSource(
        IncomeSource(name: 'الراتب', type: IncomeType.salary, currency: _currency),
        source: AuditSource.wizard,
      );
      await incomeRepo.addHistory(
        IncomeHistory(sourceId: sourceId, amount: salary, fromDate: _analysisStart),
        source: AuditSource.wizard,
      );
    }

    final expenses = double.tryParse(_expensesCtrl.text.trim());
    if (expenses != null && expenses > 0) {
      final catId = await expenseRepo.createCategory(
        ExpenseCategory(
            name: 'المصروف الشهري',
            type: ExpenseType.living,
            currency: _currency),
        source: AuditSource.wizard,
      );
      await expenseRepo.addHistory(
        ExpenseHistory(categoryId: catId, amount: expenses, fromDate: _analysisStart),
        source: AuditSource.wizard,
      );
    }

    final goalAmount = double.tryParse(_goalAmountCtrl.text.trim());
    if (goalAmount != null && goalAmount > 0) {
      await goalRepo.create(
        Goal(
          title: _goalTitleCtrl.text.trim().isEmpty
              ? 'هدفي المالي'
              : _goalTitleCtrl.text.trim(),
          targetAmount: goalAmount,
          currency: _currency,
        ),
        source: AuditSource.wizard,
      );
    }

    bumpRefreshFromWidget(ref);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _progressBar(),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _welcomePage(),
                  _personalPage(),
                  _currencyPage(),
                  _financialsPage(),
                  _flagsPage(),
                  _goalPage(),
                ],
              ),
            ),
            _navButtons(),
          ],
        ),
      ),
    );
  }

  Widget _progressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: List.generate(_pageCount, (i) {
          final active = i <= _page;
          return Expanded(
            child: Container(
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _pageWrap({required String title, String? subtitle, required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _welcomePage() {
    return _pageWrap(
      title: S.welcome,
      subtitle: S.onboardingIntro,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Icon(Icons.savings_rounded,
              size: 120, color: AppColors.primary.withValues(alpha: 0.85)),
        ),
        const SizedBox(height: 24),
        _infoRow(Icons.lock_outline, 'بياناتك محفوظة على جهازك فقط، دون إنترنت.'),
        _infoRow(Icons.insights_outlined, 'يحسب التطبيق صافي ثروتك وتحليل وضعك تلقائيًا.'),
        _infoRow(Icons.edit_calendar_outlined, 'يمكنك تعديل كل شيء لاحقًا.'),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _personalPage() {
    return _pageWrap(
      title: 'بياناتك الأساسية',
      children: [
        LabeledField(
          label: S.name,
          child: TextField(
            controller: _nameCtrl,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: 'مثال: محمد'),
          ),
        ),
        LabeledField(
          label: S.birthYear,
          child: TextField(
            controller: _birthYearCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(hintText: 'مثال: 1990'),
          ),
        ),
      ],
    );
  }

  Widget _currencyPage() {
    final currenciesAsync = ref.watch(currenciesProvider);
    return _pageWrap(
      title: 'العملة والفترة',
      subtitle: 'اختر عملتك الأساسية وتاريخ بداية تحليلك المالي.',
      children: [
        LabeledField(
          label: S.baseCurrency,
          child: currenciesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (list) => DropdownButtonFormField<String>(
              value: _currency,
              items: [
                for (final c in list)
                  DropdownMenuItem(value: c.code, child: Text('${c.name} (${c.code})')),
              ],
              onChanged: (v) => setState(() => _currency = v ?? 'AED'),
            ),
          ),
        ),
        LabeledField(
          label: S.analysisStartDate,
          child: OutlinedButton.icon(
            onPressed: _pickAnalysisDate,
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text(
                '${_analysisStart.year}/${_analysisStart.month.toString().padLeft(2, '0')}'),
          ),
        ),
      ],
    );
  }

  Future<void> _pickAnalysisDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _analysisStart,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      helpText: S.analysisStartDate,
    );
    if (picked != null) setState(() => _analysisStart = DateTime(picked.year, picked.month));
  }

  Widget _financialsPage() {
    return _pageWrap(
      title: 'دخلك ومصروفك',
      subtitle: 'أدخل المتوسط الشهري الحالي (يمكن إضافة فترات تاريخية لاحقًا).',
      children: [
        LabeledField(
          label: '${S.currentSalary} ($_currency)',
          child: TextField(
            controller: _salaryCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'مثال: 15000'),
          ),
        ),
        LabeledField(
          label: '${S.monthlyExpensesAvg} ($_currency)',
          child: TextField(
            controller: _expensesCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'مثال: 8000'),
          ),
        ),
      ],
    );
  }

  Widget _flagsPage() {
    return _pageWrap(
      title: 'وضعك المالي',
      subtitle: 'أجب بنعم/لا لنساعدك في تنظيم ملفك.',
      children: [
        _toggle('assets', S.hasAssets),
        _toggle('debts', S.hasDebts),
        _toggle('realEstate', S.hasRealEstate),
        _toggle('vehicle', S.hasVehicle),
        _toggle('investments', S.hasInvestments),
        _toggle('contributions', S.hasFamilyContributions),
        _toggle('family', S.hasFamily),
      ],
    );
  }

  Widget _toggle(String key, String label) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: _flags[key]!,
      activeColor: AppColors.primary,
      onChanged: (v) => setState(() => _flags[key] = v),
    );
  }

  Widget _goalPage() {
    return _pageWrap(
      title: S.financialGoals,
      subtitle: 'حدّد هدفًا واحدًا للبدء (اختياري).',
      children: [
        LabeledField(
          label: 'اسم الهدف',
          child: TextField(
            controller: _goalTitleCtrl,
            decoration: const InputDecoration(hintText: 'مثال: الوصول لأول مليون'),
          ),
        ),
        LabeledField(
          label: 'المبلغ المستهدف ($_currency)',
          child: TextField(
            controller: _goalAmountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'مثال: 1000000'),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: AppColors.primary.withValues(alpha: 0.06),
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              'بعد الإنهاء ستنتقل إلى لوحة التحكم، ويمكنك إضافة الأصول والالتزامات بالتفصيل.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (_page > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _saving ? null : _prev,
                child: const Text(S.back),
              ),
            ),
          if (_page > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _saving ? null : _next,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(_page == _pageCount - 1 ? S.finish : S.next),
            ),
          ),
        ],
      ),
    );
  }
}
