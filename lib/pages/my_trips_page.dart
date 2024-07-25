import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../components/trip.dart';
import '../components/folder.dart';
import 'package:journey_journal_app/components/api_service.dart';
import '../components/trip_card.dart';
import '../components/folder_view.dart';
import '../pages/add_entry_page_2.dart';
import '../pages/edit_trip_page.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({Key? key,
    required this.userId,}) :
        super(key: key);

  final String userId;

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage>
    with SingleTickerProviderStateMixin {
  List<Trip> _trips = [];
  List<Folder> _folders = [];
  bool _isLoading = false;
  String _error = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchTrips();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTrips() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final trips = await ApiService.searchMyEntries('', widget.userId);

      setState(() {
        _trips = List<Trip>.from(trips); // Make a copy of the list to avoid mutating original list
        _trips.sort((a, b) => a.title.compareTo(b.title));
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error fetching trips: $e');
        print('Stack trace: $stackTrace');
      }
      setState(() {
        _error = 'Error fetching trips: $e';
        _isLoading = false;
      });
    }
  }


  void _createFolder(String folderName) {
    setState(() {
      _folders.add(Folder(name: folderName));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Folder "$folderName" created')),
    );
  }

  void _addTripToFolder(Trip trip, Folder folder) {
    setState(() {
      folder.addTrip(trip.id);
    });
  }

  void _removeTripFromFolder(Trip trip, Folder folder) {
    setState(() {
      folder.removeTrip(trip.id);
    });
  }

  Future<void> _deleteTrip(String tripId) async {
    try {
      await ApiService.deleteEntryByID(tripId);
      setState(() {
        _trips.removeWhere((trip) => trip.id == tripId);
        for (var folder in _folders) {
          folder.removeTrip(tripId);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trip deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete trip: $e')),
      );
    }
  }

  Future<void> _editTrip(Trip trip) async {
    print('Editing trip: ${trip.title}'); // Debug print
    final editedTrip = await Navigator.push<Trip>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTripPage(trip: trip),
      ),
    );
    if (editedTrip != null) {
      print('Received edited trip: ${editedTrip.title}'); // Debug print
      setState(() {
        final index = _trips.indexWhere((t) => t.id == editedTrip.id);
        if (index != -1) {
          _trips[index] = editedTrip;
          _trips.sort((a, b) => a.title.compareTo(b.title));
        }
      });
      print('State updated, trips count: ${_trips.length}'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trip "${editedTrip.title}" updated')),
      );
    } else {
      print('No edited trip received'); // Debug print
    }
  }

  Future<void> _navigateToAddEntryPage(BuildContext context) async {
    final newTrip = await Navigator.push<Trip>(
      context,
      MaterialPageRoute(
          builder: (context) => AddEntryPage(userId: widget.userId),
    ));
    if (newTrip != null) {
      setState(() {
        _trips.add(newTrip);
        _trips.sort((a, b) => a.title.compareTo(b.title));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New trip "${newTrip.title}" added')),
      );
    }
  }

  void _showCreateFolderDialog(BuildContext context) {
    final TextEditingController _folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Folder'),
        content: TextField(
          controller: _folderNameController,
          decoration: InputDecoration(hintText: "Enter folder name"),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Create'),
            onPressed: () {
              if (_folderNameController.text.isNotEmpty) {
                _createFolder(_folderNameController.text);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAddToFolderDialog(BuildContext context, Trip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add to Folder'),
        content: SingleChildScrollView(
          child: ListBody(
            children: _folders.map((folder) {
              return ListTile(
                title: Text(folder.name),
                onTap: () {
                  _addTripToFolder(trip, folder);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Trip trip) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Trip'),
          content: Text('Are you sure you want to delete "${trip.title}"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTrip(trip.id);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      key: ValueKey(_trips.length), // Force rebuild when list changes
      itemCount: _trips.length,
      itemBuilder: (context, index) {
        return TripCard(
          key: ValueKey(_trips[index].id), // Unique key for each card
          trip: _trips[index],
          onDelete: (tripId) =>
              _showDeleteConfirmationDialog(context, _trips[index]),
          onEdit: _editTrip,
          onAddToFolder: (trip) => _showAddToFolderDialog(context, trip),
          isInFolder: false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'List View'),
            Tab(text: 'Folder View'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error))
          : RefreshIndicator(
        onRefresh: _fetchTrips,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildListView(),
            FolderView(
              folders: _folders,
              trips: _trips,
              onCreateFolder: _createFolder,
              onAddTripToFolder: _addTripToFolder,
              onRemoveTripFromFolder: _removeTripFromFolder,
              onDeleteTrip: (tripId) {
                final trip = _trips.firstWhere((t) => t.id == tripId);
                _showDeleteConfirmationDialog(context, trip);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _navigateToAddEntryPage(context),
            child: Icon(Icons.add),
            heroTag: 'addTrip',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _showCreateFolderDialog(context),
            child: Icon(Icons.create_new_folder),
            heroTag: 'addFolder',
          ),
        ],
      ),
    );
  }
}

