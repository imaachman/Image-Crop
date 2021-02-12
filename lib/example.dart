import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/crop_controller.dart';
import 'controllers/crop_overlay_controller.dart';
import 'crop_overlay.dart';

class ExampleApp extends StatelessWidget {
  final CropController cropController = Get.put(CropController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cropController.cropImage();
          Get.to(Page());
        },
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 500,
          child: CropOverlay(
            imageURL:
                'https://images.unsplash.com/photo-1612461761155-02bf5a667fca?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
            gridColor: Colors.white60,
            frameColor: Color(0xFF5c69e5),
            shadeColor: Color(0xFF5c69e5),
          ),
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final CropController cropController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Image.memory(cropController.cropImage()),
        ),
      ),
    );
  }
}
