import 'package:flutter/material.dart';
import 'api_service.dart';
import 'list_view_tab.dart';
import 'folder_view_tab.dart';
import 'map_view_tab.dart';

class MyTripsPage extends StatefulWidget {
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
      final trips = await apiService.getTrips();
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

  void updateTrip(String id, Map<String, dynamic> trip) async {
    try {
      await apiService.updateTrip(id, trip);
      fetchTrips();
    } catch (e) {
      // Handle error
      print("Error updating trip: $e");
    }
  }

  void deleteTrip(String id) async {
    try {
      await apiService.deleteTrip(id);
      fetchTrips();
    } catch (e) {
      // Handle error
      print("Error deleting trip: $e");
    }
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
                addTrip: addTrip,
                updateTrip: updateTrip,
                deleteTrip: deleteTrip),
            FolderViewTab(
                allTrips: allTrips,
                updateTrip: updateTrip,
                deleteTrip: deleteTrip),
            MapViewTab(),
          ],
        ),
      ),
    );
  }
}
