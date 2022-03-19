import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Speech extends StatefulWidget {
  const Speech({Key? key}) : super(key: key);

  @override
  State<Speech> createState() => _SpeechState();
}

class _SpeechState extends State<Speech> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  labelText: 'Text to speak',
                ),
              ),
              ElevatedButton(
                onPressed: () => speak(textEditingController.text),
                child: const Text("Start Text to Speech"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1); // 0.5 to 1.5
    await flutterTts.speak(text);
  }
}
