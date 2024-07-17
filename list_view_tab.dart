import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListViewTab extends StatefulWidget {
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
  _ListViewTabState createState() => _ListViewTabState();
}

class _ListViewTabState extends State<ListViewTab> {
  void _deleteTrip(int index) {
    widget.deleteTrip(index);
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

  void _showEditOptions(BuildContext context, int index) {
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
                      _editTrip(context, index);
                    },
                  ),
                  TextButton(
                    child:
                        Text('Add to folder', style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddToFolderDialog(context, index);
                    },
                  ),
                  TextButton(
                    child: Text('Delete', style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteTrip(index);
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

  void _showAddToFolderDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add to Folder'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Folder Name'),
                  onSubmitted: (value) {
                    widget.addToFolder(value, widget.allTrips[index]);
                    _deleteTrip(index);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editTrip(BuildContext context, int index) {
    Map<String, dynamic> trip = widget.allTrips[index];
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
                widget.updateTrip(index, {
                  'title': titleController.text,
                  'date': trip['date'],
                  'description': descriptionController.text,
                  'image': trip['image']
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
          child: ListView.builder(
            itemCount: widget.allTrips.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Image.network(widget.allTrips[index]['image'],
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(widget.allTrips[index]['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('yyyy-MM-dd')
                          .format(widget.allTrips[index]['date'])),
                      SizedBox(height: 4.0),
                      Text(
                        widget.allTrips[index]['description'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      _showEditOptions(context, index);
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
