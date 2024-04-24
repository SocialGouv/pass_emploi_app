import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:path_provider/path_provider.dart';

class PieceJointeRepository {
  final Dio _httpClient;
  final PieceJointeSaver _pieceJointeSaver;
  final Crashlytics? _crashlytics;

  PieceJointeRepository(this._httpClient, this._pieceJointeSaver, [this._crashlytics]);

  Future<PieceJointe?> postPieceJointe({
    required String fileName,
    required String filePath,
    required String messageId,
    required String userId,
  }) async {
    try {
      final MultipartFile fichier = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      );

      final FormData formData = FormData.fromMap({
        'fichier': fichier,
        'nom': fileName,
        'jeunesIds': [userId],
        'idMessage': messageId,
      });

      final result = await _httpClient.post(
        "/fichiers",
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return PieceJointe.fromJson(result.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack);
      return null;
    }
  }

  Future<String?> downloadFromId({required String fileId, required String fileName}) async {
    return downloadFromUrl(url: "/fichiers/$fileId", fileId: fileId, fileName: fileName);
  }

  Future<String?> downloadFromUrl({required String url, required String fileId, required String fileName}) async {
    try {
      final response = await _httpClient.get(url, options: Options(responseType: ResponseType.bytes));
      return await _pieceJointeSaver.saveFile(fileName: fileName, fileId: fileId, response: response);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
      if (e is DioException && e.response?.statusCode == HttpStatus.gone) {
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
