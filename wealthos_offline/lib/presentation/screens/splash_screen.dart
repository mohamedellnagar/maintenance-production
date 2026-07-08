import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/providers.dart';
import 'main_shell.dart';
import 'onboarding/onboarding_wizard.dart';
import 'pin/pin_screen.dart';

/// شاشة البداية — تقرّر الوجهة (PIN / Onboarding / Dashboard).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  Future<void> _boot() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final settings = await ref.read(settingsRepoProvider).get();
    final pin = ref.read(pinServiceProvider);
    final hasPin = await pin.hasPin();
    if (!mounted) return;

    if (hasPin && settings.pinEnabled) {
      final ok = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const PinScreen(mode: PinMode.unlock)),
      );
      if (ok != true) {
        // فشل الفتح: أعد المحاولة بإعادة تشغيل التمهيد.
        if (mounted) _boot();
        return;
      }
    }
    if (!mounted) return;

    final Widget dest =
        settings.onboardingCompleted ? const MainShell() : const OnboardingWizard();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => dest),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.account_balance_wallet_rounded,
                  size: 52, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text(
              S.appName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              S.appTagline,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
            ),
            const SizedBox(height: 28),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                  strokeWidth: 2.4, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
