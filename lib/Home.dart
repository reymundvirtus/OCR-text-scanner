import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_text_scanner/Drawer.dart';
import 'Details.dart';

class Home extends StatefulWidget {
  final String text;
  Home(this.text);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String imagePath = '';
  String finalText = '';
  bool isLoaded = false;
  late File finalImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerSelect(widget.text),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        actions: [
          TextButton(
            onPressed: () => clearImage(),
            child: isLoaded ? const Text(
              'Clear',
              style: TextStyle(
                color: Colors.white,
              ),
            ) : const Text(''),
          ),
          IconButton(
            icon: const Icon(Icons.image_outlined),
            onPressed: () { 
              getImage();
            }, 
          ),
          IconButton(
            icon: const Icon(Icons.document_scanner_outlined),
            onPressed: () { 
              clearText();
              isLoaded ? scanText(imagePath) : ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No Image Selected'),
                  behavior: SnackBarBehavior.floating,
                ));
            }, 
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
            : const Center(
                child: Text(
                  'No Image Selected',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }

  // scan text from image
  Future scanText(String path) async {
    buildShowDialog(context);

    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetectorV2();
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

  // picking image
  void getImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      finalImagePath = File(image!.path);
      isLoaded = true;
      imagePath = image.path.toString();
    });

    scanText(imagePath);
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

  // clear image
  void clearImage() {
    setState(() {
      finalText = '';
      imagePath = '';
      isLoaded = false;
    });
  }

  // clear text
  void clearText() {
    setState(() {
      finalText = '';
    });
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
