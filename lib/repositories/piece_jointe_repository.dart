import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:path_provider/path_provider.dart';

class PieceJointeRepository {
  final Dio _httpClient;
  final PieceJointeSaver _pieceJointeSaver;
  final Crashlytics? _crashlytics;

  PieceJointeRepository(this._httpClient, this._pieceJointeSaver, [this._crashlytics]);

  Future<String?> downloadFromId({required String fileId, required String fileName}) async {
    final url = "/fichiers/$fileId";
    try {
      final response = await _httpClient.get(url, options: Options(responseType: ResponseType.bytes));
      return await _pieceJointeSaver.saveFile(fileName: fileName, fileId: fileId, response: response);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
      if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
        return Strings.fileNotAvailableError;
      }
    }
    return null;
  }

  Future<String?> downloadFromUrl({
    required String attachmentUrl,
    required String fileId,
    required String fileName,
  }) async {
    try {
      final response = await _httpClient.get(attachmentUrl, options: Options(responseType: ResponseType.bytes));
      return await _pieceJointeSaver.saveFile(fileName: fileName, fileId: fileId, response: response);
    } catch (e, stack) {
      _crashlytics?.recordCvmException(e, stack);
      if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
        return Strings.fileNotAvailableError;
      }
    }
    return null;
  }
}

abstract class PieceJointeSaver {
  Future<String> saveFile({required String fileName, required String fileId, required Response<dynamic> response});
}

class PieceJointeFileSaver implements PieceJointeSaver {
  final String _pieceJointesFolderPath = "chat/attached_files";

  @override
  Future<String> saveFile(
      {required String fileName, required String fileId, required Response<dynamic> response}) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$_pieceJointesFolderPath/$fileId/$fileName').create(recursive: true);
    await file.writeAsBytes(response.data as List<int>);
    return file.path;
  }
}
