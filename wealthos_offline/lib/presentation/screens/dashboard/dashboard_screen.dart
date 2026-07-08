import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/providers.dart';
import '../../../services/calculation_engine.dart';
import '../../widgets/common.dart';
import '../chat/chat_screen.dart';
import 'widgets/allocation_chart.dart';
import 'widgets/net_worth_chart.dart';

/// لوحة التحكم — كل المؤشرات المالية والرسوم البيانية.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financialSummaryProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final name = settingsAsync.valueOrNull?.userName ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(S.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: S.chat,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ChatScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => bumpRefreshFromWidget(ref),
        child: summaryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(children: [
            const SizedBox(height: 80),
            Center(child: Text('خطأ في الحساب: $e')),
          ]),
          data: (s) => _DashboardBody(summary: s, userName: name),
        ),
      ),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.summary, required this.userName});
  final FinancialSummary summary;
  final String userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = summary;
    final cur = s.currency;
    final timelineAsync = ref.watch(netWorthTimelineProvider);

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        if (userName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 4),
            child: Text('مرحبًا، $userName 👋',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ),

        // بطاقة صافي الثروة البارزة.
        _NetWorthHero(summary: s),
        const SizedBox(height: 8),

        // شبكة المؤشرات.
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.35,
          children: [
            StatCard(
                label: S.totalAssets,
                value: Fmt.money(s.totalAssets, cur),
                icon: Icons.trending_up,
                color: AppColors.positive),
            StatCard(
                label: S.totalLiabilities,
                value: Fmt.money(s.totalLiabilities, cur),
                icon: Icons.trending_down,
                color: AppColors.negative),
            StatCard(
                label: S.cash,
                value: Fmt.money(s.cash, cur),
                icon: Icons.account_balance_wallet_outlined,
                color: AppColors.neutral),
            StatCard(
                label: S.monthlyCashFlow,
                value: Fmt.money(s.monthlyCashFlow, cur),
                icon: Icons.swap_vert,
                color: s.monthlyCashFlow >= 0
                    ? AppColors.positive
                    : AppColors.negative),
            StatCard(
                label: S.monthlyIncome,
                value: Fmt.money(s.monthlyIncome, cur),
                icon: Icons.south_west,
                color: AppColors.positive),
            StatCard(
                label: S.monthlyExpenses,
                value: Fmt.money(s.monthlyExpenses, cur),
                icon: Icons.north_east,
                color: AppColors.negative),
            StatCard(
                label: S.savingRate,
                value: Fmt.percent(s.savingRate),
                icon: Icons.savings_outlined,
                color: AppColors.primary),
            StatCard(
                label: S.debtRatio,
                value: Fmt.percent(s.debtRatio),
                icon: Icons.percent,
                color: AppColors.accent),
          ],
        ),

        const SectionHeader(S.financialHealth),
        _HealthCard(summary: s),

        const SectionHeader(S.netWorthTimeline),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 12, 8),
            child: SizedBox(
              height: 200,
              child: timelineAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (points) => points.length < 2
                    ? const EmptyState(title: S.emptyState)
                    : NetWorthChart(points: points, currency: cur),
              ),
            ),
          ),
        ),

        const SectionHeader(S.assetsAllocation),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: s.allocation.isEmpty
                ? const SizedBox(
                    height: 120, child: EmptyState(title: S.emptyState))
                : AllocationChart(slices: s.allocation, currency: cur),
          ),
        ),

        const SectionHeader(S.upcomingPayments),
        if (s.upcomingLiabilities.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: EmptyState(
                  title: 'لا توجد التزامات قادمة', icon: Icons.event_available),
            ),
          )
        else
          ...s.upcomingLiabilities.map((l) => Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFDEBEC),
                    child: Icon(Icons.event, color: AppColors.negative),
                  ),
                  title: Text(l.name),
                  subtitle: Text(
                      '${l.type.label} • استحقاق ${l.dueDate != null ? Fmt.date(l.dueDate!) : '-'}'),
                  trailing: Text(
                    Fmt.money(l.monthlyPayment > 0 ? l.monthlyPayment : l.remainingAmount, l.currency),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.negative),
                  ),
                ),
              )),

        if (s.contributionsTotal > 0) ...[
          const SectionHeader(S.contributions),
          Card(
            child: ListTile(
              leading: const Icon(Icons.volunteer_activism_outlined,
                  color: AppColors.accent),
              title: const Text(S.familyContribution),
              subtitle: const Text('لا تُحتسب ضمن صافي الثروة'),
              trailing: Text(Fmt.money(s.contributionsTotal, cur),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

class _NetWorthHero extends StatelessWidget {
  const _NetWorthHero({required this.summary});
  final FinancialSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance,
                    color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(S.netWorth,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 15)),
              ],
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                Fmt.money(summary.netWorth, summary.currency),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'السيولة ${Fmt.percent(summary.liquidityRatio)} • '
              'الديون ${Fmt.percent(summary.debtRatio)}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  const _HealthCard({required this.summary});
  final FinancialSummary summary;

  Color get _color {
    final s = summary.healthScore;
    if (s >= 60) return AppColors.positive;
    if (s >= 40) return AppColors.accent;
    return AppColors.negative;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 68,
              height: 68,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 68,
                    height: 68,
                    child: CircularProgressIndicator(
                      value: summary.healthScore / 100,
                      strokeWidth: 7,
                      backgroundColor: _color.withValues(alpha: 0.15),
                      color: _color,
                    ),
                  ),
                  Text('${summary.healthScore}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _color)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(summary.healthLabel,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _color)),
                  const SizedBox(height: 4),
                  const Text(
                    'يُحتسب من: الادخار، الديون، السيولة، تنوّع الأصول، صندوق الطوارئ، نمو الثروة.',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
