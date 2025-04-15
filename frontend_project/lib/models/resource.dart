class Resource {
  final int id;
  final String type;
  final String name;

  Resource({
    required this.id,
    required this.type,
    required this.name,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'],
      type: json['type'],
      name: json['name'],
    );
  }
}
