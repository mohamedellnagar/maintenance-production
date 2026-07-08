import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/providers.dart';
import '../backup/backup_screen.dart';
import '../pin/pin_screen.dart';
import 'currency_screen.dart';

/// شاشة الإعدادات العامة والأمان.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(S.settings)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (s) => ListView(
          children: [
            _section('الملف الشخصي'),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text(S.name),
              subtitle: Text(s.userName.isEmpty ? '—' : s.userName),
            ),
            ListTile(
              leading: const Icon(Icons.cake_outlined),
              title: const Text(S.birthYear),
              subtitle: Text('${s.birthYear ?? '—'}'),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text(S.baseCurrency),
              subtitle: Text(s.baseCurrency),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CurrencyScreen()),
              ),
            ),
            _section('الأمان'),
            SwitchListTile(
              secondary: const Icon(Icons.pin_outlined),
              title: const Text('قفل بـ PIN'),
              value: s.pinEnabled,
              activeColor: AppColors.primary,
              onChanged: (v) => _togglePin(context, ref, v, s.pinEnabled),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: const Text('فتح بالبصمة'),
              subtitle: const Text('يتطلب تفعيل PIN أولًا'),
              value: s.biometricEnabled,
              activeColor: AppColors.primary,
              onChanged: !s.pinEnabled
                  ? null
                  : (v) async {
                      final canBio =
                          await ref.read(pinServiceProvider).canUseBiometrics();
                      if (v && !canBio) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('الجهاز لا يدعم المصادقة البيومترية')),
                          );
                        }
                        return;
                      }
                      final repo = ref.read(settingsRepoProvider);
                      await repo.save(s.copyWith(biometricEnabled: v));
                      bumpRefreshFromWidget(ref);
                    },
            ),
            ListTile(
              leading: const Icon(Icons.lock_reset),
              title: const Text('تغيير رمز PIN'),
              enabled: s.pinEnabled,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const PinScreen(mode: PinMode.setup)),
              ),
            ),
            _section('البيانات'),
            ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: const Text(S.backup),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BackupScreen()),
              ),
            ),
            const _PrivacyNote(),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.primary)),
      );

  Future<void> _togglePin(
      BuildContext context, WidgetRef ref, bool enable, bool current) async {
    if (enable && !current) {
      // إنشاء PIN جديد.
      final ok = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const PinScreen(mode: PinMode.setup)),
      );
      if (ok == true) bumpRefreshFromWidget(ref);
    } else if (!enable && current) {
      await ref.read(pinServiceProvider).clearPin();
      final repo = ref.read(settingsRepoProvider);
      final s = await repo.get();
      await repo.save(s.copyWith(pinEnabled: false, biometricEnabled: false));
      bumpRefreshFromWidget(ref);
    }
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: AppColors.primary.withValues(alpha: 0.06),
        child: const Padding(
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.primary),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'كل بياناتك مخزّنة على جهازك فقط. لا يوجد أي اتصال بالإنترنت '
                  'ولا تحليلات، والحقول الحساسة مشفّرة.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
