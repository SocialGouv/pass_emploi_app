import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/cv_pole_emploi.dart';
import 'package:path_provider/path_provider.dart';

class CvRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  CvRepository(this._httpClient, [this._crashlytics]);

  final String _cvFolderPath = "cv";

  Future<List<CvPoleEmploi>?> getCvs(String userId) async {
    final url = "/jeunes/$userId/pole-emploi/cv";
    try {
      final response = await _httpClient.get(url);
      final cvList = (response.data as List).map((e) => CvPoleEmploi.fromJson(e)).toList();
      return cvList;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<String?> download({required String url, required String fileName}) async {
    try {
      //TODO: client
      final dioClient = Dio();
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/$_cvFolderPath/${url.hashCode}/$fileName';
      await File(path).create(recursive: true);
      await dioClient.download(url, path);
      return path;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
