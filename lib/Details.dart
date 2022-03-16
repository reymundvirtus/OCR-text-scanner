import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class Details extends StatefulWidget {
  final String text;
  Details(this.text);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  int _index = 0;
  
  @override
  Widget build(BuildContext context) {
    switch(_index) {
      case 0:
        FlutterClipboard.copy(widget.text).then((value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied'))));
        break;

      case 1:
        break;
    }
    
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text("Extract Text"),
        backgroundColor: Colors.pink,
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
          icon: Icon(Icons.copy),
          label: 'Copy',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.translate),
          label: 'Translate',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.voicemail),
          label: 'Voice',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
          backgroundColor: Colors.pink,
        ),
      ],
      selectedItemColor: Colors.yellowAccent,
    );
  }
}
