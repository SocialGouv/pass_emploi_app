import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/utils/compress_image.dart';

class PieceJointeUseCase {
  final ChatRepository _chatRepository;
  final PieceJointeRepository _pieceJointeRepository;
  final ImageCompressor _imageCompressor;

  PieceJointeUseCase(
    this._chatRepository,
    this._pieceJointeRepository,
    this._imageCompressor,
  );

  Future<bool> sendPieceJointe(String userId, Message message, String imagePath) async {
    final (fileName, newPath) = await _imageCompressor.compressImage(imagePath);
    if (fileName == null || newPath == null) return false;

    final pj = await _pieceJointeRepository.postPieceJointe(fileName: fileName, filePath: newPath, userId: userId);
    if (pj == null) return false;

    return await _chatRepository.sendPieceJointeMessage(userId, pj, message.id);
  }
}
