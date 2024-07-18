class Trip {
  final String id;
  final String title;
  final String description;
  final String location;
  final int? rating;

  Trip({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    this.rating,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      rating: json['rating'],
    );
  }
}
