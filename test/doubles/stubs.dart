import 'dart:async';

import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/models/page_demarches.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';

import 'dio_mock.dart';
import 'dummies.dart';
import 'fixtures.dart';
import 'mocks.dart';

class PageDemarcheRepositorySuccessStub extends PageDemarcheRepository {
  PageDemarcheRepositorySuccessStub() : super(DioMock());

  @override
  Future<PageDemarches?> getPageDemarches(String userId) async {
    return PageDemarches(
      demarches: [
        Demarche(
          id: "id",
          content: "content",
          status: DemarcheStatus.NOT_STARTED,
          endDate: DateTime(2022, 12, 23, 0, 0, 0),
          deletionDate: DateTime(2022, 12, 23, 0, 0, 0),
          createdByAdvisor: true,
          label: "label",
          possibleStatus: [],
          creationDate: DateTime(2022, 12, 23, 0, 0, 0),
          modifiedByAdvisor: false,
          sousTitre: "sous titre",
          titre: "titre",
          modificationDate: DateTime(2022, 12, 23, 0, 0, 0),
          attributs: [],
        ),
      ],
      dateDerniereMiseAJour: DateTime(2023, 1, 1),
    );
  }
}

class PageDemarcheRepositoryFailureStub extends PageDemarcheRepository {
  PageDemarcheRepositoryFailureStub() : super(DioMock());

  @override
  Future<PageDemarches?> getPageDemarches(String userId) async {
    return null;
  }
}

class ChatRepositoryStub extends ChatRepository {
  List<Message> _messages = [];
  ConseillerMessageInfo _info = ConseillerMessageInfo(null, null);

  ChatRepositoryStub() : super(DummyChatCrypto(), DummyCrashlytics(), ModeDemoRepository());

  void onMessageStreamReturns(List<Message> messages) => _messages = messages;

  void onChatStatusStreamReturns(ConseillerMessageInfo info) => _info = info;

  @override
  Stream<List<Message>> messagesStream(String userId) async* {
    yield _messages;
  }

  @override
  Stream<ConseillerMessageInfo> chatStatusStream(String userId) async* {
    yield _info;
  }

  @override
  Future<bool> sendOffrePartagee(String userId, OffrePartagee offrePartagee) async {
    return true;
  }
}

class ChatRepositoryMock extends ChatRepository {
  ChatRepositoryMock() : super(DummyChatCrypto(), DummyCrashlytics(), ModeDemoRepository());

  final _streamController = StreamController<List<Message>>();
  List<Message> oldMessagesRequested = [];
  int numberOfOldMessagesCalled = 0;

  @override
  int numberOfHistoryMessage = 20;

  @override
  Stream<List<Message>> messagesStream(String userId) async* {
    await for (final messages in _streamController.stream) {
      yield messages;
    }
  }

  @override
  Future<List<Message>> oldMessages(String userId, DateTime date) async {
    numberOfOldMessagesCalled++;
    return oldMessagesRequested;
  }

  void publishMessagesOnStream(List<Message> messages) {
    _streamController.add(messages);
  }
}

class SuppressionCompteRepositorySuccessStub extends SuppressionCompteRepository {
  SuppressionCompteRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool> deleteUser(String userId) async {
    return true;
  }
}

class SuppressionCompteRepositoryFailureStub extends SuppressionCompteRepository {
  SuppressionCompteRepositoryFailureStub() : super(DioMock());

  @override
  Future<bool> deleteUser(String userId) async {
    return false;
  }
}

class PieceJointeRepositorySuccessStub extends PieceJointeRepository {
  PieceJointeRepositorySuccessStub() : super(DioMock(), MockPieceJointeSaver());

  @override
  Future<String?> download({required String fileId, required String fileName}) async {
    return "$fileId-path";
  }
}

class PieceJointeRepositoryFailureStub extends PieceJointeRepository {
  PieceJointeRepositoryFailureStub() : super(DioMock(), MockPieceJointeSaver());

  @override
  Future<String?> download({required String fileId, required String fileName}) async {
    return null;
  }
}

class PieceJointeRepositoryUnavailableStub extends PieceJointeRepository {
  PieceJointeRepositoryUnavailableStub() : super(DioMock(), MockPieceJointeSaver());

  @override
  Future<String?> download({required String fileId, required String fileName}) async {
    return "ERROR: 404";
  }
}

class ActionCommentaireRepositorySuccessStub extends ActionCommentaireRepository {
  ActionCommentaireRepositorySuccessStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<List<Commentaire>?> getCommentaires(String actionId) async {
    return mockCommentaires();
  }
}

class ActionCommentaireRepositoryFailureStub extends ActionCommentaireRepository {
  ActionCommentaireRepositoryFailureStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<List<Commentaire>?> getCommentaires(String actionId) async {
    return null;
  }
}

class UpdateDemarcheRepositorySuccessStub extends UpdateDemarcheRepository {
  String? _userId;
  String? _actionId;
  DemarcheStatus? _status;
  DateTime? _fin;
  DateTime? _debut;

  UpdateDemarcheRepositorySuccessStub() : super(DioMock());

  void withArgsResolves(
    String userId,
    String actionId,
    DemarcheStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) {
    _userId = userId;
    _actionId = actionId;
    _status = status;
    _fin = dateFin;
    _debut = dateDebut;
  }

  @override
  Future<Demarche?> updateDemarche(
    String userId,
    String demarcheId,
    DemarcheStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) async {
    if (_userId == userId && _actionId == demarcheId && _status == status && _debut == dateDebut && _fin == dateFin) {
      return mockDemarche(id: demarcheId, status: status);
    }
    return null;
  }
}

class UpdateDemarcheRepositoryFailureStub extends UpdateDemarcheRepository {
  UpdateDemarcheRepositoryFailureStub() : super(DioMock());

  @override
  Future<Demarche?> updateDemarche(
    String userId,
    String demarcheId,
    DemarcheStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) async {
    return null;
  }
}
