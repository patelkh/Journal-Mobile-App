import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'db/databasemanager.dart';
import 'journal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);
  await DatabaseManager.initialize(); 
  runApp(const Journal());
}
