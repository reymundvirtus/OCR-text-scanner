import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class Translate extends StatefulWidget {
  const Translate({Key? key}) : super(key: key);
  // final String text;
  // Translate(this.text);

  @override
  State<Translate> createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  String dropdownFrom = "English";
  String dropdownTo = "Filipino";
  String userinput = "";
  String result = "";

  List<String> availableLang = <String>['English', 'Filipino', 'Japnease', 'Korean'];
  List<String> languageCode = <String>['en', 'tl', 'ja', 'ko'];

  GoogleTranslator translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();

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
                userinput = "";
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
            TextFormField(
              minLines: 10,
              maxLines: 10,
              onChanged: (val) {
                setState(() {
                  userinput = val;
                });
              },
              decoration: const InputDecoration(
                labelText: "Translate text",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
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
              child: Text(result,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                )
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
        .translate(userinput,
            from: languageCode[availableLang.indexOf(dropdownFrom)],
            to: languageCode[availableLang.indexOf(dropdownTo)])
        .then(print);
    var translation = await translator.translate(userinput,
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
