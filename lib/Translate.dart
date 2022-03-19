import 'package:flutter/material.dart';

class Translate extends StatefulWidget {
  final String text;
  Translate(this.text);

  @override
  State<Translate> createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate'),
      ),
    );
  }
}