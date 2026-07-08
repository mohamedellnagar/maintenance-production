import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/providers.dart';

enum PinMode { setup, unlock }

/// شاشة رمز PIN — إنشاء (setup) أو فتح (unlock)، مع دعم البصمة.
class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key, required this.mode});
  final PinMode mode;

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  String _entry = '';
  String? _firstEntry; // في وضع الإنشاء: أول إدخال قبل التأكيد
  String _error = '';
  bool _confirming = false;

  static const _len = 4;

  @override
  void initState() {
    super.initState();
    if (widget.mode == PinMode.unlock) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
    }
  }

  Future<void> _tryBiometric() async {
    final settings = await ref.read(settingsRepoProvider).get();
    if (!settings.biometricEnabled) return;
    final pin = ref.read(pinServiceProvider);
    if (!await pin.canUseBiometrics()) return;
    final ok = await pin.authenticateBiometric(S.unlockWithBiometric);
    if (ok && mounted) Navigator.of(context).pop(true);
  }

  void _onDigit(String d) {
    if (_entry.length >= _len) return;
    setState(() {
      _entry += d;
      _error = '';
    });
    if (_entry.length == _len) _onComplete();
  }

  void _onBackspace() {
    if (_entry.isEmpty) return;
    setState(() => _entry = _entry.substring(0, _entry.length - 1));
  }

  Future<void> _onComplete() async {
    final pin = ref.read(pinServiceProvider);
    if (widget.mode == PinMode.setup) {
      if (!_confirming) {
        setState(() {
          _firstEntry = _entry;
          _entry = '';
          _confirming = true;
        });
      } else {
        if (_entry == _firstEntry) {
          await pin.setPin(_entry);
          final repo = ref.read(settingsRepoProvider);
          final s = await repo.get();
          await repo.save(s.copyWith(pinEnabled: true));
          bumpRefreshFromWidget(ref);
          if (mounted) Navigator.of(context).pop(true);
        } else {
          setState(() {
            _error = S.pinMismatch;
            _entry = '';
            _firstEntry = null;
            _confirming = false;
          });
        }
      }
    } else {
      final ok = await pin.verifyPin(_entry);
      if (ok) {
        if (mounted) Navigator.of(context).pop(true);
      } else {
        setState(() {
          _error = S.wrongPin;
          _entry = '';
        });
      }
    }
  }

  String get _title {
    if (widget.mode == PinMode.unlock) return S.enterPin;
    return _confirming ? S.confirmPin : S.setupPin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.lock_rounded, size: 48, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(_title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _dots(),
            const SizedBox(height: 12),
            SizedBox(
              height: 20,
              child: Text(_error,
                  style: const TextStyle(color: AppColors.negative)),
            ),
            const Spacer(),
            _keypad(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_len, (i) {
        final filled = i < _entry.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? AppColors.primary : Colors.transparent,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
        );
      }),
    );
  }

  Widget _keypad() {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'bio', '0', 'del'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
        physics: const NeverScrollableScrollPhysics(),
        children: keys.map(_key).toList(),
      ),
    );
  }

  Widget _key(String k) {
    if (k == 'del') {
      return _TapKey(
        onTap: _onBackspace,
        child: const Icon(Icons.backspace_outlined),
      );
    }
    if (k == 'bio') {
      if (widget.mode != PinMode.unlock) return const SizedBox.shrink();
      return _TapKey(
        onTap: _tryBiometric,
        child: const Icon(Icons.fingerprint, color: AppColors.primary),
      );
    }
    return _TapKey(
      onTap: () => _onDigit(k),
      child: Text(k,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
    );
  }
}

class _TapKey extends StatelessWidget {
  const _TapKey({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Center(child: child),
      ),
    );
  }
}
