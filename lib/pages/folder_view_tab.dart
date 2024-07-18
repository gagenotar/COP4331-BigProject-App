import 'package:flutter/material.dart';

class FolderViewTab extends StatelessWidget {
  final List<Map<String, dynamic>> allTrips;
  final Function(List<Map<String, dynamic>>) updateAllTrips;
  final Function(int, Map<String, dynamic>) updateTrip;
  final Function(int) deleteTrip;

  FolderViewTab({
    required this.allTrips,
    required this.updateAllTrips,
    required this.updateTrip,
    required this.deleteTrip,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> folders = {};

    for (var trip in allTrips) {
      String folderName = trip['folder'] ?? 'Uncategorized';
      if (!folders.containsKey(folderName)) {
        folders[folderName] = [];
      }
      folders[folderName]!.add(trip);
    }

    return Scaffold(
      body: ListView(
        children: folders.keys.map((folderName) {
          return ExpansionTile(
            title: Text(folderName),
            children: folders[folderName]!.map((trip) {
              int index = allTrips.indexOf(trip);
              return ListTile(
                title: Text(trip['title']),
                subtitle: Text(trip['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Handle edit trip
                        showDialog(
                          context: context,
                          builder: (context) {
                            final titleController =
                                TextEditingController(text: trip['title']);
                            final descriptionController = TextEditingController(
                                text: trip['description']);
                            final locationController =
                                TextEditingController(text: trip['location']);
                            return AlertDialog(
                              title: Text('Edit Trip'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: titleController,
                                    decoration:
                                        InputDecoration(labelText: 'Title'),
                                  ),
                                  TextField(
                                    controller: descriptionController,
                                    decoration: InputDecoration(
                                        labelText: 'Description'),
                                  ),
                                  TextField(
                                    controller: locationController,
                                    decoration:
                                        InputDecoration(labelText: 'Location'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    updateTrip(index, {
                                      'title': titleController.text,
                                      'description': descriptionController.text,
                                      'location': locationController.text,
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Save'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteTrip(index),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
