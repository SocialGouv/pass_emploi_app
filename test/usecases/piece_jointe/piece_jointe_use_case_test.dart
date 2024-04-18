import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/usecases/piece_jointe/piece_jointe_use_case.dart';
import 'package:pass_emploi_app/utils/compress_image.dart';

void main() {
  group('PieceJointeUseCase', () {
    late _MockChatRepository chatRepository;
    late _MockPieceJointeRepository pieceJointeRepository;
    late _MockImageCompressor imageCompressor;

    late PieceJointeUseCase useCase;

    setUp(() {
      chatRepository = _MockChatRepository();
      pieceJointeRepository = _MockPieceJointeRepository();
      imageCompressor = _MockImageCompressor();

      useCase = PieceJointeUseCase(chatRepository, pieceJointeRepository, imageCompressor);
    });

    setUpAll(() {
      registerFallbackValue(_dummyPieceJointe);
    });

    test('should return false when image compression fails', () async {
      // Given
      chatRepository.onSuccess();
      pieceJointeRepository.onSuccess();
      imageCompressor.onFailure();

      // When
      final result = await useCase.sendPieceJointe("userId", _mockMessage(), "imagePath");

      // Then
      expect(result, false);
    });

    test('should return false when post piece jointe fails', () async {
      // Given
      chatRepository.onSuccess();
      pieceJointeRepository.onFailure();
      imageCompressor.onSuccess();

      // When
      final result = await useCase.sendPieceJointe("userId", _mockMessage(), "imagePath");

      // Then
      expect(result, false);
    });

    test('should return false when send message fails', () async {
      // Given
      chatRepository.onFailure();
      pieceJointeRepository.onSuccess();
      imageCompressor.onSuccess();

      // When
      final result = await useCase.sendPieceJointe("userId", _mockMessage(), "imagePath");

      // Then
      expect(result, false);
    });

    test('should return true otherwise', () async {
      // Given
      chatRepository.onSuccess();
      pieceJointeRepository.onSuccess();
      imageCompressor.onSuccess();

      // When
      final result = await useCase.sendPieceJointe("userId", _mockMessage(), "imagePath");

      // Then
      expect(result, true);
    });
  });
}

class _MockChatRepository extends Mock implements ChatRepository {
  void onSuccess() => when(() => sendPieceJointeMessage(any(), any(), any())).thenAnswer((_) async => true);

  void onFailure() => when(() => sendPieceJointeMessage(any(), any(), any())).thenAnswer((_) async => false);
}

class _MockPieceJointeRepository extends Mock implements PieceJointeRepository {
  void onSuccess() => when(() => postPieceJointe(
        fileName: any(named: "fileName"),
        filePath: any(named: "filePath"),
        messageId: any(named: "messageId"),
        userId: any(named: "userId"),
      )).thenAnswer((_) async => _dummyPieceJointe);

  void onFailure() => when(() => postPieceJointe(
        fileName: any(named: "fileName"),
        filePath: any(named: "filePath"),
        messageId: any(named: "messageId"),
        userId: any(named: "userId"),
      )).thenAnswer((_) async => null);
}

class _MockImageCompressor extends Mock implements ImageCompressor {
  void onSuccess() => when(() => compressImage(any())).thenAnswer((_) async => ("fileName", "newPath"));

  void onFailure() => when(() => compressImage(any())).thenAnswer((_) async => (null, null));
}

Message _mockMessage([String id = '1']) {
  return Message(
    id: "uid",
    content: "content $id",
    creationDate: DateTime.utc(2022, 1, 1),
    sentBy: Sender.jeune,
    type: MessageType.message,
    sendingStatus: MessageSendingStatus.sent,
    contentStatus: MessageContentStatus.content,
    pieceJointes: [],
  );
}

final PieceJointe _dummyPieceJointe = PieceJointe("id", "nom");
