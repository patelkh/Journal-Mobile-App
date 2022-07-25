class JournalEntry {
  final int id;
  final String title; 
  final String body;
  final int rating; 
  final DateTime date;

  JournalEntry({required this.id, required this.title, required this.body, required this.rating, required this.date}); 
  
  JournalEntry.empty() : id = 0, title = '', body = '', rating = 0, date =DateTime.now();

  Map<String, dynamic> get entry {
    return {
      "id" : id, 
      "title": title,
      "body": body,
      "rating": rating,
      "date": date
    };
  }

}