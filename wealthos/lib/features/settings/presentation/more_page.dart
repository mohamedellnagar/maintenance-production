import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_spacing.dart';

/// The "More" tab: a small menu that keeps the bottom bar uncluttered while
/// still giving one-tap access to every secondary destination.
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.moreTitle)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.lg,
              AppSpacing.screen,
              AppSpacing.xs,
            ),
            child: Text(
              l.moreSectionTools,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event_repeat_outlined),
            title: Text(l.navRecurring),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.recurring),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l.navSettings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
    );
  }
}
