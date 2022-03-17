import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_text_scanner/Drawer.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerSelect(),
      appBar: AppBar(
        title: const Text('OCR: Text Scanner'),
        backgroundColor: Colors.pink,
        actions: [
          TextButton(
            onPressed: () => clearImage(),
            child: const Text(
              'Clear',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
          onPressed: () { 
            clearText();
            isLoaded ? scanText(imagePath) : ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No Image Selected'),
                behavior: SnackBarBehavior.floating,
              ));
            },
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
            : Center(child: ElevatedButton(
              onPressed: () => getImage(),
              child: const Text('Gallery', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                primary: Colors.pink,
              ),
            ),)
      ),
    );
  }

  // scan text from image
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
