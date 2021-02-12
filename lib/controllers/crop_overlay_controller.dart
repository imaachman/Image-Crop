import 'dart:math';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_crop/constants/constants.dart';

class CropOverlayController extends GetxController {
  RxDouble cropOverlayWidth = 0.0.obs;
  RxDouble cropOverlayHeight = 0.0.obs;

  RxDouble cropOverlayX1 = 0.0.obs;
  RxDouble cropOverlayY1 = 0.0.obs;
  RxDouble cropOverlayX2 = 0.0.obs;
  RxDouble cropOverlayY2 = 0.0.obs;

  Rect cropOverlayBounds = Rect.zero;

  RxDouble cropOverlayGridOpacity = 0.0.obs;

  Color gridColor = Colors.black;
  Color frameColor = Colors.black;
  Color shadeColor = Colors.black;

  GlobalKey key = GlobalKey();

  double minWidth;
  double minHeight;

  @override
  void onInit() {
    super.onInit();

    minWidth = (kOverlayHandleLength - kOverlayHandleThickness) * 3;
    minHeight = (kOverlayHandleLength - kOverlayHandleThickness) * 3;
  }

  @override
  void onReady() {
    super.onReady();

    initializeCropOverlay();
  }

  void initializeCropOverlay() {
    // Find Overlay stack.
    RenderBox renderBox = key.currentContext.findRenderObject();

    // Initiate overlay dimensions.
    cropOverlayWidth.value = renderBox.size.width;
    cropOverlayHeight.value = renderBox.size.height;

    cropOverlayX2.value = cropOverlayWidth.value;
    cropOverlayY2.value = cropOverlayHeight.value;

    // Calculate overlay bounds.
    cropOverlayBounds = Rect.fromLTRB(cropOverlayX1.value, cropOverlayY1.value,
        cropOverlayX2.value, cropOverlayY2.value);
  }

  void syncCropOverlayWidthHeight() {
    cropOverlayWidth.value = cropOverlayX2.value - cropOverlayX1.value;
    cropOverlayHeight.value = cropOverlayY2.value - cropOverlayY1.value;
  }

  void editCropOverlayPosition(double dx, double dy) {
    double updatedCropOverlayX1 = cropOverlayX1.value + dx;
    double updatedCropOverlayY1 = cropOverlayY1.value + dy;

    double updatedCropOverlayX2 = cropOverlayX2.value + dx;
    double updatedCropOverlayY2 = cropOverlayY2.value + dy;

    bool insideHorzontalBounds =
        cropOverlayBounds.contains(Offset(updatedCropOverlayX1, 0)) &&
            cropOverlayBounds.contains(Offset(updatedCropOverlayX2, 0));

    bool insideVerticalBounds =
        cropOverlayBounds.contains(Offset(0, updatedCropOverlayY1)) &&
            cropOverlayBounds.contains(Offset(0, updatedCropOverlayY2));

    bool overflowLeft = updatedCropOverlayX1 < cropOverlayBounds.left;
    bool overflowTop = updatedCropOverlayY1 < cropOverlayBounds.top;
    bool overflowRight = updatedCropOverlayX2 > cropOverlayBounds.right;
    bool overflowBottom = updatedCropOverlayY2 > cropOverlayBounds.bottom;

    if (insideHorzontalBounds) {
      cropOverlayX1.value = updatedCropOverlayX1;
      cropOverlayX2.value = updatedCropOverlayX2;
    }
    if (insideVerticalBounds) {
      cropOverlayY1.value = updatedCropOverlayY1;
      cropOverlayY2.value = updatedCropOverlayY2;
    }
    if (overflowLeft) {
      cropOverlayX1.value = cropOverlayBounds.left;
      cropOverlayX2.value = cropOverlayWidth.value;
    }
    if (overflowTop) {
      cropOverlayY1.value = cropOverlayBounds.top;
      cropOverlayY2.value = cropOverlayHeight.value;
    }
    if (overflowRight) {
      cropOverlayX1.value = cropOverlayBounds.right - cropOverlayWidth.value;
      cropOverlayX2.value = cropOverlayBounds.right;
    }
    if (overflowBottom) {
      cropOverlayY1.value = cropOverlayBounds.bottom - cropOverlayHeight.value;
      cropOverlayY2.value = cropOverlayBounds.bottom;
    }
  }

