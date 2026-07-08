import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/providers.dart';

/// شاشة النسخ الاحتياطي والاستعادة (ملف مشفّر محلي، بدون سحابة).
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;

  Future<String?> _askPassword(String title) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'كلمة مرور النسخة'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text(S.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: const Text(S.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _export() async {
    final password = await _askPassword('تشفير النسخة الاحتياطية');
    if (password == null || password.isEmpty) return;
    setState(() => _busy = true);
    try {
      final file = await ref.read(backupServiceProvider).exportBackup(password);
      if (!mounted) return;
      await Share.shareXFiles([XFile(file.path)],
          text: 'WealthOS Backup');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إنشاء النسخة: ${file.path.split('/').last}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('فشل التصدير: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final picked = await FilePicker.platform.pickFiles(type: FileType.any);
    if (picked == null || picked.files.single.path == null) return;
    final password = await _askPassword('فكّ تشفير النسخة');
    if (password == null || password.isEmpty) return;
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('استيراد نسخة'),
        content: const Text(
            'سيتم استبدال جميع البيانات الحالية بمحتوى النسخة. هل تريد المتابعة؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(S.cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.negative),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(S.confirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      final content = await File(picked.files.single.path!).readAsString();
      await ref.read(backupServiceProvider).importBackup(content, password);
      bumpRefreshFromWidget(ref);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت الاستعادة بنجاح')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('فشل الاستيراد: كلمة مرور خاطئة أو ملف تالف')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(S.backup)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: AppColors.primary.withValues(alpha: 0.06),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, color: AppColors.primary),
                    SizedBox(width: 12),
                    Expanded(child: Text(S.backupEncrypted)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _ActionCard(
              icon: Icons.upload_file,
              title: S.exportBackup,
              subtitle: 'ينشئ ملفًا مشفّرًا يمكنك حفظه أو مشاركته.',
              onTap: _busy ? null : _export,
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.download,
              title: S.importBackup,
              subtitle: 'يستعيد بياناتك من ملف نسخة سابق.',
              onTap: _busy ? null : _import,
            ),
            if (_busy) ...[
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
