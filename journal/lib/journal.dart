import 'package:flutter/material.dart';
import 'package:journal/screens/journalDetails.dart';
import 'package:journal/screens/journalEntryList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/journalEntryForm.dart';

class Journal extends StatefulWidget {
  const Journal({Key? key}) : super(key: key);

  @override
  State<Journal> createState() => JournalState();
}

class JournalState extends State<Journal> {
  bool isDarkMode = false; 
  bool get mode => isDarkMode; 
  
  @override
  void initState() {
    super.initState();
    initUserSettings(); 
  }

  void initUserSettings() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = preferences.getBool('isDarkMode') ?? false; 
      print('User setting from Shared Preference is $isDarkMode');
    });
  }

  void updateSettings(bool setting) async {
    setState(() {
      isDarkMode = setting; 
    });
    SharedPreferences preference = await SharedPreferences.getInstance(); 
    preference.setBool("isDarkMode", setting);
  }

  ThemeData currentTheme(bool setting) {
    if(setting==true) {
      return ThemeData(
        brightness: Brightness.dark
      );
    } else {
      return ThemeData(
        brightness: Brightness.light
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/': (context) => JournalEntryListScreen(updateSettings: updateSettings, mode: mode),
      'addEntry': (context) => JournalEntryForm(updateSettings: updateSettings, mode: mode),
      'viewEntry': (context) => JournalDetails(updateSettings: updateSettings, mode: mode)
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journal',
      theme: currentTheme(isDarkMode),
      routes: routes,
    );
  }
}