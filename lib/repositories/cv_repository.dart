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
      final response = await _httpClient.get(url, options: Options(responseType: ResponseType.bytes));
      await _saveFile(fileName: fileName, url: url, response: response);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<String> _saveFile({required String fileName, required String url, required Response<dynamic> response}) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$_cvFolderPath/${url.hashCode}/$fileName').create(recursive: true);
    await file.writeAsBytes(response.data as List<int>);
    return file.path;
  }
}
