import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';

/// شاشة سجل التدقيق — يعرض كل تعديل تم على البيانات.
class AuditScreen extends ConsumerWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(auditProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('سجل التدقيق')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (logs) => logs.isEmpty
            ? const EmptyState(title: 'لا يوجد سجل بعد', icon: Icons.fact_check_outlined)
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: logs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final log = logs[i];
                  return ListTile(
                    leading: _actionIcon(log.action),
                    title: Text(log.summary ?? '${log.tableName} #${log.recordId ?? ''}'),
                    subtitle: Text(
                        '${_sourceLabel(log.source)} • ${Fmt.date(log.createdAt)}'),
                    dense: true,
                  );
                },
              ),
      ),
    );
  }

  Widget _actionIcon(AuditAction action) {
    final (icon, color) = switch (action) {
      AuditAction.create => (Icons.add_circle_outline, AppColors.positive),
      AuditAction.update => (Icons.edit_outlined, AppColors.neutral),
      AuditAction.delete => (Icons.remove_circle_outline, AppColors.negative),
    };
    return Icon(icon, color: color);
  }

  String _sourceLabel(AuditSource source) => switch (source) {
        AuditSource.manual => 'يدوي',
        AuditSource.chat => 'المساعد',
        AuditSource.wizard => 'الإعداد',
      };
}
