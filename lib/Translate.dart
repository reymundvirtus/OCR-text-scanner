import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class Translate extends StatefulWidget {
  final String text;
  Translate(this.text);

  @override
  State<Translate> createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  final TextEditingController textEditingController = TextEditingController();
  var translatedPhrase = "";
  var translator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  minLines: 10,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Translate text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('Translate', style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                ),
                onPressed: () {
                  setState(() {
                    translator.translate(textEditingController.text, from: 'en', to: 'es').then((t) {
                      setState(() {
                        translatedPhrase = t as String;
                      });
                    });
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translatedPhrase,
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.clear_outlined),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            tooltip: 'Clear',
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_outlined),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            tooltip: 'Copy',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
