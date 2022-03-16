import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanText extends StatefulWidget {
  const ScanText({Key? key}) : super(key: key);

  @override
  State<ScanText> createState() => _ScanTextState();
}

class _ScanTextState extends State<ScanText> {
  String imagePath = '';
  String finalText = '';
  bool isLoaded = false;
  late File finalImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: Colors.teal,
              child: isLoaded
                  ? Image.file(
                      finalImagePath,
                      fit: BoxFit.fill,
                    )
                  : const Text("This is image section"),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                onPressed: () {
                  getImage();
                  if (isLoaded) {
                    Future.delayed(const Duration(seconds: 1), () {
                      extractText(imagePath);
                    });
                  }
                },
                onLongPress: () {
                  cameraImage();
                  if (isLoaded) {
                    Future.delayed(const Duration(seconds: 1), () {
                      extractText(imagePath);
                    });
                  }
                },
                child: Text(
                  'Click for Gallery or Long Press for Camera',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            Text(
              finalText != null ? finalText : "This is my text",
              style: GoogleFonts.aBeeZee(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // extracting text from image
  Future extractText(String path) async {
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
  }

  // camera image
  void cameraImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      finalImagePath = File(image!.path);
      isLoaded = true;
      imagePath = image.path.toString();
    });
  }
}
