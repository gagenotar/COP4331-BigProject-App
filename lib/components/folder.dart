class Folder {
  String name;
  List<String> tripIds;

  Folder({required this.name, List<String>? tripIds}) : tripIds = tripIds ?? [];

  void addTrip(String tripId) {
    if (!tripIds.contains(tripId)) {
      tripIds.add(tripId);
    }
  }

  void removeTrip(String tripId) {
    tripIds.remove(tripId);
  }

  @override
  String toString() {
    return 'Folder(name: $name, tripIds: $tripIds)';
  }
}
