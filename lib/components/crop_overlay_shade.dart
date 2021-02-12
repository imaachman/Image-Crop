import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_crop/controllers/crop_overlay_controller.dart';

class OverlayShades extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Left
        OverlayShade(shadePosition: ShadePosition.TOP_LEFT),

        // Top Right
        OverlayShade(shadePosition: ShadePosition.TOP_RIGHT),

        // Bottom Left
        OverlayShade(shadePosition: ShadePosition.BOTTOM_LEFT),

        // Bottom Right
        OverlayShade(shadePosition: ShadePosition.BOTTOM_RIGHT),

        // Center Left
        OverlayShade(shadePosition: ShadePosition.CENTER_LEFT),

        // Center Top
        OverlayShade(shadePosition: ShadePosition.CENTER_TOP),

        // Center Right
        OverlayShade(shadePosition: ShadePosition.CENTER_RIGHT),

        // Center Bottom
        OverlayShade(shadePosition: ShadePosition.CENTER_BOTTOM),
      ],
    );
  }
}

class OverlayShade extends StatelessWidget {
  final CropOverlayController cropOverlayController = Get.find();

  final ShadePosition shadePosition;

  OverlayShade({Key key, this.shadePosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Positioned(
          left: cropOverlayController.getShadePositionLeft(shadePosition),
          top: cropOverlayController.getShadePositionTop(shadePosition),
          child: Opacity(
            opacity: 0.4,
            child: Container(
              width: cropOverlayController.getShadeWidth(shadePosition),
              height: cropOverlayController.getShadeHeight(shadePosition),
              color: cropOverlayController.shadeColor,
            ),
          ),
        ));
  }
}
