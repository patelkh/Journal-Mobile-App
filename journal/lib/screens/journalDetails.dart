import 'package:flutter/material.dart';
import 'package:journal/models/journalentry.dart';
import 'package:intl/intl.dart';

class JournalDetails extends StatelessWidget {
  // final updateSettings;
  final JournalEntry entry;
  const JournalDetails({super.key, required this.entry}); 
  
  @override
  Widget build(BuildContext context) {
    final DateTime entryDate = DateTime.parse(entry.date.toString()); 
    return Scaffold(
      // endDrawer: Settings(updateSettings: updateSettings ),
      appBar: AppBar(
        title: Text(DateFormat.yMMMEd().format(entryDate)),
      ),
      body: _details(),
    );
  }

  Widget _details() {
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