import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CameraExampleHome extends StatefulWidget {
  @override
  _CameraExampleHomeState createState() {
    return new _CameraExampleHomeState();
  }
}

IconData cameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw new ArgumentError('Unknown lens direction');
}

class _CameraExampleHomeState extends State<CameraExampleHome> {
  bool opening = false;
  CameraController controller;
  String imagePath;
  int pictureCount = 0;
  Expanded camera;

  @override
  void initState() {
    super.initState();
    cameraWidget();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: camera == null ? new Container() : new Column(children: <Widget>[camera])
    );
  }

  cameraWidget() {
    controller = new CameraController(cameras[0], ResolutionPreset.high);
    controller.addListener((){
      if (!mounted) {
        return;
      }

      camera = new Expanded(
          child: new AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: new CameraPreview(controller),
          ));

      setState(() {});
    });
    controller.initialize();
  }

  Widget imageWidget() {
    return new Expanded(
      child: new Align(
        alignment: Alignment.centerRight,
        child: new SizedBox(
          child: new Image.file(new File(imagePath)),
          width: 64.0,
          height: 64.0,
        ),
      ),
    );
  }

  Future<Null> capture() async {
    if (controller.value.isStarted) {
      final Directory tempDir = await getTemporaryDirectory();
      if (!mounted) {
        return;
      }
      final String tempPath = tempDir.path;
      final String path = '$tempPath/picture${pictureCount++}.jpg';
      await controller.capture(path);

      if (!mounted) {
        return;
      }
      setState(
        () {
          imagePath = path;
        },
      );
    }
  }
}

List<CameraDescription> cameras;

Future<Null> main() async {
  cameras = await availableCameras();
  runApp(new MaterialApp(home: new CameraExampleHome()));
}