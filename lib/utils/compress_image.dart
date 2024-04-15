import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressor {
  ImageCompressor();

  static const int maxImageMaxDimension = 1080;
  static const int qualityPercentage = 80;

  Future<(String? fileName, String? filePath)> compressImage(String filePath) async {
    final file = File(filePath);
    final imageBytes = await file.readAsBytes();
    final image = await decodeImageFromList(imageBytes);
    final int minWidth;
    final int minHeight;

    if (image.width > image.height) {
      minWidth = maxImageMaxDimension;
      minHeight = (image.height * maxImageMaxDimension / image.width).round();
    } else {
      minWidth = (image.width * maxImageMaxDimension / image.height).round();
      minHeight = maxImageMaxDimension;
    }

    final dir = await getTemporaryDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.webp';
    final newPath = '${dir.path}/$fileName';

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      newPath,
      quality: qualityPercentage,
      format: CompressFormat.webp,
      minHeight: minHeight,
      minWidth: minWidth,
    );

    return (fileName, compressedFile?.path);
  }
}
