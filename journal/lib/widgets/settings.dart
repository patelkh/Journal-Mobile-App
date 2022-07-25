import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journal/journal.dart';

class Settings extends StatefulWidget {
    const Settings({Key? key, required this.updateSettings}) : super(key: key);
  // const Settings({Key? key, required this.updateSettings}) : super(key: key);
  final updateSettings;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkMode = false; 

  @override
  void initState() {
    super.initState();
    initUserSettings();
  }

  void initUserSettings() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    sleep(Duration(seconds: 3));
    setState(() {
      isDarkMode = preferences.getBool('isDarkMode') ?? false; 
      print('User setting from Shared Preference is $isDarkMode');
    });
  }

  void updateUserSettings(bool value) async {
    setState(() {
      isDarkMode =  value;
      print('Updating user state to $isDarkMode');
    });
    SharedPreferences preference = await SharedPreferences.getInstance(); 
    preference.setBool("isDarkMode", value);
    widget.updateSettings(isDarkMode);
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 80.0,
              child: DrawerHeader(
                child: Text('Settings'),
              ),
            ),
            SwitchListTile(
              value: isDarkMode,
              title: const Text('Dark Mode'),
              onChanged: (value) => {
                updateUserSettings(value)
              }
            ),         
          ],
        ),
        );
  }
}