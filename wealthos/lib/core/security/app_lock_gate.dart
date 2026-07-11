import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/application/settings_providers.dart';
import '../di/providers.dart';
import '../localization/generated/app_localizations.dart';
import '../theme/app_spacing.dart';

/// Gates the app behind biometric authentication when the setting is enabled.
///
/// This is also the natural place to add a privacy screen (blur/overlay in the
/// app switcher) in a later phase — the lock state already lives here.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> {
  bool _unlocked = false;
  bool _authInProgress = false;

  Future<void> _authenticate() async {
    if (_authInProgress) return;
    final l = AppLocalizations.of(context);
    setState(() => _authInProgress = true);
    final ok = await ref
        .read(biometricServiceProvider)
        .authenticate(l.lockReason);
    if (!mounted) return;
    setState(() {
      _authInProgress = false;
      _unlocked = ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(currentSettingsProvider);
    final biometricEnabled = settings?.biometricEnabled ?? false;

    if (!biometricEnabled || _unlocked) {
      return widget.child;
    }
    return _LockScreen(inProgress: _authInProgress, onUnlock: _authenticate);
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({required this.inProgress, required this.onUnlock});

  final bool inProgress;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 56,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l.lockTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: inProgress ? null : onUnlock,
                icon: const Icon(Icons.fingerprint),
                label: Text(l.lockUnlock),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
