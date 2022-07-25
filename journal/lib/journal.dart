import 'dart:io';
import 'package:flutter/material.dart';
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
  
  @override
  void initState() {
    super.initState();
    initUserSettings(); 
  }

  void initUserSettings() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    sleep(Duration(seconds: 2));
    setState(() {
      isDarkMode = preferences.getBool('isDarkMode') ?? false; 
      print('User setting from Shared Preference is $isDarkMode');
    });
  }

  void updateSettings(bool setting) {
    setState(() {
      isDarkMode = setting; 
    });
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
      '/': (context) => JournalEntryListScreen(updateSettings: updateSettings),
      'addEntry': (context) => JournalEntryForm()
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journal',
      theme: currentTheme(isDarkMode),
      routes: routes,
    );
  }
}