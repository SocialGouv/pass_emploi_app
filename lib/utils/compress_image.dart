import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class CompressImage {
  CompressImage();

  static const int maxImageMaxDimension = 1080;

  static Future<String?> compressImage(String filePath) async {
    final file = File(filePath);
    final imageBytes = await file.readAsBytes();
    final image = await decodeImageFromList(imageBytes);
    late final int minWidth;
    late final int minHeight;

    if (image.width > image.height) {
      minWidth = maxImageMaxDimension;
      minHeight = (image.height * maxImageMaxDimension / image.width).round();
    } else {
      minWidth = (image.width * maxImageMaxDimension / image.height).round();
      minHeight = maxImageMaxDimension;
    }

    final dir = await getTemporaryDirectory();
    final newPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png';

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      newPath,
      quality: 80,
      format: CompressFormat.png,
      minHeight: minHeight,
      minWidth: minWidth,
    );

    return compressedFile?.path;
  }
}
