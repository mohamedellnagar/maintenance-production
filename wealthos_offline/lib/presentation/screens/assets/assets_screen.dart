import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/asset.dart';
import '../../../providers/providers.dart';
import '../../widgets/common.dart';
import 'asset_form_screen.dart';

/// شاشة قائمة الأصول.
class AssetsScreen extends ConsumerWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(assetsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(S.assets)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text(S.add),
      ),
      body: assetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (assets) {
          if (assets.isEmpty) {
            return const EmptyState(
              title: S.emptyState,
              subtitle: S.noDataAddFirst,
              icon: Icons.savings_outlined,
            );
          }
          final total = assets.fold<double>(0, (s, a) => s + a.currentValue);
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                color: AppColors.positive.withValues(alpha: 0.08),
                child: ListTile(
                  leading: const Icon(Icons.trending_up,
                      color: AppColors.positive),
                  title: const Text(S.totalAssets),
                  trailing: Text(
                    Fmt.money(total),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.positive),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ...assets.map((a) => _AssetTile(asset: a)),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }

  void _openForm(BuildContext context, [Asset? asset]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AssetFormScreen(asset: asset)),
    );
  }
}

class _AssetTile extends ConsumerWidget {
  const _AssetTile({required this.asset});
  final Asset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gain = asset.currentValue - asset.purchaseValue;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: Text(asset.type.label.characters.first,
              style: const TextStyle(color: AppColors.primary)),
        ),
        title: Text(asset.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
            '${asset.type.label} • ${asset.ownershipStatus.label}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(Fmt.money(asset.currentValue, asset.currency),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (asset.purchaseValue > 0 && gain != 0)
              Text(
                '${gain > 0 ? '▲' : '▼'} ${Fmt.compact(gain.abs())}',
                style: TextStyle(
                    fontSize: 11,
                    color: gain > 0 ? AppColors.positive : AppColors.negative),
              ),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AssetFormScreen(asset: asset)),
        ),
        onLongPress: () => _actions(context, ref),
      ),
    );
  }

  void _actions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sell_outlined),
              title: const Text('تسجيل بيع'),
              onTap: () {
                Navigator.pop(context);
                _sell(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.negative),
              title: const Text(S.delete,
                  style: TextStyle(color: AppColors.negative)),
              onTap: () async {
                Navigator.pop(context);
                await ref.read(assetRepoProvider).delete(asset.id!);
                bumpRefreshFromWidget(ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sell(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(text: asset.currentValue.toStringAsFixed(0));
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('بيع ${asset.name}'),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'مبلغ البيع'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text(S.cancel)),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(ctx, double.tryParse(ctrl.text) ?? asset.currentValue),
            child: const Text(S.confirm),
          ),
        ],
      ),
    );
    if (value != null) {
      await ref.read(assetRepoProvider).sell(asset.id!, value);
      bumpRefreshFromWidget(ref);
    }
  }
}
