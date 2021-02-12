import 'dart:typed_data';
import 'package:get/get.dart';
import 'crop_overlay_controller.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class CropController extends GetxController {
  final CropOverlayController cropOverlayController =
      Get.put(CropOverlayController());

  String imageURL;
  Uint8List imageData = Uint8List(0);
  Rx<Uint8List> croppedImageData = Uint8List(0).obs;

  img.Image image;
  double imageAspectRatio;
  img.Image imageCanvas;

  @override
  void onReady() {
    super.onReady();

    initializeImage();
  }

  void initializeImage() async {
    // Get bytes from image URL.
    imageData = await urlToBytes(imageURL);

    // Create image from bytes.
    image = img.decodeImage(imageData);

    // Calculate image aspect ratio.
    imageAspectRatio = image.width / image.height;

    int boundsWidth = cropOverlayController.cropOverlayBounds.width.toInt();
    int boundsHeight = cropOverlayController.cropOverlayBounds.height.toInt();

    // Create image canvas of dimensions in sync with layout created by user.
    imageCanvas = img.Image(boundsWidth, boundsHeight);

    // Resize image according to the relation between overlay dimensions.
    if (boundsWidth > boundsHeight) {
      image = img.copyResize(image,
          width: (boundsHeight * imageAspectRatio).toInt(),
          height: boundsHeight);
    } else if (boundsWidth <= boundsHeight) {
      image = img.copyResize(image,
          width: boundsWidth, height: (boundsWidth ~/ imageAspectRatio));
    }

    // Copy image at the center of image canvas.
    imageCanvas = img.copyInto(imageCanvas, image,
        dstX: ((imageCanvas.width - image.width) ~/ 2).toInt(),
        dstY: ((imageCanvas.height - image.height) ~/ 2).toInt());
  }

  Future<Uint8List> urlToBytes(String url) async {
    http.Response response = await http.get(url);
    Uint8List bytes = response.bodyBytes;

    return bytes;
  }

  // Crops image and returns bytes cropped image bytes.
  Uint8List cropImage() {
    img.Image croppedImage = img.copyCrop(
        imageCanvas,
        cropOverlayController.cropOverlayX1.value.toInt(),
        cropOverlayController.cropOverlayY1.value.toInt(),
        cropOverlayController.cropOverlayWidth.value.toInt(),
        cropOverlayController.cropOverlayHeight.value.toInt());

    croppedImageData.value = img.encodePng(croppedImage);

    return croppedImageData.value;
  }
}
