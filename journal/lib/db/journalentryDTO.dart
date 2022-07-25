class JournalEntryDTO {
  String title = '';
  String body = '';
  int rating = 0;
  DateTime date = DateTime.now(); 
  @override
  String toString() {
    return 'Title: $title, Body: $body, Rating: $rating, Date: $date';
  }
}
