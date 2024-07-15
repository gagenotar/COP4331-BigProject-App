import 'package:flutter/material.dart';
import 'package:journey_journal_app/components/post.dart';
import 'package:journey_journal_app/components/api_service.dart';
import 'package:journey_journal_app/pages/settings_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.credentials,
    required this.email,
  });

  final Map<String, dynamic> credentials;
  final String email;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    String name = widget.credentials['firstName'];
    if (name == "") {
      name = widget.credentials['username'];
    }
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
                height:40,
                width:40,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.scaleDown,
                )
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
            icon: Icon(Icons.home_filled, color: Color.fromRGBO(38, 38, 38, 0.4),),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop,color: Color.fromRGBO(38, 38, 38, 0.4),),
            label: 'My Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box,color: Color.fromRGBO(38, 38, 38, 0.4),),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,color: Color.fromRGBO(38, 38, 38, 0.4),),
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
    return Center(
      child: Text('List Screen'),
    );
  }

  Widget buildAddReviewScreen() {
    return Center(
      child: Text('Add Review Screen'),
    );
  }

  Widget buildProfileScreen() {

    return SettingsPage( credentials: widget.credentials,
      email: widget.email,);
  }
}
