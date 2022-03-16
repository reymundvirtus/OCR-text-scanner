import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'Details.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String imagePath = '';
  String finalText = '';
  bool isLoaded = false;
  late File finalImagePath;
  // PickedFile _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR: Text Scanner'),
        backgroundColor: Colors.pink,
        actions: [
          TextButton(
            onPressed: () => scanText(imagePath),
            child: const Text(
              'Scan',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => cameraImage(),
        child: const Icon(Icons.camera_alt_outlined),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: isLoaded ? Image.file(finalImagePath, fit: BoxFit.fill)
            : const Center(child: Text("Capture an Image"),)
      ),
    );
  }

  Future scanText(String path) async {
    buildShowDialog(context);

    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognizedText =
        await textDetector.processImage(inputImage);

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          setState(() {
            finalText = finalText + " " + element.text;
          });
        }

        finalText = finalText + '\n';
      }
    }

    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Details(finalText)));
  }

  // camera image
  void cameraImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      finalImagePath = File(image!.path);
      isLoaded = true;
      imagePath = image.path.toString();
    });

    scanText(imagePath);
  }

  // loading
  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
