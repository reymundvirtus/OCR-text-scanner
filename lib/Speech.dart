import 'package:flutter/material.dart';

class Speech extends StatefulWidget {
  const Speech({ Key? key }) : super(key: key);

  @override
  State<Speech> createState() => _SpeechState();
}

class _SpeechState extends State<Speech> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech'),
      ),
    );
  }
}