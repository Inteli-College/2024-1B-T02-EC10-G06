import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  CameraDescription? selectedCamera;
  bool _isCameraInitialized = false;
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      selectedCamera = cameras![0];
      _controller = CameraController(
        selectedCamera!,
        ResolutionPreset.high,
      );

      _controller?.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isCameraInitialized = true;
        });
      });
    }
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) {
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';

    if (_controller!.value.isTakingPicture) {
      // A captura de imagem está em andamento, retorne.
      return null;
    }

    try {
      XFile picture = await _controller!.takePicture();
      await picture.saveTo(filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Picture saved to $filePath')),
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Screen'),
      ),
      body: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_controller!),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      onPressed: _takePicture,
                      child: Icon(Icons.camera),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
