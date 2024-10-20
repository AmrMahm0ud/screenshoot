import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Colors.yellow,
          ),
        ),
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Screenshot Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 5.0),
                  color: Colors.amberAccent,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'asset/images/flutter.png',
                    ),
                    Image.asset(
                      'asset/images/flutter.png',
                    ),
                    Image.asset(
                      'asset/images/flutter.png',
                    ),
                    Text("This widget will be captured as an image"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              child: Text('Capture, Save and Share'),
              onPressed: () async {
                // Capture the screenshot
                Uint8List? capturedImage = await screenshotController.capture();

                if (capturedImage != null) {
                  // Save the screenshot to the gallery
                  final result = await ImageGallerySaver.saveImage(
                    capturedImage,
                    quality: 100,
                    name: "screenshot_${Random().nextInt(10000)}",
                  );

                  if (result['isSuccess']) {
                    print("Image saved to gallery");

                    // Get the image path
                    final directory = await getTemporaryDirectory(); // Use a temporary directory
                    String fileName = "screenshot_${Random().nextInt(10000)}.png";
                    final imagePath = '${directory.path}/$fileName';

                    // Save the file temporarily
                    File imageFile = File(imagePath);
                    await imageFile.writeAsBytes(capturedImage);

                    // Share the image to WhatsApp or other apps
                    Share.shareFiles([imageFile.path], text: 'Check out this screenshot!');
                  } else {
                    print("Failed to save image");
                  }
                } else {
                  print("Failed to capture image");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
