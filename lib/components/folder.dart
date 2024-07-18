class Folder {
  final String id;
  final String name;

  Folder({required this.id, required this.name});

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