  double getHandlePositionLeft(HandlePosition handlePosition) {
    switch (handlePosition) {
      case HandlePosition.TOP_LEFT:
        return cropOverlayX1.value;
      case HandlePosition.TOP_RIGHT:
        return cropOverlayX2.value - kOverlayHandleLength;
      case HandlePosition.BOTTOM_LEFT:
        return cropOverlayX1.value;
      case HandlePosition.BOTTOM_RIGHT:
        return cropOverlayX2.value - kOverlayHandleLength;
      case HandlePosition.CENTER_LEFT:
        return cropOverlayX1.value;
      case HandlePosition.CENTER_TOP:
        return cropOverlayX1.value +
            (cropOverlayWidth.value - kOverlayHandleLength) / 2;
      case HandlePosition.CENTER_RIGHT:
        return cropOverlayX2.value - kOverlayHandleThickness;
      case HandlePosition.CENTER_BOTTOM:
        return cropOverlayX1.value +
            (cropOverlayWidth.value - kOverlayHandleLength) / 2;
      default:
        return 0;
    }
  }

  double getHandlePositionTop(HandlePosition handlePosition) {
    switch (handlePosition) {
      case HandlePosition.TOP_LEFT:
        return cropOverlayY1.value;
      case HandlePosition.TOP_RIGHT:
        return cropOverlayY1.value;
      case HandlePosition.BOTTOM_LEFT:
        return cropOverlayY2.value - kOverlayHandleLength;
      case HandlePosition.BOTTOM_RIGHT:
        return cropOverlayY2.value - kOverlayHandleLength;
      case HandlePosition.CENTER_LEFT:
        return cropOverlayY1.value +
            (cropOverlayHeight.value - kOverlayHandleLength) / 2;
      case HandlePosition.CENTER_TOP:
        return cropOverlayY1.value - kOverlayHandleThickness;
      case HandlePosition.CENTER_RIGHT:
        return cropOverlayY1.value +
            (cropOverlayHeight.value - kOverlayHandleLength) / 2;
      case HandlePosition.CENTER_BOTTOM:
        return cropOverlayY2.value - kOverlayHandleThickness * 2;
      default:
        return 0;
    }
  }

  double getHandleAngle(HandlePosition handlePosition) {
    switch (handlePosition) {
      case HandlePosition.TOP_LEFT:
        return pi / 2;
      case HandlePosition.TOP_RIGHT:
        return pi;
      case HandlePosition.BOTTOM_LEFT:
        return 0;
      case HandlePosition.BOTTOM_RIGHT:
        return 3 * pi / 2;
      case HandlePosition.CENTER_LEFT:
        return 0;
      case HandlePosition.CENTER_TOP:
        return pi / 2;
      case HandlePosition.CENTER_RIGHT:
        return 0;
      case HandlePosition.CENTER_BOTTOM:
        return pi / 2;
      default:
        return 0;
    }
  }

  void dragHandle(HandlePosition handlePosition, double dx, double dy) {
    switch (handlePosition) {
      case HandlePosition.TOP_LEFT:
        dragTopLeftHandle(dx, dy);
        break;
      case HandlePosition.TOP_RIGHT:
        dragTopRightHandle(dx, dy);
        break;
      case HandlePosition.BOTTOM_LEFT:
        dragBottomLeftHandle(dx, dy);
        break;
      case HandlePosition.BOTTOM_RIGHT:
        dragBottomRightHandle(dx, dy);
        break;
      case HandlePosition.CENTER_LEFT:
        dragCenterLeftHandle(dx);
        break;
      case HandlePosition.CENTER_TOP:
        dragCenterTopHandle(dy);
        break;
      case HandlePosition.CENTER_RIGHT:
        dragCenterRightHandle(dx);
        break;
      case HandlePosition.CENTER_BOTTOM:
        dragCenterBottomHandle(dy);
        break;
    }
  }

