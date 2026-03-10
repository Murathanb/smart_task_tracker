import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../features/auth/providers/auth_state_provider.dart';
import '../../../l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final notificationsEnabled = ref.watch(notificationsProvider);
    final user = ref.watch(authStateProvider).value;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : const Color(0xFF1C1C1F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFFEAEAE7)
                    : const Color(0xFF2C2C30),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8443A).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        color: Color(0xFFE8443A),
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName?.isNotEmpty == true
                            ? user!.displayName!
                            : 'Kullanıcı',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurface.withValues(alpha: 0.45),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          _SectionLabel(label: l10n.appearance),
          const SizedBox(height: 8),

          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.contrast_rounded,
                title: l10n.theme,
                trailing: _SegmentedThemePicker(
                  current: themeMode,
                  onChanged: (mode) =>
                      ref.read(themeProvider.notifier).setTheme(mode),
                ),
              ),
              const _Divider(),
              _SettingsTile(
                icon: Icons.language_rounded,
                title: l10n.language,
                trailing: _SegmentedLanguagePicker(
                  current: locale,
                  onChanged: (loc) =>
                      ref.read(localeProvider.notifier).setLocale(loc),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _SectionLabel(label: l10n.notifications),
          const SizedBox(height: 8),

          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: l10n.taskReminders,
                subtitle: l10n.taskRemindersDesc,
                trailing: Switch.adaptive(
                  value: notificationsEnabled,
                  onChanged: (val) =>
                      ref.read(notificationsProvider.notifier).toggle(val),
                  activeTrackColor: const Color(0xFFE8443A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _SectionLabel(label: l10n.account),
          const SizedBox(height: 8),

          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.logout_rounded,
                title: l10n.signOut,
                titleColor: const Color(0xFFE8443A),
                iconColor: const Color(0xFFE8443A),
                onTap: () => _showSignOutDialog(context, ref, l10n),
              ),
            ],
          ),

          const SizedBox(height: 40),

          Center(
            child: Text(
              l10n.version,
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurface.withValues(alpha: 0.25),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showSignOutDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOutTitle),
        content: Text(l10n.signOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              await ref.read(authServiceProvider).signOut();
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE8443A),
              minimumSize: const Size(0, 40),
            ),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF1C1C1F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLight
              ? const Color(0xFFEAEAE7)
              : const Color(0xFF2C2C30),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      leading: Icon(
        icon,
        color: iconColor ?? scheme.onSurface.withValues(alpha: 0.5),
        size: 21,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurface.withValues(alpha: 0.4),
              ),
            )
          : null,
      trailing: trailing,
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56,
      color: Theme.of(context)
          .colorScheme
          .onSurface
          .withValues(alpha: 0.06),
    );
  }
}

class _SegmentedThemePicker extends StatelessWidget {
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  const _SegmentedThemePicker({
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final options = [
      (ThemeMode.system, Icons.brightness_auto_rounded),
      (ThemeMode.light, Icons.light_mode_rounded),
      (ThemeMode.dark, Icons.dark_mode_rounded),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: options.map((opt) {
        final isSelected = current == opt.$1;
        return GestureDetector(
          onTap: () => onChanged(opt.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFE8443A).withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFE8443A).withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
            ),
            child: Icon(
              opt.$2,
              size: 17,
              color: isSelected
                  ? const Color(0xFFE8443A)
                  : scheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SegmentedLanguagePicker extends StatelessWidget {
  final Locale current;
  final ValueChanged<Locale> onChanged;

  const _SegmentedLanguagePicker({
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final options = [
      (const Locale('tr'), 'TR'),
      (const Locale('en'), 'EN'),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: options.map((opt) {
        final isSelected = current.languageCode == opt.$1.languageCode;
        return GestureDetector(
          onTap: () => onChanged(opt.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(left: 4),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFE8443A).withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFE8443A).withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
            ),
            child: Text(
              opt.$2,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? const Color(0xFFE8443A)
                    : scheme.onSurface.withValues(alpha: 0.35),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}