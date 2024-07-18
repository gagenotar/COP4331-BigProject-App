import 'package:flutter/material.dart';
import 'api_service.dart';
import 'list_view_tab.dart';
import 'folder_view_tab.dart';
import 'map_view_tab.dart';

class MyTripsPage extends StatefulWidget {
  final String userId;

  MyTripsPage({required this.userId});

  @override
  _MyTripsPageState createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> allTrips = [];

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  void fetchTrips() async {
    try {
      final trips = await apiService.getTrips(widget.userId);
      setState(() {
        allTrips = trips;
      });
    } catch (e) {
      // Handle error
      print("Error fetching trips: $e");
    }
  }

  void addTrip(Map<String, dynamic> trip) async {
    try {
      await apiService.addTrip(trip);
      fetchTrips();
    } catch (e) {
      // Handle error
      print("Error adding trip: $e");
    }
  }

  void updateTrip(int index, Map<String, dynamic> trip) async {
    try {
      await apiService.updateTrip(allTrips[index]['_id'], trip);
      fetchTrips();
    } catch (e) {
      // Handle error
      print("Error updating trip: $e");
    }
  }

  void deleteTrip(int index) async {
    try {
      await apiService.deleteTrip(allTrips[index]['_id']);
      fetchTrips();
    } catch (e) {
      // Handle error
      print("Error deleting trip: $e");
    }
  }

  void addToFolder(String folderName, Map<String, dynamic> trip) {
    // Your logic to add to folder
  }

  void updateAllTrips(List<Map<String, dynamic>> updatedTrips) {
    setState(() {
      allTrips = updatedTrips;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Trips'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'List View'),
              Tab(text: 'Folder View'),
              Tab(text: 'Map View'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListViewTab(
              allTrips: allTrips,
              addToFolder: addToFolder,
              addTrip: addTrip,
              updateTrip: updateTrip,
              deleteTrip: deleteTrip,
            ),
            FolderViewTab(
              allTrips: allTrips,
              updateAllTrips: updateAllTrips,
              updateTrip: updateTrip,
              deleteTrip: deleteTrip,
            ),
            MapViewTab(),
          ],
        ),
      ),
    );
  }
}