  void dragTopLeftHandle(double dx, double dy) {
    double updatedCropOverlayX1 = cropOverlayX1.value + dx;
    double updatedCropOverlayY1 = cropOverlayY1.value + dy;

    double updatedCropOverlayWidth = cropOverlayX2.value - updatedCropOverlayX1;
    double updatedCropOverlayHeight =
        cropOverlayY2.value - updatedCropOverlayY1;

    bool insideBounds = cropOverlayBounds
        .contains(Offset(updatedCropOverlayX1, updatedCropOverlayY1));

    bool overflowLeft = updatedCropOverlayX1 < cropOverlayBounds.left;
    bool overflowTop = updatedCropOverlayY1 < cropOverlayBounds.top;
    bool overflowRight = updatedCropOverlayWidth < minWidth;
    bool overflowBottom = updatedCropOverlayHeight < minHeight;

    if (insideBounds) {
      cropOverlayX1.value = updatedCropOverlayX1;
      cropOverlayY1.value = updatedCropOverlayY1;
    }

    if (overflowLeft) {
      cropOverlayX1.value = cropOverlayBounds.left;
    }

    if (overflowTop) {
      cropOverlayY1.value = cropOverlayBounds.top;
    }

    if (overflowRight) {
      cropOverlayX1.value = cropOverlayX2.value - minWidth;
    }

    if (overflowBottom) {
      cropOverlayY1.value = cropOverlayY2.value - minHeight;
    }

    syncCropOverlayWidthHeight();
  }

  void dragTopRightHandle(double dx, double dy) {
    double updatedCropOverlayX2 = cropOverlayX2.value + dx;
    double updatedCropOverlayY1 = cropOverlayY1.value + dy;

    double updatedCropOverlayWidth = updatedCropOverlayX2 - cropOverlayX1.value;
    double updatedCropOverlayHeight =
        cropOverlayY2.value - updatedCropOverlayY1;

    bool insideBounds = cropOverlayBounds
        .contains(Offset(updatedCropOverlayX2, updatedCropOverlayY1));

    bool overflowLeft = updatedCropOverlayWidth < minWidth;
    bool overflowTop = updatedCropOverlayY1 < cropOverlayBounds.top;
    bool overflowRight = updatedCropOverlayX2 > cropOverlayBounds.right;
    bool overflowBottom = updatedCropOverlayHeight < minHeight;

    if (insideBounds) {
      cropOverlayX2.value = updatedCropOverlayX2;
      cropOverlayY1.value = updatedCropOverlayY1;
    }

    if (overflowLeft) {
      cropOverlayX2.value = cropOverlayX1.value + minWidth;
    }

    if (overflowTop) {
      cropOverlayY1.value = cropOverlayBounds.top;
    }

    if (overflowRight) {
      cropOverlayX2.value = cropOverlayBounds.right;
    }

    if (overflowBottom) {
      cropOverlayY1.value = cropOverlayY2.value - minHeight;
    }

    syncCropOverlayWidthHeight();
  }

  void dragBottomLeftHandle(double dx, double dy) {
    double updatedCropOverlayX1 = cropOverlayX1.value + dx;
    double updatedCropOverlayY2 = cropOverlayY2.value + dy;

    double updatedCropOverlayWidth = cropOverlayX2.value - updatedCropOverlayX1;
    double updatedCropOverlayHeight =
        updatedCropOverlayY2 - cropOverlayY1.value;

    bool insideBounds = cropOverlayBounds
        .contains(Offset(updatedCropOverlayX1, updatedCropOverlayY2));

    bool overflowLeft = updatedCropOverlayX1 < cropOverlayBounds.left;
    bool overflowTop = updatedCropOverlayHeight < minHeight;
    bool overflowRight = updatedCropOverlayWidth < minWidth;
    bool overflowBottom = updatedCropOverlayY2 > cropOverlayBounds.bottom;

    if (insideBounds) {
      cropOverlayX1.value = updatedCropOverlayX1;
      cropOverlayY2.value = updatedCropOverlayY2;
    }

    if (overflowLeft) {
      cropOverlayX1.value = cropOverlayBounds.left;
    }

    if (overflowTop) {
      cropOverlayY2.value = cropOverlayY1.value + minHeight;
    }

    if (overflowRight) {
      cropOverlayX1.value = cropOverlayX2.value - minWidth;
    }

    if (overflowBottom) {
      cropOverlayY2.value = cropOverlayBounds.bottom;
    }

    syncCropOverlayWidthHeight();
  }

