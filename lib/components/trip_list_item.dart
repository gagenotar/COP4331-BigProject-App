import 'package:flutter/material.dart';
import '../models/trip.dart';

class TripListItem extends StatelessWidget {
  final Trip trip;
  final Function(String) onDelete;
  final Function(Trip) onEdit;

  TripListItem({
    // Remove const from here
    super.key,
    required this.trip,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(trip.title),
        subtitle: Text(trip.location),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trip.rating != null) _buildStarRating(trip.rating!),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit(trip);
                } else if (value == 'delete') {
                  onDelete(trip.id);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
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
