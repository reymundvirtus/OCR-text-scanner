import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'Home.dart';
import 'Settings.dart';
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text("Text"),
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
                  MaterialPageRoute(builder: (context) => Translate()),
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
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: SelectableText(
          widget.text.isEmpty ? "No text scanned" : widget.text, style: const TextStyle(fontSize: 15),),
      ),
    );
  }

  speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(0.7); // 0.5 to 1.5
    await flutterTts.speak(text);
  }
}