  void dragBottomRightHandle(double dx, double dy) {
    double updatedCropOverlayX2 = cropOverlayX2.value + dx;
    double updatedCropOverlayY2 = cropOverlayY2.value + dy;

    double updatedCropOverlayWidth = updatedCropOverlayX2 - cropOverlayX1.value;
    double updatedCropOverlayHeight =
        updatedCropOverlayY2 - cropOverlayY1.value;

    bool insideBounds = cropOverlayBounds
        .contains(Offset(updatedCropOverlayX2, updatedCropOverlayY2));

    bool overflowLeft = updatedCropOverlayWidth < minWidth;
    bool overflowTop = updatedCropOverlayHeight < minHeight;
    bool overflowRight = updatedCropOverlayX2 > cropOverlayBounds.right;
    bool overflowBottom = updatedCropOverlayY2 > cropOverlayBounds.bottom;

    if (insideBounds) {
      cropOverlayX2.value = updatedCropOverlayX2;
      cropOverlayY2.value = updatedCropOverlayY2;
    }

    if (overflowLeft) {
      cropOverlayX2.value = cropOverlayX1.value + minWidth;
    }

    if (overflowTop) {
      cropOverlayY2.value = cropOverlayY1.value + minHeight;
    }

    if (overflowRight) {
      cropOverlayX2.value = cropOverlayBounds.right;
    }

    if (overflowBottom) {
      cropOverlayY2.value = cropOverlayBounds.bottom;
    }

    syncCropOverlayWidthHeight();
  }

  void dragCenterLeftHandle(double dx) {
    double updatedCropOverlayX1 = cropOverlayX1.value + dx;

    double updatedCropOverlayWidth = cropOverlayX2.value - updatedCropOverlayX1;

    bool insideBounds =
        cropOverlayBounds.contains(Offset(updatedCropOverlayX1, 0));

    bool overflowLeft = updatedCropOverlayX1 < cropOverlayBounds.left;
    bool overflowRight = updatedCropOverlayWidth < minWidth;

    if (insideBounds) {
      cropOverlayX1.value = updatedCropOverlayX1;
    }

    if (overflowLeft) {
      cropOverlayX1.value = cropOverlayBounds.left;
    }

    if (overflowRight) {
      cropOverlayX1.value = cropOverlayX2.value - minWidth;
    }

    syncCropOverlayWidthHeight();
  }

  void dragCenterTopHandle(double dy) {
    double updatedCropOverlayY1 = cropOverlayY1.value + dy;

    double updatedCropOverlayHeight =
        cropOverlayY2.value - updatedCropOverlayY1;

    bool insideBounds =
        cropOverlayBounds.contains(Offset(0, updatedCropOverlayY1));

    bool overflowTop = updatedCropOverlayY1 < cropOverlayBounds.top;
    bool overflowBottom = updatedCropOverlayHeight < minHeight;

    if (insideBounds) {
      cropOverlayY1.value = updatedCropOverlayY1;
    }

    if (overflowTop) {
      cropOverlayY1.value = cropOverlayBounds.top;
    }

    if (overflowBottom) {
      cropOverlayY1.value = cropOverlayY2.value - minHeight;
    }

    syncCropOverlayWidthHeight();
  }

  void dragCenterRightHandle(double dx) {
    double updatedCropOverlayX2 = cropOverlayX2.value + dx;

    double updatedCropOverlayWidth = updatedCropOverlayX2 - cropOverlayX1.value;

    bool insideBounds =
        cropOverlayBounds.contains(Offset(updatedCropOverlayX2, 0));

    bool overflowLeft = updatedCropOverlayWidth < minWidth;
    bool overflowRight = updatedCropOverlayX2 > cropOverlayBounds.right;

    if (insideBounds) {
      cropOverlayX2.value = updatedCropOverlayX2;
    }

    if (overflowLeft) {
      cropOverlayX2.value = cropOverlayX1.value + minWidth;
    }

    if (overflowRight) {
      cropOverlayX2.value = cropOverlayBounds.right;
    }

    syncCropOverlayWidthHeight();
  }

  void dragCenterBottomHandle(double dy) {
    double updatedCropOverlayY2 = cropOverlayY2.value + dy;

    double updatedCropOverlayHeight =
        updatedCropOverlayY2 - cropOverlayY1.value;

    bool insideBounds =
        cropOverlayBounds.contains(Offset(0, updatedCropOverlayY2));

    bool overflowTop = updatedCropOverlayHeight < minHeight;
    bool overflowBottom = updatedCropOverlayY2 > cropOverlayBounds.bottom;

    if (insideBounds) {
      cropOverlayY2.value = updatedCropOverlayY2;
    }

    if (overflowTop) {
      cropOverlayY2.value = cropOverlayY1.value + minHeight;
    }

    if (overflowBottom) {
      cropOverlayY2.value = cropOverlayBounds.bottom;
    }

    syncCropOverlayWidthHeight();
  }

