import 'package:flutter/material.dart';
import '../models/folder.dart';
import '../models/trip.dart';
import '../widgets/trip_card.dart';

class FolderView extends StatelessWidget {
  final List<Folder> folders;
  final List<Trip> trips;
  final Function(String) onCreateFolder;
  final Function(Trip, Folder) onAddTripToFolder;
  final Function(Trip, Folder) onRemoveTripFromFolder;
  final Function(String) onDeleteTrip;

  const FolderView({
    Key? key,
    required this.folders,
    required this.trips,
    required this.onCreateFolder,
    required this.onAddTripToFolder,
    required this.onRemoveTripFromFolder,
    required this.onDeleteTrip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        final folderTrips =
            trips.where((trip) => folder.tripIds.contains(trip.id)).toList();

        return ExpansionTile(
          title: Text('${folder.name} (${folderTrips.length} trips)'),
          children: [
            ...folderTrips.map((trip) => TripCard(
                  trip: trip,
                  onDelete: onDeleteTrip,
                  onEdit: (_) {}, // Implement if needed
                  onRemoveFromFolder: (trip) =>
                      onRemoveTripFromFolder(trip, folder),
                  isInFolder: true,
                )),
            if (folderTrips.isEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('No trips in this folder'),
              ),
          ],
        );
      },
    );
  }
}
