import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/crop_overlay_controller.dart';

class CropOverlayGrid extends StatelessWidget {
  final CropOverlayController cropOverlayController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Positioned(
          top: cropOverlayController.cropOverlayY1.value,
          left: cropOverlayController.cropOverlayX1.value,
          child: Container(
            width: cropOverlayController.cropOverlayWidth.value,
            height: cropOverlayController.cropOverlayHeight.value,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: cropOverlayController.frameColor)),
            child: GestureDetector(
              onPanUpdate: (details) {
                cropOverlayController.showGrid();
                double dx = details.delta.dx;
                double dy = details.delta.dy;
                cropOverlayController.editCropOverlayPosition(dx, dy);
              },
              onPanEnd: (details) {
                cropOverlayController.hideGrid();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CropOverlayGridTile(),
                        CropOverlayGridTile(),
                        CropOverlayGridTile()
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CropOverlayGridTile(),
                        CropOverlayGridTile(),
                        CropOverlayGridTile()
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CropOverlayGridTile(),
                        CropOverlayGridTile(),
                        CropOverlayGridTile()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class CropOverlayGridTile extends StatelessWidget {
  final CropOverlayController cropOverlayController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Obx(() => AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: cropOverlayController.cropOverlayGridOpacity.value,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5, color: cropOverlayController.gridColor)),
              ),
            )));
  }
}
