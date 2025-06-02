import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'base_page.dart';
import '../widgets/custom_drawer.dart';
import '../constants/constants.dart';
import '../constants/texts.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BasePage(
      title: AppTexts.settings,
      drawer: const DrawerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(AppTexts.appearance, textTheme),
            _buildSettingCard(
              theme: theme,
              children: [
                _buildColorPicker(context, settings, colorScheme, textTheme),
                const SizedBox(height: AppConstants.largePadding),
                _buildTextSizePicker(context, settings, colorScheme, textTheme),
                const SizedBox(height: AppConstants.largePadding),
                _buildSwitchTile(
                  context,
                  title: AppTexts.darkMode,
                  value: settings.isDarkMode,
                  icon: Icons.dark_mode,
                  onChanged: (value) => settings.toggleDarkMode(value),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.largePadding),
            _buildSectionHeader(AppTexts.notifications, textTheme),
            _buildSettingCard(
              theme: theme,
              children: [
                _buildSwitchTile(
                  context,
                  title: AppTexts.enableNotifications,
                  value: settings.notificationsEnabled,
                  icon: Icons.notifications,
                  onChanged: (value) => settings.toggleNotifications(value),
                ),
                if (settings.notificationsEnabled) ...[
                  const Divider(height: 1),
                  _buildSwitchTile(
                    context,
                    title: AppTexts.sound,
                    value: settings.soundEnabled,
                    icon: Icons.volume_up,
                    onChanged: (value) => settings.toggleSound(value),
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    context,
                    title: AppTexts.vibration,
                    value: settings.vibrationEnabled,
                    icon: Icons.vibration,
                    onChanged: (value) => settings.toggleVibration(value),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppConstants.largePadding),
            _buildSectionHeader(AppTexts.about, textTheme),
            _buildSettingCard(
              theme: theme,
              children: [
                _buildListTile(
                  context,
                  title: AppTexts.version,
                  subtitle: '1.0.0',
                  icon: Icons.info,
                ),
                const Divider(height: 1),
                _buildListTile(
                  context,
                  title: AppTexts.privacyPolicy,
                  icon: Icons.privacy_tip,
                  onTap: () {},
                ),
                const Divider(height: 1),
                _buildListTile(
                  context,
                  title: AppTexts.termsOfService,
                  icon: Icons.description,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.smallPadding,
        bottom: AppConstants.smallPadding,
      ),
      child: Text(
        title,
        style: textTheme.headlineMedium,
      ),
    );
  }

  Widget _buildSettingCard({
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.smallPadding,
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildColorPicker(
    BuildContext context,
    SettingsProvider settings,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTexts.themeColor,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          SizedBox(
            height: AppConstants.mediumAvatarSize,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.availableColors.length,
              itemBuilder: (context, index) {
                final color = AppConstants.availableColors[index];
                return Padding(
                  padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
                  child: GestureDetector(
                    onTap: () => settings.updateThemeColor(color),
                    child: Container(
                      width: AppConstants.smallAvatarSize,
                      height: AppConstants.smallAvatarSize,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: settings.themeColor == color
                              ? colorScheme.primary
                              : Colors.transparent,
                          width: AppConstants.inputBorderWidth,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: AppConstants.cardElevation,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: settings.themeColor == color
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: AppConstants.smallIconSize,
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSizePicker(
    BuildContext context,
    SettingsProvider settings,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTexts.textSize,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          SizedBox(
            height: AppConstants.mediumAvatarSize,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.availableTextSizes.length - 1,
              itemBuilder: (context, index) {
                final size = AppConstants.availableTextSizes[index];
                final isSelected = (settings.textSize - size).abs() < 0.1;
                return Padding(
                  padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
                  child: GestureDetector(
                    onTap: () => settings.updateTextSize(size),
                    child: Container(
                      width: AppConstants.smallAvatarSize,
                      height: AppConstants.smallAvatarSize,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: AppConstants.cardElevation,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Aa',
                          style: TextStyle(
                            color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                            fontSize: size * 0.4,
                            fontWeight: AppConstants.mediumFontWeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return SwitchListTile(
      title: Text(
        title,
        style: theme.textTheme.titleLarge,
      ),
      value: value,
      onChanged: onChanged,
      secondary: Icon(
        icon,
        color: theme.colorScheme.primary,
        size: AppConstants.defaultIconSize,
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        title,
        style: theme.textTheme.titleLarge,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodyMedium,
            )
          : null,
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
        size: AppConstants.defaultIconSize,
      ),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
              size: AppConstants.defaultIconSize,
            )
          : null,
      onTap: onTap,
    );
  }
}