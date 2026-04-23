import 'package:flutter/material.dart';
import '../../core/constants/theme.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/tts_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storageService = StorageService();
  final TTSService _ttsService = TTSService();

  late Map<String, dynamic> _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _settings = await _storageService.loadSettings();
    setState(() => _isLoading = false);
  }

  Future<void> _saveSettings() async {
    await _storageService.saveSettings(_settings);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: AppColors.bgDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // READING PREFERENCES
            _buildSection('Reading Preferences', [
              _buildSettingItem(
                icon: Icons.text_fields,
                title: 'Text Size',
                description: 'Adjust font size for comfortable reading',
                child: Row(
                  children: [
                    const Text('A'),
                    Expanded(
                      child: Slider(
                        value: _settings['textSize'] ?? 16,
                        min: 12,
                        max: 24,
                        divisions: 12,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.bgTertiary,
                        onChanged: (value) {
                          setState(() => _settings['textSize'] = value);
                          _saveSettings();
                        },
                      ),
                    ),
                    const Text('A',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              _buildSettingItem(
                icon: Icons.line_weight,
                title: 'Line Height',
                description: 'Control space between lines',
                child: Row(
                  children: [
                    const Icon(Icons.unfold_less_double, size: 18),
                    Expanded(
                      child: Slider(
                        value: _settings['lineHeight'] ?? 1.6,
                        min: 1.2,
                        max: 2.0,
                        divisions: 8,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.bgTertiary,
                        onChanged: (value) {
                          setState(() => _settings['lineHeight'] = value);
                          _saveSettings();
                        },
                      ),
                    ),
                    const Icon(Icons.unfold_more_double, size: 18),
                  ],
                ),
              ),
            ]),

            const SizedBox(height: AppSpacing.xl),

            // VOICE SETTINGS
            _buildSection('Voice Settings', [
              _buildSettingItem(
                icon: Icons.speed,
                title: 'Default Speech Rate',
                description: 'Normal speed for narration',
                child: Row(
                  children: [
                    const Text('Slow'),
                    Expanded(
                      child: Slider(
                        value: _settings['speechRate'] ?? 0.5,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        activeColor: AppColors.accent,
                        inactiveColor: AppColors.bgTertiary,
                        onChanged: (value) {
                          setState(() => _settings['speechRate'] = value);
                          _saveSettings();
                        },
                      ),
                    ),
                    const Text('Fast'),
                  ],
                ),
              ),
              _buildSettingItem(
                icon: Icons.music_note,
                title: 'Voice Pitch',
                description: 'Adjust voice pitch for comfort',
                child: Row(
                  children: [
                    const Text('Low'),
                    Expanded(
                      child: Slider(
                        value: _settings['pitch'] ?? 1.0,
                        min: 0.5,
                        max: 2.0,
                        divisions: 10,
                        activeColor: AppColors.secondary,
                        inactiveColor: AppColors.bgTertiary,
                        onChanged: (value) {
                          setState(() => _settings['pitch'] = value);
                          _saveSettings();
                        },
                      ),
                    ),
                    const Text('High'),
                  ],
                ),
              ),
            ]),

            const SizedBox(height: AppSpacing.xl),

            // APP PREFERENCES
            _buildSection('App Preferences', [
              _buildToggleSetting(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                description: 'Always enabled for better reading',
                value: true,
                onChanged: null, // Disabled - always dark
              ),
              _buildToggleSetting(
                icon: Icons.notifications_active,
                title: 'Reading Reminders',
                description: 'Get notified to continue reading',
                value: _settings['reminders'] ?? false,
                onChanged: (value) {
                  setState(() => _settings['reminders'] = value);
                  _saveSettings();
                },
              ),
              _buildToggleSetting(
                icon: Icons.history,
                title: 'Remember Reading History',
                description: 'Track your reading progress',
                value: _settings['trackHistory'] ?? true,
                onChanged: (value) {
                  setState(() => _settings['trackHistory'] = value);
                  _saveSettings();
                },
              ),
            ]),

            const SizedBox(height: AppSpacing.xl),

            // ABOUT
            _buildSection('About', [
              _buildInfoItem(
                icon: Icons.info_outline,
                title: 'Version',
                value: '1.0.0',
              ),
              _buildInfoItem(
                icon: Icons.storage,
                title: 'Storage Used',
                value: 'Calculate from device',
              ),
            ]),

            const SizedBox(height: AppSpacing.xl),

            // DANGER ZONE
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Danger Zone',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Clear All Data?'),
                            content: const Text(
                              'This will delete all your books and reading progress. This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Clear data logic
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: AppColors.secondary),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Clear All Data'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        side: const BorderSide(color: AppColors.secondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: AppColors.bgTertiary),
          ),
          child: Column(
            children: List.generate(
              children.length,
              (index) => Column(
                children: [
                  children[index],
                  if (index < children.length - 1)
                    Divider(
                      height: 1,
                      color: AppColors.bgTertiary,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String description,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }

  Widget _buildToggleSetting({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required Function(bool)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 24),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            inactiveThumbColor: AppColors.bgTertiary,
            inactiveTrackColor: AppColors.bgTertiary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
