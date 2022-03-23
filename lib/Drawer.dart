import 'package:flutter/material.dart';
import 'Settings.dart';
import 'Speech.dart';
import 'Translate.dart';
import 'scratch.dart';

class DrawerSelect extends StatefulWidget {
  final String text;
  DrawerSelect(this.text);

  @override
  State<DrawerSelect> createState() => _DrawerSelectState();
}

class _DrawerSelectState extends State<DrawerSelect> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.pink[200],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Center(
                child: Text(
                  'OCR: Text Scanner',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.speaker_phone,
                color: Colors.white,
              ),
              title: const Text(
                "Speaker",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Speech()),
                );
              },
              hoverColor: Colors.white60,
            ),
            ListTile(
              leading: const Icon(
                Icons.translate,
                color: Colors.white,
              ),
              title: const Text(
                "Translate",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Translate()),
                );
              },
              hoverColor: Colors.white60,
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
              title: const Text(
                "Settings",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
              hoverColor: Colors.white60,
            ),
          ],
        ),
      ),
    );
  }
}