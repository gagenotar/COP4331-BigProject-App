class Trip {
  final String id;
  final String userId;
  final String title;
  final String description;
  final dynamic location; // Changed to dynamic type
  final String? imageUrl;
  final int? rating;

  Trip({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    this.imageUrl,
    this.rating,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location'], // Assign directly from JSON
      imageUrl: json['imageUrl']?.toString(),
      rating: json['rating'] is int ? json['rating'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }
}

