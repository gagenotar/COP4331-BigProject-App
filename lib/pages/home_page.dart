import 'package:flutter/material.dart';
import 'package:journey_journal_app/components/api_service.dart';
import 'package:journey_journal_app/pages/settings_page.dart';
//import 'package:journey_journal_app/pages/add_entry_page.dart'; //original version
//import 'package:journey_journal_app/pages/add_entry_page_1.dart'; //jason new ver
import 'package:journey_journal_app/pages/add_entry_page_2.dart'; // tyler ver
import 'package:journey_journal_app/components/post.dart';
import 'package:journey_journal_app/pages/my_trips_page.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.credentials,
    required this.email,
  }) : super(key: key);

  final Map<String, dynamic> credentials;
  final String email;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;
  late String _email; // Declare a mutable variable for email

  @override
  void initState() {
    super.initState();
    _email = widget.email; // Initialize _email with initial value of email
  }

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Function to update email
  void updateEmail(String newEmail) {
    setState(() {
      _email = newEmail; // Update _email using setState
    });
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.credentials['firstName'];
    if (name == "") {
      name = widget.credentials['login'];
    }
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 40,
            width: 40,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        title: Text('Hello $name'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(color: Colors.blue),
        selectedItemColor: Colors.black87,
        onTap: onTabTapped,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, color: Color.fromRGBO(38, 38, 38, 0.4)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop, color: Color.fromRGBO(38, 38, 38, 0.4)),
            label: 'My Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box, color: Color.fromRGBO(38, 38, 38, 0.4)),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Color.fromRGBO(38, 38, 38, 0.4)),
            label: 'Profile',
          ),
        ],
      ),
      body: buildBody(selectedIndex),
    );
  }

  Widget buildBody(int index) {
    switch (index) {
      case 0:
        return buildHomeScreen();
      case 1:
        return buildListScreen();
      case 2:
        return buildAddReviewScreen();
      case 3:
        return buildProfileScreen();
      default:
        return buildHomeScreen(); // Default to HomeScreen
    }
  }

  Widget buildHomeScreen() {
   return ListView(       
     padding: const EdgeInsets.symmetric(horizontal: 8),       
     children: <Widget>[],    
   );
  }


  Widget buildListScreen() {
    return MyTripsPage(userId:'${widget.credentials['_id']}' );

  }

  Widget buildAddReviewScreen() {
    return AddEntryPage(userId:'${widget.credentials['_id']}' );
  }

  Widget buildProfileScreen() {
    return SettingsPage(
      credentials: widget.credentials,
      email: _email,
    );
  }
}
