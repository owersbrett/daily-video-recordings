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
            leading: Icon(Icons.person),
            title: Text('Account'),
            subtitle: Text('Personal information'),
            onTap: () {
              // Navigate to account settings
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Notification settings'),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy'),
            subtitle: Text('Privacy settings'),
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Appearance'),
            subtitle: Text('Theme, font size'),
            onTap: () {
              // Navigate to appearance settings
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('App language'),
            onTap: () {
              // Navigate to language settings
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud),
            title: Text('Backup'),
            subtitle: Text('Manage data backup'),
            onTap: () {
              // Navigate to backup settings
            },
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text('Update'),
            subtitle: Text('Check for updates'),
            onTap: () {
              // Check for updates
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Feedback'),
            subtitle: Text('Get help and send feedback'),
            onTap: () {
              // Navigate to help and feedback
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            subtitle: Text('App version and legal information'),
            onTap: () {
              // Navigate to about page
            },
          ),
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            subtitle: Text('Toggle dark mode'),
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
            leading: Icon(Icons.dark_mode),
            title: Text('Sound Effects'),
            subtitle: Text('Toggle sound effects'),
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
