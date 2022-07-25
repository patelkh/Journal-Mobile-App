import 'dart:io';
import 'package:flutter/material.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/models/journalentry.dart';
import 'package:journal/screens/journalDetails.dart';
import 'package:sqflite/sqflite.dart';
import 'package:journal/screens/welcome.dart';
import 'package:journal/widgets/settings.dart';


class JournalEntryListScreen extends StatefulWidget {
  final updateSettings;
  const JournalEntryListScreen({Key? key, this.updateSettings}) : super(key: key);

  @override
  State<JournalEntryListScreen> createState() => _JournalEntryListScreenState();
}

class _JournalEntryListScreenState extends State<JournalEntryListScreen> {
  late Journal journal = Journal(entries: const []);
  late JournalEntry selectedEntry = JournalEntry.empty();


  @override
  void initState() {
    super.initState();
    loadJournal();
    sleep(const Duration(seconds: 3));
  }

  void loadJournal() async {
    final Database db = await openDatabase(
      'journal.sqlite3.db', 
      version: 1, 
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS journal_entries(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, body TEXT NOT NULL, rating INTEGER NOT NULL, date TEXT NOT NULL)'
        );
      });
    // store db record as maps in a list 
    List<Map> journalRecords = await db.rawQuery('SELECT * from journal_entries');
    print('journal records from db: $journalRecords');
    // create JournalEntry objects using the maps in journalRecords list and store in journalEntries list 
    final journalEntries = journalRecords.map((record) {
      // print('current record: $record\n');
      return JournalEntry(
        id: record['id'],
        title: record['title'],
        body: record['body'],
        rating: record['rating'],
        date: DateTime.parse(record['date']) 
        );
    }).toList();
    // print('journalEntries: $journalEntries');
    setState(() {
      journal = Journal(entries: journalEntries);  
    });
    print('Journal: ${journal.entries}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      endDrawer: Settings(updateSettings: widget.updateSettings),
      body: LayoutBuilder(builder: ((context, constraints) {
        if(constraints.maxWidth >= 500) {
          return horizontalLayout(context, journal);
        } else {
          return verticalLayout(context, journal);
        }
      })),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed('addEntry'),
          tooltip: 'Add an Entry',
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
    );
    }

  Widget verticalLayout(context, journal ) {
    if(journal.entries.isEmpty) {
      return const Welcome();
    } else {
      return ListView.builder(
        itemCount: journal.entries.length,
          itemBuilder: (context, index) {
            final entry = journal.entries[index];
            return  ListTile(
              title: Text(entry.title),
              subtitle: Text(entry.body),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => JournalDetails(entry: journal.entries[index])));
              },
            );
          });
    }
  } 

  Widget horizontalLayout(context, journal) {
    return journal.entries.isEmpty ? const Welcome() : Row(children: [
      Expanded(
        child: Container(
          child: ListView.builder(
            itemCount: journal.entries.length,
            itemBuilder: (context, index) {
              final entry = journal.entries[index];
              return  ListTile(
                title: Text(journal.entries[index].title),
                subtitle: Text(journal.entries[index].body),
                onTap: () {setState(() {
                  selectedEntry = entry; 
                });},
              );
            }
          ),
        ),
      ),
      const VerticalDivider(width: 4.0, color: Colors.lightBlueAccent),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: selectedEntry.title == '' ? Column(): Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedEntry.title, style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10.0,),
              Text('Date: ${selectedEntry.date.toString()}', style: const TextStyle(fontSize: 16.0),),
              const SizedBox(height: 10.0,),
              Text('Rating: ${selectedEntry.rating.toString()}', style: const TextStyle(fontSize: 16.0),),
              const SizedBox(height: 10.0,),
              Text(selectedEntry.body, style: const TextStyle(fontSize: 16.0),),
              const SizedBox(height: 10.0,),

          ],)
        )
      ),
    ]);
  }
}

