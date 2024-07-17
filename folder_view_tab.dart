import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FolderViewTab extends StatefulWidget {
  final List<Map<String, dynamic>> allTrips;
  final Function(List<Map<String, dynamic>>) updateAllTrips;

  FolderViewTab({required this.allTrips, required this.updateAllTrips});

  @override
  _FolderViewTabState createState() => _FolderViewTabState();
}

class _FolderViewTabState extends State<FolderViewTab> {
  final Map<String, List<Map<String, dynamic>>> folders = {
    'Summer 2024': [
      {
        'title': 'Beach Trip',
        'date': DateTime(2024, 7, 10),
        'description': 'A day at the beach',
        'image': 'https://via.placeholder.com/150'
      },
      {
        'title': 'Mountain Hike',
        'date': DateTime(2024, 7, 15),
        'description': 'Hiking the mountains',
        'image': 'https://via.placeholder.com/150'
      }
    ],
    'NYC': [
      {
        'title': 'Empire State Building',
        'date': DateTime(2024, 6, 12),
        'description': 'Visit to the Empire State Building',
        'image': 'https://via.placeholder.com/150'
      },
      {
        'title': 'Central Park',
        'date': DateTime(2024, 6, 13),
        'description': 'A walk in Central Park',
        'image': 'https://via.placeholder.com/150'
      }
    ],
    // Add more folders and trips as needed
  };

  String? currentFolder;

  void _deleteTrip(String folder, int index) {
    setState(() {
      folders[folder]?.removeAt(index);
    });
  }

  void _removeFromFolder(String folder, int index) {
    setState(() {
      Map<String, dynamic> removedTrip = folders[folder]!.removeAt(index);
      widget.updateAllTrips([...widget.allTrips, removedTrip]);

      if (folders[folder]?.isEmpty ?? true) {
        folders.remove(folder);
        currentFolder = null;
      }
    });
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController dateController, Map<String, dynamic> trip) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: trip['date'],
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (picked != null && picked != trip['date']) {
      setState(() {
        trip['date'] = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showEditOptions(BuildContext context, int index,
      {required String folder}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Rounded corners for the dialog
          ),
          child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                    child: Text('Edit', style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      Navigator.pop(context);
                      _editTrip(context, folder, index);
                    },
                  ),
                  TextButton(
                    child: Text('Remove from folder',
                        style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      Navigator.pop(context);
                      _removeFromFolder(folder, index);
                    },
                  ),
                  TextButton(
                    child: Text('Delete', style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteTrip(folder, index);
                    },
                  ),
                  TextButton(
                    child: Text('Cancel',
                        style: TextStyle(fontSize: 18, color: Colors.red)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _editTrip(BuildContext context, String folder, int index) {
    Map<String, dynamic> trip = folders[folder]![index];
    TextEditingController titleController =
        TextEditingController(text: trip['title']);
    TextEditingController dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(trip['date']));
    TextEditingController descriptionController =
        TextEditingController(text: trip['description']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Trip'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context, dateController, trip),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  trip['title'] = titleController.text;
                  trip['description'] = descriptionController.text;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return currentFolder == null
        ? buildFolderListView()
        : buildTripsInFolderView();
  }

  Widget buildFolderListView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            itemCount: folders.keys.length,
            itemBuilder: (context, index) {
              String folderName = folders.keys.elementAt(index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentFolder = folderName;
                  });
                },
                child: Column(
                  children: [
                    Icon(Icons.folder, size: 100.0),
                    Text(folderName, style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildTripsInFolderView() {
    List<Map<String, dynamic>> trips = folders[currentFolder]!;
    trips.sort((a, b) =>
        a['title'].compareTo(b['title'])); // Sort trips alphabetically

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    currentFolder = null;
                  });
                },
              ),
              Text(currentFolder!,
                  style:
                      TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Image.network(trips[index]['image'],
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(trips[index]['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('yyyy-MM-dd')
                          .format(trips[index]['date'])),
                      SizedBox(height: 4.0),
                      Text(
                        trips[index]['description'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      _showEditOptions(context, index, folder: currentFolder!);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
