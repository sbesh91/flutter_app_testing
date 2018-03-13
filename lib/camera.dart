import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';


class CameraHome extends StatefulWidget {
  @override
  _CameraHomeState createState() {
    return new _CameraHomeState(availableCameras());
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

class _CameraHomeState extends State<CameraHome> {
  bool opening = false;
  CameraController controller;
  String imagePath;
  int pictureCount = 0;
  AspectRatio camera;
  List<CameraDescription> cameras;

  _CameraHomeState(Future<List<CameraDescription>> cameras) {
    cameras.then((List<CameraDescription> value) {
      this.cameras = value;
      cameraWidget();
    });
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(cameras == null || camera == null) return new Container();

    return camera;
  }

  cameraWidget() {
    controller = new CameraController(cameras[0], ResolutionPreset.high);
    controller.addListener((){
      if (!mounted) {
        return;
      }

      camera = new AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: new CameraPreview(controller),
          );

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