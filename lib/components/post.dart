import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    required this.username,
    this.image,
    required this.title,
    required this.location,
    this.body = ""
  });

  final String username;
  final Image? image;
  final String title;
  final String location;
  final String body;
  


  @override
  Widget build(BuildContext context) {
    return Container(
      // // height: 700,
      width: 468,
      color: Colors.amber[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: image,
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Text(
                location,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            ExpandableText(text: body),
          ],
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

