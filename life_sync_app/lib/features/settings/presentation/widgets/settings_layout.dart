import 'dart:typed_data';
import 'package:flutter/material.dart';

abstract final class SettingsStyle {
  static const blue = Color(0xFF4F7FFF);
  static const muted = Color(0xFF79788C);
  static const red = Color(0xFFFF4C4C);
  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF242431)
      : const Color(0xFFF8F7FD);
}

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    super.key,
    required this.children,
    this.outlined = false,
  });
  final List<Widget> children;
  final bool outlined;
  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: outlined
          ? Theme.of(context).scaffoldBackgroundColor
          : SettingsStyle.surface(context),
      borderRadius: BorderRadius.circular(18),
      border: outlined
          ? Border.all(color: Colors.grey.withValues(alpha: .18))
          : null,
    ),
    child: Material(
      type: MaterialType.transparency,
      child: Column(children: children),
    ),
  );
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.value,
    this.icon,
    this.trailing,
    this.onTap,
    this.danger = false,
  });
  final String title;
  final String? value;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    minLeadingWidth: 28,
    leading: icon == null
        ? null
        : Icon(
            icon,
            size: 24,
            color: danger ? SettingsStyle.red : SettingsStyle.blue,
          ),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: danger ? FontWeight.w600 : FontWeight.w400,
        color: danger ? SettingsStyle.red : null,
      ),
    ),
    trailing:
        trailing ??
        (danger
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (value != null)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * .40,
                      ),
                      child: Text(
                        value!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: SettingsStyle.muted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: SettingsStyle.muted,
                    size: 22,
                  ),
                ],
              )),
  );
}

class SettingsAvatar extends StatelessWidget {
  const SettingsAvatar({super.key, this.bytes, this.radius = 30});
  final Uint8List? bytes;
  final double radius;
  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: radius,
    backgroundColor: const Color(0xFFD8EAFF),
    backgroundImage: bytes == null ? null : MemoryImage(bytes!),
    child: bytes == null
        ? Icon(
            Icons.person_outline_rounded,
            color: SettingsStyle.blue,
            size: radius,
          )
        : null,
  );
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.onSave,
    this.profile = false,
  });
  final String title;
  final VoidCallback onBack;
  final VoidCallback? onSave;
  final bool profile;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 72,
    child: Row(
      children: [
        IconButton.filledTonal(
          tooltip: profile ? 'Close' : 'Back',
          style: IconButton.styleFrom(
            backgroundColor: SettingsStyle.surface(context),
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: onBack,
          icon: Icon(
            profile ? Icons.close : Icons.arrow_back_ios_new,
            size: 22,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        if (profile)
          IconButton.filledTonal(
            tooltip: 'Save profile',
            onPressed: onSave,
            style: IconButton.styleFrom(
              backgroundColor: SettingsStyle.surface(context),
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            icon: const Icon(Icons.check, size: 22),
          )
        else
          const SizedBox(width: 48),
      ],
    ),
  );
}

class SettingsLayout extends StatelessWidget {
  const SettingsLayout({
    super.key,
    required this.name,
    required this.email,
    required this.counts,
    required this.appearance,
    required this.firstDay,
    required this.onBack,
    required this.onProfile,
    required this.onAppearance,
    required this.onFirstDay,
    required this.onLanguage,
    required this.onPasscode,
    required this.onReminder,
    required this.onLogout,
    this.avatar,
    this.more,
  });
  final String name, email, appearance, firstDay;
  final List<int> counts;
  final Uint8List? avatar;
  final VoidCallback onBack,
      onProfile,
      onAppearance,
      onFirstDay,
      onLanguage,
      onPasscode,
      onReminder,
      onLogout;
  final Widget? more;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          SettingsHeader(title: 'Setting', onBack: onBack),
          const SizedBox(height: 16),
          SettingsGroup(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  onTap: onProfile,
                  leading: SettingsAvatar(bytes: avatar),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    email,
                    style: const TextStyle(
                      color: SettingsStyle.muted,
                      fontSize: 14,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: SettingsStyle.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 3 ? 0 : 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: SettingsStyle.surface(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          [
                            Icons.edit_note_outlined,
                            Icons.track_changes,
                            Icons.event_repeat_outlined,
                            Icons.edit_outlined,
                          ][index],
                          color: SettingsStyle.blue,
                          size: 23,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ['Tasks', 'Goals', 'Habit', 'Journal'][index],
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: SettingsStyle.muted,
                                ),
                              ),
                              Text(
                                '${counts[index]}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Settings & Personalization',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          SettingsGroup(
            children: [
              SettingsRow(
                title: 'Appearance',
                value: appearance,
                icon: Icons.format_paint_outlined,
                onTap: onAppearance,
              ),
              SettingsRow(
                title: 'First Day of the Week',
                value: firstDay,
                icon: Icons.calendar_today_outlined,
                onTap: onFirstDay,
              ),
              SettingsRow(
                title: 'Language',
                value: 'English',
                icon: Icons.language,
                onTap: onLanguage,
              ),
              SettingsRow(
                title: 'Add Passcode',
                icon: Icons.lock_outline,
                onTap: onPasscode,
              ),
              SettingsRow(
                title: 'Reminder',
                icon: Icons.notifications_none,
                onTap: onReminder,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SettingsGroup(
            children: [
              SettingsRow(
                title: 'Log out',
                icon: Icons.logout,
                danger: true,
                onTap: onLogout,
              ),
            ],
          ),
          ?more,
        ],
      ),
    ),
  );
}

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({
    super.key,
    required this.name,
    required this.email,
    required this.onClose,
    required this.onSave,
    required this.onAvatar,
    required this.onName,
    required this.onEmail,
    required this.onPassword,
    required this.onProvider,
    required this.onDelete,
    this.avatar,
    this.extra,
    this.error,
  });
  final String name, email;
  final String? error;
  final Uint8List? avatar;
  final VoidCallback onClose, onAvatar, onName, onEmail, onPassword, onDelete;
  final VoidCallback? onSave;
  final ValueChanged<String> onProvider;
  final Widget? extra;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsHeader(
                      title: 'Profile',
                      profile: true,
                      onBack: onClose,
                      onSave: onSave,
                    ),
                    const SizedBox(height: 28),
                    SettingsGroup(
                      children: [
                        SettingsRow(
                          title: 'Avatar',
                          trailing: SettingsAvatar(bytes: avatar, radius: 15),
                          onTap: onAvatar,
                        ),
                        SettingsRow(title: 'Name', value: name, onTap: onName),
                        SettingsRow(
                          title: 'Email',
                          value: email,
                          onTap: onEmail,
                        ),
                        SettingsRow(
                          title: 'Change Password',
                          onTap: onPassword,
                        ),
                      ],
                    ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          error!,
                          style: const TextStyle(color: SettingsStyle.red),
                        ),
                      ),
                    const SizedBox(height: 26),
                    const Text(
                      'Third Party Connection',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SettingsGroup(
                      outlined: true,
                      children: [
                        for (final provider in ['Facebook', 'Google', 'Apple'])
                          SettingsRow(
                            title: provider,
                            value: 'Not Linked',
                            icon: provider == 'Facebook'
                                ? Icons.facebook
                                : provider == 'Apple'
                                ? Icons.apple
                                : Icons.g_mobiledata,
                            onTap: () => onProvider(provider),
                          ),
                      ],
                    ),
                    ?extra,
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: SettingsGroup(
                    children: [
                      SettingsRow(
                        title: 'Delete Account',
                        icon: Icons.delete_outline,
                        danger: true,
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
