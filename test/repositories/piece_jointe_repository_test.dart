import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/ui/strings.dart';

import '../doubles/mocks.dart';
import '../dsl/sut_dio_repository.dart';
import '../utils/expects.dart';

void main() {
  final saverMock = MockPieceJointeSaver();
  final sut = DioRepositorySut<PieceJointeRepository>();
  final file = File('path');
  sut.givenRepository((client) => PieceJointeRepository(client, saverMock));

  setUp(() async {
    reset(saverMock);
    saverMock.mockSaveFile();
    await file.create();
  });

  tearDown(() async {
    await file.delete();
  });

  group("postPieceJointe", () {
    sut.when(
      (repository) => repository.postPieceJointe(
        fileName: 'fileName',
        filePath: file.path,
        messageId: 'messageId',
        userId: 'userId',
      ),
    );

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: 'piece_jointe.json');

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.post,
          url: "/fichiers",
          options: Options(contentType: 'multipart/form-data'),
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<PieceJointe?>((result) => expect(
            result,
            PieceJointe(
              "id-1",
              "nom-1",
              PieceJointeAnalyseStatut.enCours,
            )));
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(500);

      test('response should be null', () async => await sut.expectNullResult());
    });
  });

  group("downloadFromId", () {
    sut.when(
      (repository) => repository.downloadFromId(fileId: "fileId", fileName: "fileName"),
    );

    group('when response is valid', () {
      final responseBytes = [117, 343];
      sut.givenBytesResponse(responseBytes);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: "/fichiers/fileId",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<String?>((path) => expect(path, "saved_path"));
      });

      test('file should be saved', () async {
        await sut.expectResult((_) {
          final captures = verify(() =>
                  saverMock.saveFile(fileName: "fileName", fileId: "fileId", response: captureAny(named: "response")))
              .captured;
          expect(captures.length, 1);
          expectTypeThen<Response<dynamic>>(captures[0], (capturedResponse) {
            expect(capturedResponse.data, responseBytes);
          });
        });
      });
    });

    group('when response is not found', () {
      sut.givenResponseCode(410);

      test('response should be path not found', () async {
        await sut.expectResult<String?>((path) => expect(path, Strings.fileNotAvailableError));
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(500);

      test('response should be null', () async {
        await sut.expectNullResult();
      });
    });
  });
}
