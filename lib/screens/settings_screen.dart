import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/bottom_nav.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(AppConstants.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.signOut();

      if (context.mounted) {
        if (success) {
          context.navigateClearStack(AppConstants.routeLogin);
        } else if (authProvider.error != null) {
          context.showError(authProvider.error!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Assistant Mode Section
          _buildSectionHeader('🎯 ASSISTANT MODE'),

          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              return Column(
                children: AppConstants.assistantModes.map((mode) {
                  // ignore: deprecated_member_use
                  return RadioListTile<String>(
                    value: mode,
                    // ignore: deprecated_member_use
                    groupValue: settingsProvider.assistantMode,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value != null) {
                        settingsProvider.setAssistantMode(value);
                      }
                    },
                    title: Row(
                      children: [
                        Text(AppConstants.modeEmojis[mode] ?? ''),
                        const SizedBox(width: AppConstants.spaceSm),
                        Text(mode.capitalize()),
                      ],
                    ),
                    subtitle: Text(
                      AppConstants.modeDescriptions[mode] ?? '',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const Divider(),

          // Appearance Section
          _buildSectionHeader('🎨 APPEARANCE'),

          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: const Text('Accent Color'),
                    subtitle: Text(
                      settingsProvider.accentColor.capitalize(),
                      style: const TextStyle(color: AppConstants.textSecondary),
                    ),
                    trailing: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppConstants.getAccentColor(
                          settingsProvider.accentColor,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: () => _showColorPicker(context),
                  ),

                  const ListTile(
                    leading: Icon(Icons.dark_mode_outlined),
                    title: Text('Theme'),
                    subtitle: Text(
                      'Dark (MVP only)',
                      style: TextStyle(color: AppConstants.textSecondary),
                    ),
                    trailing: Chip(
                      label: Text('Dark'),
                      backgroundColor: AppConstants.neutralSurface,
                    ),
                  ),
                ],
              );
            },
          ),

          const Divider(),

          // Sound & Voice Section
          _buildSectionHeader('🔊 SOUND & VOICE'),

          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              return Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.volume_up_outlined),
                    title: const Text('Text-to-Speech'),
                    subtitle: const Text('Read AI responses aloud'),
                    value: settingsProvider.soundEnabled,
                    onChanged: (value) {
                      settingsProvider.setSoundEnabled(value);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.speed_outlined),
                    title: const Text('Voice Speed'),
                    subtitle: Text(
                      '${settingsProvider.voiceSpeed.toStringAsFixed(2)}x',
                      style: const TextStyle(color: AppConstants.textSecondary),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed:
                              settingsProvider.voiceSpeed >
                                  AppConstants.minVoiceSpeed
                              ? () => settingsProvider.decreaseVoiceSpeed()
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed:
                              settingsProvider.voiceSpeed <
                                  AppConstants.maxVoiceSpeed
                              ? () => settingsProvider.increaseVoiceSpeed()
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          const Divider(),

          // Notifications Section
          _buildSectionHeader('🔔 NOTIFICATIONS'),

          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              return SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Push Notifications'),
                subtitle: const Text('Get notified about updates'),
                value: settingsProvider.notificationsEnabled,
                onChanged: (value) {
                  settingsProvider.setNotificationsEnabled(value);
                },
              );
            },
          ),

          const Divider(),

          // About Section
          _buildSectionHeader('ℹ️ ABOUT'),

          const ListTile(
            leading: Icon(Icons.info_outlined),
            title: Text('Version'),
            subtitle: Text(AppConstants.appVersion),
          ),

          const ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text('About EchoAI'),
            subtitle: Text(AppConstants.appDescription),
          ),

          const Divider(),

          // Account Section
          _buildSectionHeader('🚪 ACCOUNT'),

          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outlined),
                    title: const Text('Signed in as'),
                    subtitle: Text(
                      authProvider.currentUser?.email ?? 'Not signed in',
                    ),
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: AppConstants.errorColor,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: AppConstants.errorColor),
                    ),
                    onTap: () => _handleLogout(context),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppConstants.spaceLg),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spaceMd,
        AppConstants.spaceLg,
        AppConstants.spaceMd,
        AppConstants.spaceSm,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: AppConstants.fontWeightBold,
          color: AppConstants.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.neutralSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Accent Color',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeH3,
                  fontWeight: AppConstants.fontWeightBold,
                ),
              ),

              const SizedBox(height: AppConstants.spaceLg),

              Wrap(
                spacing: AppConstants.spaceMd,
                runSpacing: AppConstants.spaceMd,
                children: AppConstants.accentColors.entries.map((entry) {
                  final isSelected = settingsProvider.accentColor == entry.key;

                  return InkWell(
                    onTap: () {
                      settingsProvider.setAccentColor(entry.key);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusMedium,
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: entry.value,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMedium,
                        ),
                        border: isSelected
                            ? Border.all(
                                color: AppConstants.textPrimary,
                                width: 3,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: AppConstants.neutralBackground,
                              size: 32,
                            ),
                          const SizedBox(height: AppConstants.spaceXs),
                          Text(
                            entry.key.capitalize(),
                            style: const TextStyle(
                              color: AppConstants.neutralBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppConstants.spaceSm),
            ],
          ),
        ),
      ),
    );
  }
}
