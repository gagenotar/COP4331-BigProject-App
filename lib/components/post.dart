import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.rating,
    this.image,
    required this.date,
    required this.username,
  });

  final String title;
  final String description;
  final Location location;
  final int rating;
  final dynamic image;
  final DateTime date;
  final String username;
  
  factory Post.fromJson(Map<String, dynamic> json){
    String host = "https://journey-journal-cop4331-71e6a1fdae61.herokuapp.com/";
    dynamic image;

    try{
      image = Image.network("$host${json['image']}", fit: BoxFit.fitWidth, errorBuilder: (_, e, __) => const SizedBox.shrink());
    } catch (e){
      image = const SizedBox.shrink();
    }
    
    return Post(
      title: json["title"],
      description: json["description"],
      location: Location.fromJson(json["location"]),
      rating: json["rating"],
      image: image,
      date: DateTime.parse(json["date"]),
      username: json["username"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        // // height: 700,
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
      
                    const SizedBox(width: 10),
      
                    Text(
                      DateFormat('MM/dd/yyyy').format(date),
                      style: const TextStyle(fontSize: 16, color: Colors.black54)
                    ),
                  ]
                ),
              ),
      
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: double.infinity,
                  child: image
                  ),
              ),
      
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
      
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  location.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height:20)
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandedPost extends StatelessWidget{
  const ExpandedPost({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.rating,
    this.image,
    required this.date,
    required this.username,
  });

  final String title;
  final String description;
  final Location location;
  final int rating;
  final dynamic image;
  final DateTime date;
  final String username;

  factory ExpandedPost.fromPost(Post post){
    return ExpandedPost(
      title: post.title,
      description: post.description,
      location: post.location,
      rating: post.rating,
      image: post.image,
      date: post.date,
      username: post.username,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Card(
          // // height: 700,
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
        
                      const SizedBox(width: 10),
        
                      Text(
                        DateFormat('MM/dd/yyyy').format(date),
                        style: const TextStyle(fontSize: 16, color: Colors.black54)
                      ),
                    ]
                  ),
                ),
        
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: double.infinity,
                  child: image
                  ),
              ),
        
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    ),
                  ),
                ),
        
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    location.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54
                    ),
                  ),
                ),
        
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(description)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({super.key, required this.text});

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  void toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleExpanded,
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState: _expanded
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: Text(
          widget.text,
        ),
        secondChild: Text(
          widget.text,
          maxLines: _expanded ? null : 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class Location {
  Location({
    required this.street, 
    required this.city, 
    required this.state,
    required this.country
  });

  final String street;
  final String city;
  final String state;
  final String country;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country']
    );
  }

  @override
  String toString()
  {
    List<String> address = [];
    if (street != "") address.add(street);
    if (city != "") address.add(city);
    if (state != "") address.add(state);
    if (country != "") address.add(country);

    return address.join(', ');
  }
}