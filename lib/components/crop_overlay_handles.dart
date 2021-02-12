import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_crop/constants/constants.dart';

import '../controllers/crop_overlay_controller.dart';

class CropOverlayHandles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          // Top Left
          CropOverlayCornerHandle(handlePosition: HandlePosition.TOP_LEFT),
          // Top Right
          CropOverlayCornerHandle(handlePosition: HandlePosition.TOP_RIGHT),
          // Bottom Left
          CropOverlayCornerHandle(handlePosition: HandlePosition.BOTTOM_LEFT),
          // Bottom Right
          CropOverlayCornerHandle(handlePosition: HandlePosition.BOTTOM_RIGHT),
          // Center Left
          CropOverlayEdgeHandle(handlePosition: HandlePosition.CENTER_LEFT),
          // Center Top
          CropOverlayEdgeHandle(handlePosition: HandlePosition.CENTER_TOP),
          // Center Right
          CropOverlayEdgeHandle(handlePosition: HandlePosition.CENTER_RIGHT),
          // Center Bottom
          CropOverlayEdgeHandle(handlePosition: HandlePosition.CENTER_BOTTOM),
        ],
      ),
    );
  }
}

class CropOverlayCornerHandle extends StatelessWidget {
  final CropOverlayController cropOverlayController = Get.find();

  final HandlePosition handlePosition;

  CropOverlayCornerHandle({Key key, @required this.handlePosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Positioned(
          left: cropOverlayController.getHandlePositionLeft(handlePosition),
          top: cropOverlayController.getHandlePositionTop(handlePosition),
          child: GestureDetector(
            onPanUpdate: (details) {
              double dx = details.delta.dx;
              double dy = details.delta.dy;
              cropOverlayController.dragHandle(handlePosition, dx, dy);

              cropOverlayController.showGrid();
            },
            onPanEnd: (details) {
              cropOverlayController.hideGrid();
            },
            child: Transform.rotate(
              angle: cropOverlayController.getHandleAngle(handlePosition),
              child: Container(
                width: kOverlayHandleLength,
                height: kOverlayHandleLength,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: kOverlayHandleLength - kOverlayHandleThickness,
                      width: kOverlayHandleThickness,
                      color: cropOverlayController.frameColor,
                    ),
                    Container(
                      width: kOverlayHandleLength,
                      height: kOverlayHandleThickness,
                      color: cropOverlayController.frameColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class CropOverlayEdgeHandle extends StatelessWidget {
  final CropOverlayController cropOverlayController = Get.find();

  final HandlePosition handlePosition;

  CropOverlayEdgeHandle({Key key, @required this.handlePosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Positioned(
          left: cropOverlayController.getHandlePositionLeft(handlePosition),
          top: cropOverlayController.getHandlePositionTop(handlePosition),
          child: GestureDetector(
            onPanUpdate: (details) {
              double dx = details.delta.dx;
              double dy = details.delta.dy;
              cropOverlayController.dragHandle(handlePosition, dx, dy);

              cropOverlayController.showGrid();
            },
            onPanEnd: (details) {
              cropOverlayController.hideGrid();
            },
            child: Transform.rotate(
              angle: cropOverlayController.getHandleAngle(handlePosition),
              child: Container(
                height: kOverlayHandleLength,
                width: kOverlayHandleThickness,
                color: cropOverlayController.frameColor,
              ),
            ),
          ),
        ));
  }
}
