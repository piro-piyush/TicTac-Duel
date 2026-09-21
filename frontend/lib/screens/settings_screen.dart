import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.background,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const _SettingsHeader(),

          const SizedBox(height: 28),

          _sectionTitle('Audio & Feedback'),

          const SizedBox(height: 10),

          _SettingsGroup(
            children: [
              _SwitchTile(
                icon: Icons.music_note_rounded,
                title: 'Background Music',
                subtitle: 'Play music while you play',
                value: _musicEnabled,
                color: Themes.neonPurple,
                onChanged: (value) {
                  setState(() => _musicEnabled = value);
                },
              ),
              const _Divider(),
              _SwitchTile(
                icon: Icons.volume_up_rounded,
                title: 'Sound Effects',
                subtitle: 'Play sounds during the game',
                value: _soundEnabled,
                color: Themes.neonCyan,
                onChanged: (value) {
                  setState(() => _soundEnabled = value);
                },
              ),
              const _Divider(),
              _SwitchTile(
                icon: Icons.vibration_rounded,
                title: 'Vibration',
                subtitle: 'Vibrate when making a move',
                value: _vibrationEnabled,
                color: Themes.neonPink,
                onChanged: (value) {
                  setState(() => _vibrationEnabled = value);
                },
              ),
            ],
          ),

          const SizedBox(height: 28),

          _sectionTitle('About'),

          const SizedBox(height: 10),

          _SettingsGroup(
            children: [
              _ActionTile(
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: 'Tic Tac Duel • Version 1.0.0',
                color: Themes.neonCyan,
                onTap: _showAbout,
              ),
              const _Divider(),
              _ActionTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'How your data is handled',
                color: Themes.textSecondary,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 40),

          const FooterCardWidget(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Themes.textSecondary,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.6,
      ),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Tic Tac Duel',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.grid_3x3_rounded,
        color: Themes.neonCyan,
        size: 32,
      ),
      children: const [
        Text(
          'A simple multiplayer Tic Tac Toe experience.',
          style: TextStyle(color: Themes.textSecondary, height: 1.4),
        ),
      ],
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Themes.neonCyan.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Themes.neonCyan.withValues(alpha: 0.18)),
          ),
          child: const Icon(
            Icons.settings_rounded,
            color: Themes.neonCyan,
            size: 21,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Game Settings',
                style: TextStyle(
                  color: Themes.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Customize your duel experience.',
                style: TextStyle(color: Themes.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Themes.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Themes.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(children: children),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      leading: Icon(icon, color: color, size: 21),
      title: Text(
        title,
        style: const TextStyle(
          color: Themes.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          subtitle,
          style: const TextStyle(color: Themes.textSecondary, fontSize: 10),
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: color.withValues(alpha: 0.35),
        activeThumbColor: color,
        inactiveTrackColor: Themes.card,
        inactiveThumbColor: Themes.disabled,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.04),
        hoverColor: color.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          leading: Icon(icon, color: color, size: 21),
          title: Text(
            title,
            style: const TextStyle(
              color: Themes.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subtitle,
              style: const TextStyle(color: Themes.textSecondary, fontSize: 10),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: Themes.textSecondary.withValues(alpha: 0.7),
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 50,
      endIndent: 14,
      color: Themes.border.withValues(alpha: 0.7),
    );
  }
}

