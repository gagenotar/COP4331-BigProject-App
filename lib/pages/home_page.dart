import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:journey_journal_app/components/api_service.dart';
import 'package:journey_journal_app/pages/settings_page.dart';
import 'package:journey_journal_app/pages/add_entry_page.dart';
import 'package:journey_journal_app/components/post.dart';
import 'package:journey_journal_app/pages/my_trips_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.credentials,
    required this.email,
  });

  final Map<String, dynamic> credentials;
  final String email;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;
  late String _email; // Declare a mutable variable for email

  late Future<List<dynamic>> _posts;

  late Post _currentPost;

  bool _postExpanded = false;

  @override
  void initState() {
    super.initState();

    _email = widget.email; // Initialize _email with initial value of email
    _posts = ApiService.searchEntries("", "");
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
          title: Text(
            "HOME",
            style:GoogleFonts.anton(
                color: Colors.black,
                fontSize:30
            ),
          )
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
        return buildHomeScreen(context);
      case 1:
        return buildListScreen();
      case 2:
        return buildAddReviewScreen();
      case 3:
        return buildProfileScreen();
      default:
        return buildHomeScreen(context); // Default to HomeScreen
    }
  }

  Widget buildHomeScreen(BuildContext context) {

    if (_postExpanded){
      return InkWell(
        onTap: () {
          setState(() => _postExpanded = false);
        },
        child: ExpandedPost.fromPost(_currentPost)
      );
    } 

    return FutureBuilder<List<dynamic>>(
      future: _posts,
      builder: (context,snapshot){
        return snapshot.hasData
        ? ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (_, position){
              Post post = Post.fromJson(snapshot.data![position]);
              return InkWell(
                onTap: () {
                  setState(() => _postExpanded = true);
                  setState(() => _currentPost = post);
                },
                child: post,
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator()
          );
      }
    );
  }


  Widget buildListScreen() {

    return MyTripsPage(credentials: widget.credentials,
        email: widget.email);

  }

  Widget buildAddReviewScreen() {
    return AddEntryPage(
      credentials: widget.credentials,
      email: widget.email

    );
  }


  Widget buildProfileScreen() {
    return SettingsPage(
      userId: '${widget.credentials['id']}'

    );
  }
}
