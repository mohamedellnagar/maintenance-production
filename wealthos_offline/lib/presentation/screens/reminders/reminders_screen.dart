import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/reminder.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';
import '../../widgets/form_fields.dart';

/// شاشة التنبيهات المحلية (Offline).
class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(remindersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(S.reminders)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add),
        label: const Text(S.add),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => list.isEmpty
            ? const EmptyState(
                title: S.emptyState,
                subtitle: 'أضف تنبيهًا لقسط قادم أو مراجعة شهرية',
                icon: Icons.notifications_outlined)
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (final r in list)
                    Card(
                      child: CheckboxListTile(
                        value: r.isDone,
                        activeColor: AppColors.primary,
                        onChanged: (v) async {
                          final done = v ?? false;
                          await ref
                              .read(reminderRepoProvider)
                              .markDone(r.id!, done);
                          final notifier =
                              ref.read(notificationServiceProvider);
                          if (done) {
                            await notifier.cancel(r.id!);
                          } else {
                            await notifier.schedule(
                              id: r.id!,
                              title: r.title,
                              body: r.body ?? r.type.label,
                              when: r.dueDate,
                            );
                          }
                          bumpRefreshFromWidget(ref);
                        },
                        title: Text(r.title,
                            style: TextStyle(
                                decoration: r.isDone
                                    ? TextDecoration.lineThrough
                                    : null)),
                        subtitle: Text(
                            '${r.type.label} • ${Fmt.date(r.dueDate)}'),
                        secondary: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await ref
                                .read(reminderRepoProvider)
                                .delete(r.id!);
                            await ref
                                .read(notificationServiceProvider)
                                .cancel(r.id!);
                            bumpRefreshFromWidget(ref);
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Reminder>(
      context: context,
      builder: (_) => const _ReminderDialog(),
    );
    if (result != null) {
      final id = await ref.read(reminderRepoProvider).create(result);
      await ref.read(notificationServiceProvider).schedule(
            id: id,
            title: result.title,
            body: result.body ?? result.type.label,
            when: result.dueDate,
          );
      bumpRefreshFromWidget(ref);
    }
  }
}

class _ReminderDialog extends StatefulWidget {
  const _ReminderDialog();

  @override
  State<_ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<_ReminderDialog> {
  final _title = TextEditingController();
  ReminderType _type = ReminderType.upcomingPayment;
  DateTime _due = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تنبيه جديد'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'العنوان')),
          const SizedBox(height: 12),
          EnumDropdown<ReminderType>(
            value: _type,
            items: ReminderType.values,
            labelOf: (t) => t.label,
            onChanged: (t) => setState(() => _type = t),
          ),
          const SizedBox(height: 12),
          DatePickerField(
            value: _due,
            allowClear: false,
            onChanged: (d) => setState(() => _due = d ?? _due),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(S.cancel)),
        ElevatedButton(
          onPressed: () {
            if (_title.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              Reminder(type: _type, title: _title.text.trim(), dueDate: _due),
            );
          },
          child: const Text(S.save),
        ),
      ],
    );
  }
}