  void showGrid() {
    cropOverlayGridOpacity.value = 1;
  }

  void hideGrid() {
    cropOverlayGridOpacity.value = 0;
  }

  double getShadePositionLeft(ShadePosition shadePosition) {
    switch (shadePosition) {
      case ShadePosition.TOP_LEFT:
        return 0;
      case ShadePosition.TOP_RIGHT:
        return cropOverlayX2.value;
      case ShadePosition.BOTTOM_LEFT:
        return 0;
      case ShadePosition.BOTTOM_RIGHT:
        return cropOverlayX2.value;
      case ShadePosition.CENTER_LEFT:
        return 0;
      case ShadePosition.CENTER_TOP:
        return cropOverlayX1.value;
      case ShadePosition.CENTER_RIGHT:
        return cropOverlayX2.value;
      case ShadePosition.CENTER_BOTTOM:
        return cropOverlayX1.value;
      default:
        return 0;
    }
  }

  double getShadePositionTop(ShadePosition shadePosition) {
    switch (shadePosition) {
      case ShadePosition.TOP_LEFT:
        return 0;
      case ShadePosition.TOP_RIGHT:
        return 0;
      case ShadePosition.BOTTOM_LEFT:
        return cropOverlayY2.value;
      case ShadePosition.BOTTOM_RIGHT:
        return cropOverlayY2.value;
      case ShadePosition.CENTER_LEFT:
        return cropOverlayY1.value;
      case ShadePosition.CENTER_TOP:
        return 0;
      case ShadePosition.CENTER_RIGHT:
        return cropOverlayY1.value;
      case ShadePosition.CENTER_BOTTOM:
        return cropOverlayY2.value;
      default:
        return 0;
    }
  }

  double getShadeWidth(ShadePosition shadePosition) {
    switch (shadePosition) {
      case ShadePosition.TOP_LEFT:
        return cropOverlayX1.value;
      case ShadePosition.TOP_RIGHT:
        return cropOverlayBounds.width - cropOverlayX2.value;
      case ShadePosition.BOTTOM_LEFT:
        return cropOverlayX1.value;
      case ShadePosition.BOTTOM_RIGHT:
        return cropOverlayBounds.width - cropOverlayX2.value;
      case ShadePosition.CENTER_LEFT:
        return cropOverlayX1.value;
      case ShadePosition.CENTER_TOP:
        return cropOverlayWidth.value;
      case ShadePosition.CENTER_RIGHT:
        return cropOverlayBounds.width - cropOverlayX2.value;
      case ShadePosition.CENTER_BOTTOM:
        return cropOverlayWidth.value;
      default:
        return 0;
    }
  }

  double getShadeHeight(ShadePosition shadePosition) {
    switch (shadePosition) {
      case ShadePosition.TOP_LEFT:
        return cropOverlayY1.value;
      case ShadePosition.TOP_RIGHT:
        return cropOverlayY1.value;
      case ShadePosition.BOTTOM_LEFT:
        return cropOverlayBounds.width - cropOverlayY2.value;
      case ShadePosition.BOTTOM_RIGHT:
        return cropOverlayBounds.width - cropOverlayY2.value;
      case ShadePosition.CENTER_LEFT:
        return cropOverlayHeight.value;
      case ShadePosition.CENTER_TOP:
        return cropOverlayY1.value;
      case ShadePosition.CENTER_RIGHT:
        return cropOverlayHeight.value;
      case ShadePosition.CENTER_BOTTOM:
        return cropOverlayBounds.width - cropOverlayY2.value;
      default:
        return 0;
    }
  }
}

enum HandlePosition {
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
  CENTER_LEFT,
  CENTER_TOP,
  CENTER_RIGHT,
  CENTER_BOTTOM
}

enum ShadePosition {
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
  CENTER_LEFT,
  CENTER_TOP,
  CENTER_RIGHT,
  CENTER_BOTTOM
}
