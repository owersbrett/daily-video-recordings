import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _soundEffects = false;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account'),
            subtitle: const Text('Personal information'),
            onTap: () {
              // Navigate to account settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Notification settings'),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy'),
            subtitle: const Text('Privacy settings'),
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Appearance'),
            subtitle: const Text('Theme, font size'),
            onTap: () {
              // Navigate to appearance settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('App language'),
            onTap: () {
              // Navigate to language settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: const Text('Backup'),
            subtitle: const Text('Manage data backup'),
            onTap: () {
              // Navigate to backup settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Update'),
            subtitle: const Text('Check for updates'),
            onTap: () {
              // Check for updates
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Feedback'),
            subtitle: const Text('Get help and send feedback'),
            onTap: () {
              // Navigate to help and feedback
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('App version and legal information'),
            onTap: () {
              // Navigate to about page
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark mode'),
            trailing: CupertinoSwitch(
              value: _darkMode,
              onChanged: (val) {
                setState(() {
                  _darkMode = val;
                });
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Sound Effects'),
            subtitle: const Text('Toggle sound effects'),
            trailing: CupertinoSwitch(
              value: _soundEffects,
              onChanged: (val) {
                setState(() {
                  _soundEffects = val;
                });
              },
            ),
          ),
        ],
      ).toList(),
    );
  }
}
