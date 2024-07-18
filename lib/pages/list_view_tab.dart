import 'package:flutter/material.dart';

class ListViewTab extends StatelessWidget {
  final List<Map<String, dynamic>> allTrips;
  final Function(String, Map<String, dynamic>) addToFolder;
  final Function(Map<String, dynamic>) addTrip;
  final Function(int, Map<String, dynamic>) updateTrip;
  final Function(int) deleteTrip;

  ListViewTab({
    required this.allTrips,
    required this.addToFolder,
    required this.addTrip,
    required this.updateTrip,
    required this.deleteTrip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: allTrips.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(allTrips[index]['title']),
            subtitle: Text(allTrips[index]['description']),
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
                        final titleController = TextEditingController(
                            text: allTrips[index]['title']);
                        final descriptionController = TextEditingController(
                            text: allTrips[index]['description']);
                        final locationController = TextEditingController(
                            text: allTrips[index]['location']);
                        return AlertDialog(
                          title: Text('Edit Trip'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: titleController,
                                decoration: InputDecoration(labelText: 'Title'),
                              ),
                              TextField(
                                controller: descriptionController,
                                decoration:
                                    InputDecoration(labelText: 'Description'),
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add trip
          showDialog(
            context: context,
            builder: (context) {
              final titleController = TextEditingController();
              final descriptionController = TextEditingController();
              final locationController = TextEditingController();
              return AlertDialog(
                title: Text('Add Trip'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(labelText: 'Location'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      addTrip({
                        'userId': 'your-user-id', // Replace with actual user ID
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'location': locationController.text,
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
