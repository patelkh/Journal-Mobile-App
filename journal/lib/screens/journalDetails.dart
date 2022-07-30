import 'package:flutter/material.dart';
import 'package:journal/models/journalentry.dart';
import 'package:intl/intl.dart';

class JournalDetails extends StatelessWidget {
  final updateSettings;
  final mode; 
  const JournalDetails({super.key, this.updateSettings, this.mode}); 
  
  @override
  Widget build(BuildContext context) {
    final JournalEntry entry = ModalRoute.of(context)!.settings.arguments as JournalEntry; 
    final DateTime entryDate = DateTime.parse(entry.date.toString()); 
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.yMMMEd().format(entryDate)),
        leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null
      ),
      endDrawer: Drawer(
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
              value: mode,
              title: const Text('Dark Mode'),
              onChanged: (value) => {
                updateSettings(value)
              }
            ),         
          ],
        ),
      ),
      body: _details(entry),
    );
  }

  Widget _details(entry) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(entry.title, 
              style: const TextStyle(fontSize: 30.0, 
              fontWeight: FontWeight.bold )),
            const SizedBox(height: 10.0),
            Text('Rating: ${entry.rating.toString()}', 
              style: const TextStyle(fontSize: 15.0)),
            const SizedBox(height: 10.0),
            Text(entry.body, 
              style: const TextStyle(fontSize: 20.0)),
          ],
        ),
      );
  }

}