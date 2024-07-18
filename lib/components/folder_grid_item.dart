import 'package:flutter/material.dart';
import '../models/folder.dart';

class FolderGridItem extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;

  const FolderGridItem({
    Key? key,
    required this.folder,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder, size: 48, color: Colors.blue[300]),
            const SizedBox(height: 8),
            Text(folder.name, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
