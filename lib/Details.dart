import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'Home.dart';
import 'Settings.dart';
import 'Speech.dart';
import 'Translate.dart';

class Details extends StatefulWidget {
  final String text;
  Details(this.text);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final FlutterTts flutterTts = FlutterTts();
  int _index = 0;
  
  @override
  Widget build(BuildContext context) {
    switch(_index) {
      case 0:
        break;

      case 1:
        Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home(widget.text)),
                );
        break;

      case 2:
        Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
        break;
    }

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text("Extracted Text"),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              FlutterClipboard.copy(widget.text).then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied'),
                  behavior: SnackBarBehavior.floating,
              )));
            },
            tooltip: 'Copy',
          ),
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Translate(widget.text)),
              );
            },
            tooltip: 'Translate',
          ),
          IconButton(
            icon: const Icon(Icons.speaker_phone),
            onPressed: () {
              speak(widget.text);
            },
            tooltip: 'Speak',
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: SelectableText(
            widget.text.isEmpty ? "No text scanned" : widget.text),
      ),
      bottomNavigationBar: _bottomTab(), 
    );
  }

  Widget _bottomTab() {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (int index) => setState(() => _index = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          label: 'Details',
          backgroundColor: Colors.pink,
          tooltip: 'Details',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          backgroundColor: Colors.pink,
          tooltip: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
          backgroundColor: Colors.pink,
          tooltip: 'Settings',
        ),
      ],
      selectedItemColor: Colors.yellowAccent,
    );
  }

  speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(0.7); // 0.5 to 1.5
    await flutterTts.speak(text);
  }
}
