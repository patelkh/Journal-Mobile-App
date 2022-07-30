import 'package:flutter/material.dart';
import 'package:journal/db/databasemanager.dart';
import 'package:journal/db/journalentryDTO.dart';

class JournalEntryForm extends StatefulWidget {
  const JournalEntryForm({Key? key, this.updateSettings, this.mode}) : super(key: key);

  final updateSettings;
  final mode; 

  @override
  State<JournalEntryForm> createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  final formKey = GlobalKey<FormState>(); 
  final journalEntryFields = JournalEntryDTO(); 
  final int entryRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Journal Entry'),
        leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null),
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
              value: widget.mode,
              title: const Text('Dark Mode'),
              onChanged: (value) => {
                widget.updateSettings(value)
              }
            ),         
          ],
        ),
      ),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                autocorrect: false,
                validator: (value) {
                  if(value!.isEmpty) {
                    return 'Please enter a title';
                  } else {
                    return null; 
                  }
                },
                onSaved: (value) {
                  journalEntryFields.title = value ?? ''; 
                },
              ),
              const SizedBox(height: 10.0,), 
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                autocorrect: false,
                validator: (value) {
                  if(value!.isEmpty) {
                    return 'Please enter details';
                  } else {
                    return null; 
                  }
                },
                onSaved: (value) {
                  journalEntryFields.body = value ?? '';
                },
              ), 
              const SizedBox(height: 10.0,),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Rating',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1')), 
                  DropdownMenuItem(value: 2, child: Text('2')),
                  DropdownMenuItem(value: 3, child: Text('3')),
                  DropdownMenuItem(value: 4, child: Text('4')),
                ], 
                onChanged: (value) {journalEntryFields.rating = value as int;},
                validator: (value) {
                  if(value == null) {
                    return 'Please select a rating from drop down';
                  } else {
                    return null; 
                  }
                },
              ),
              const SizedBox(height: 10.0,),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () async {   
                  if(formKey.currentState!.validate()) {            
                    formKey.currentState?.save();
                    final databaseManager = DatabaseManager.getInstance();
                    await databaseManager.db.transaction((txn) async {
                      await txn.rawInsert('INSERT INTO journal_entries(title, body, rating, date) VALUES(?, ?, ?, ?)', [journalEntryFields.title, journalEntryFields.body, journalEntryFields.rating, DateTime.now().toString()]); 
                    });
                    Navigator.of(context).pushNamed('/');
                  }
                },
              ),
            ],
          ),
        ),
      )
      ),
    );
  }
}
