import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../pages/edit_trip_page.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final Function(String) onDelete;
  final Function(Trip) onEdit;
  final Function(Trip)? onAddToFolder;
  final Function(Trip)? onRemoveFromFolder;
  final bool isInFolder;

  const TripCard({
    Key? key,
    required this.trip,
    required this.onDelete,
    required this.onEdit,
    this.onAddToFolder,
    this.onRemoveFromFolder,
    this.isInFolder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: trip.imageUrl != null
              ? NetworkImage(trip.imageUrl!)
              : AssetImage('assets/images/placeholder.png') as ImageProvider,
        ),
        title: Text(trip.title),
        subtitle: Text(
          trip.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trip.rating != null) _buildStarRating(trip.rating!),
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    final updatedTrip = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTripPage(trip: trip),
                      ),
                    );
                    if (updatedTrip != null) {
                      onEdit(updatedTrip);
                    }
                    break;
                  case 'delete':
                    onDelete(trip.id);
                    break;
                  case 'addToFolder':
                    onAddToFolder?.call(trip);
                    break;
                  case 'removeFromFolder':
                    onRemoveFromFolder?.call(trip);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
                if (!isInFolder && onAddToFolder != null)
                  PopupMenuItem(
                    value: 'addToFolder',
                    child: Text('Add to Folder'),
                  ),
                if (isInFolder && onRemoveFromFolder != null)
                  PopupMenuItem(
                    value: 'removeFromFolder',
                    child: Text('Remove from Folder'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }
}
