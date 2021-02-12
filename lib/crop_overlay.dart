import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/crop_overlay_grid.dart';
import 'components/crop_overlay_handles.dart';
import 'components/crop_overlay_shade.dart';
import 'controllers/crop_controller.dart';
import 'controllers/crop_overlay_controller.dart';

class CropOverlay extends StatefulWidget {
  final String imageURL;
  final Color gridColor;
  final Color frameColor;
  final Color shadeColor;

  CropOverlay({
    Key key,
    @required this.imageURL,
    this.gridColor,
    this.frameColor,
    this.shadeColor,
  }) : super(key: key);

  @override
  _CropOverlayState createState() => _CropOverlayState();
}

class _CropOverlayState extends State<CropOverlay> {
  final CropOverlayController cropOverlayController =
      Get.put(CropOverlayController());
  final CropController cropController = Get.put(CropController());

  @override
  void initState() {
    super.initState();
    cropController.imageURL = widget.imageURL;
    cropOverlayController.gridColor = widget.gridColor;
    cropOverlayController.frameColor = widget.frameColor;
    cropOverlayController.shadeColor = widget.shadeColor;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: cropOverlayController.key,
      children: [
        Center(child: Image.network(widget.imageURL)),
        OverlayShades(),
        CropOverlayGrid(),
        CropOverlayHandles(),
      ],
    );
  }
}
