import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class ExtractTranslate extends StatefulWidget {
  final String text;
  ExtractTranslate(this.text);

  @override
  State<ExtractTranslate> createState() => _ExtractTranslateState();
}

class _ExtractTranslateState extends State<ExtractTranslate> {
  String dropdownFrom = "English";
  String dropdownTo = "Filipino";
  String userinput = "";
  String result = "";

  List<String> availableLang = <String>['English', 'Filipino', 'Japnease', 'Korean'];
  List<String> languageCode = <String>['en', 'tl', 'ja', 'ko'];

  GoogleTranslator translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                result = "";
              });
            },
            tooltip: 'Clear',
          ),
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            onPressed: () {
              FlutterClipboard.copy(result).then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied'),
                  behavior: SnackBarBehavior.floating,
              )));
            },
            tooltip: 'Copy',
          ),
          IconButton(
            icon: const Icon(Icons.speaker_phone),
            onPressed: () {
              speak(result);
            },
            tooltip: 'Speak',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(
          children: [
            // First Row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('From:  ')),
                Expanded(
                  flex: 5,
                  child: DropdownButton(
                    value: dropdownFrom,
                    elevation: 16,
                    style: const TextStyle(color: Colors.pink),
                    underline: Container(
                      height: 2,
                      color: Colors.pink,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownFrom = newValue!;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    isExpanded: true,
                    items: availableLang
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(), 
                  ),
                ),
              ],
            ),
            // Second Row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('To:  ')),
                Expanded(
                  flex: 5,
                  child: DropdownButton<String>(
                    value: dropdownTo,
                    elevation: 16,
                    style: const TextStyle(color: Colors.pink),
                    underline: Container(
                      height: 2,
                      color: Colors.pink,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownTo = newValue!;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    isExpanded: true,
                    items: availableLang
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // TextFormFeild
            Center(
              child: SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: SelectableText(
                    widget.text,
                  ),
                ),
              )
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.pink,
              ),
              child: const Text('Translate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )
              ),
              onPressed: () {
                trans();
              }
            ),
            const SizedBox(
              height: 10,
            ),
            // Result
            Center(
              child: SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: SelectableText(result,
                    style: const TextStyle(
                      color: Colors.black,
                    )
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  void trans() async {
    final translator = GoogleTranslator();
    translator
        .translate(widget.text,
            from: languageCode[availableLang.indexOf(dropdownFrom)],
            to: languageCode[availableLang.indexOf(dropdownTo)])
        .then(print);
    var translation = await translator.translate(widget.text,
        to: languageCode[availableLang.indexOf(dropdownTo)]);
    setState(() {
      result = translation.text;
    });
  }

  // text to speech
  speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(0.7); // 0.5 to 1.5
    await flutterTts.speak(text);
  }
}