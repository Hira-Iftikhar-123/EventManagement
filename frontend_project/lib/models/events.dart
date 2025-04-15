class Event {
  final int id;
  final String name;
  final String date;
  final String category;
  final double budget;
  final String description;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.category,
    required this.budget,
    required this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      category: json['category'],
      budget: json['budget'],
      description: json['description'],
    );
  }
}
