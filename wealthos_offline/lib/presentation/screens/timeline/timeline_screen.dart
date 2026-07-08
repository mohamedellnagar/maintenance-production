import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/timeline_event.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';

/// شاشة المسار الزمني — رحلة المستخدم المالية سنة بسنة.
class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(timelineProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(S.timeline)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (events) {
          if (events.isEmpty) {
            return const EmptyState(
              title: 'لا توجد أحداث بعد',
              subtitle: 'كل تغيير مالي سيظهر هنا تلقائيًا',
              icon: Icons.timeline,
            );
          }
          // تجميع حسب السنة.
          final byYear = <int, List<TimelineEvent>>{};
          for (final e in events) {
            byYear.putIfAbsent(e.eventDate.year, () => []).add(e);
          }
          final years = byYear.keys.toList()..sort((a, b) => b.compareTo(a));
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              for (final year in years) ...[
                _YearHeader(year: year),
                ...byYear[year]!.map((e) => _EventTile(event: e)),
              ],
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _YearHeader extends StatelessWidget {
  const _YearHeader({required this.year});
  final int year;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('$year',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});
  final TimelineEvent event;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: Text(event.type.icon,
                        style: const TextStyle(fontSize: 16))),
              ),
              Expanded(
                child: Container(
                    width: 2,
                    color: AppColors.primary.withValues(alpha: 0.15)),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(event.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                        ),
                        if (event.amount != null)
                          Text(Fmt.money(event.amount!, event.currency ?? ''),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${event.type.label} • ${Fmt.date(event.eventDate)}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    if (event.description != null) ...[
                      const SizedBox(height: 4),
                      Text(event.description!,
                          style: const TextStyle(fontSize: 13)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
