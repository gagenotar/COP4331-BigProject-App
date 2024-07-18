import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../models/folder.dart';
import '../services/api_service.dart';
import '../widgets/trip_list_item.dart';
import '../widgets/folder_grid_item.dart';

class MyTripsPage extends StatefulWidget {
  final String userId;
  const MyTripsPage({super.key, required this.userId});

  @override
  MyTripsPageState createState() => MyTripsPageState();
}

class MyTripsPageState extends State<MyTripsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Trip> _trips = [];
  List<Folder> _folders = [];
  bool _isLoading = false;
  String _error = '';


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchTrips();
    _fetchFolders();
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
      final result = await ApiService.searchMyEntries('', widget.userId);
      final List<dynamic> tripsJson = result['results'] ?? [];
      setState(() {
        _trips = tripsJson.map((json) => Trip.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchFolders() async {
    // TODO: Implement folder fetching from API
    setState(() {
      _folders = [
        Folder(id: '1', name: 'Summer 2024'),
        Folder(id: '2', name: 'NYC'),
        Folder(id: '3', name: 'Restaurants'),
      ];
    });
  }

  Future<void> _deleteTrip(String tripId) async {
    try {
      await ApiService.deleteEntry(tripId);
      setState(() {
        _trips.removeWhere((trip) => trip.id == tripId);
      });
    } catch (e) {
      setState(() {
        _error = 'Error deleting trip: $e';
      });
    }
  }

  Future<void> _editTrip(Trip trip) async {
    // TODO: Implement edit functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'List View'),
            Tab(text: 'Folder View'),
            Tab(text: 'Map View'),
          ],
        ),
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildListView(),
                    _buildFolderView(),
                    _buildMapView(),
                  ],
                ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Journey Journal',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('My Trips'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Create'),
            onTap: () {
              // TODO: Navigate to create trip page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () {
              // TODO: Implement logout functionality
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _trips.length,
      itemBuilder: (context, index) {
        return TripListItem(
          trip: _trips[index],
          onDelete: _deleteTrip,
          onEdit: _editTrip,
        );
      },
    );
  }

  Widget _buildFolderView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _folders.length,
      itemBuilder: (context, index) {
        return FolderGridItem(
          folder: _folders[index],
          onTap: () {
            // TODO: Navigate to folder contents
          },
        );
      },
    );
  }

  Widget _buildMapView() {
    // TODO: Implement map view
    return const Center(child: Text('Map View - To be implemented'));
  }
}
