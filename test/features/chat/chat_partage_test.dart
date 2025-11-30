import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/chat/offre_partagee.dart';
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  late MockEvenementEngagementRepository evenementEngagementRepository;
  final miloUser = mockUser(loginMode: LoginMode.MILO);

  setUp(() {
    evenementEngagementRepository = MockEvenementEngagementRepository();
    registerFallbackValue(miloUser);
    registerFallbackValue(EvenementEngagement.ANIMATION_COLLECTIVE_PARTAGEE);
    when(() => evenementEngagementRepository.send(user: any(named: 'user'), event: any(named: "event")))
        .thenAnswer((_) async => true);
  });

  group('Partage with Firebase chat', () {
    final sut = StoreSut();
    late _MockChatRepository mockChatRepository;

    setUp(() {
      mockChatRepository = _MockChatRepository();
      sut.givenStore = givenState() //
          .copyWith(loginState: LoginSuccessState(miloUser))
          .store(
            (f) => {
              f.chatRepository = mockChatRepository,
              f.evenementEngagementRepository = evenementEngagementRepository,
            },
          );
    });

    group('partage event action', () {
      sut.whenDispatchingAction(() => ChatPartagerEventAction(dummyEventPartage()));

      test('should dispatch loading then succeed when an event is successfully partagé', () async {
        // Given
        mockChatRepository.onSendEventPartageSuccess(dummyEventPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageSuccessState>((state) => state.chatPartageState),
        ]);
      });

      test('should dispatch loading then failure when an event fails to be shared', () {
        // Given
        mockChatRepository.onSendEventPartageFailure(dummyEventPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageFailureState>((state) => state.chatPartageState),
        ]);
      });

      test('should track when event is successfully partagé', () async {
        // Given
        mockChatRepository.onSendEventPartageSuccess(dummyEventPartage());

        // Then
        sut.then(
          () => verify(
            () => evenementEngagementRepository.send(
              user: miloUser,
              event: EvenementEngagement.ANIMATION_COLLECTIVE_PARTAGEE,
            ),
          ).called(1),
        );
      });
    });

    group('partage offre emploi action', () {
      sut.whenDispatchingAction(() => ChatPartagerOffreAction(dummyOffrePartagee()));

      test('should dispatch loading then succeed when an offre is successfully partagée', () async {
        // Given
        mockChatRepository.onPartageOffreEmploiSucceeds(dummyOffrePartagee());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageSuccessState>((state) => state.chatPartageState),
        ]);
      });

      test('should dispatch loading then failure when an offre fails to be shared', () {
        // Given
        mockChatRepository.onPartageOffreEmploiFails(dummyOffrePartagee());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageFailureState>((state) => state.chatPartageState),
        ]);
      });

      test('should track when offre is successfully partagé', () async {
        // Given
        mockChatRepository.onPartageOffreEmploiSucceeds(dummyOffrePartagee());

        // Then
        sut.then(
          () => verify(
            () => evenementEngagementRepository.send(
              user: miloUser,
              event: EvenementEngagement.MESSAGE_OFFRE_PARTAGEE,
            ),
          ).called(1),
        );
      });
    });

    group('partage evenement emploi', () {
      sut.whenDispatchingAction(() => ChatPartagerEvenementEmploiAction(dummyEvenementEmploiPartage()));

      test('should dispatch loading then succeed action an evenement emploi is successfully partagé', () async {
        // Given
        mockChatRepository.onPartageEvenementEmploiSucceeds(dummyEvenementEmploiPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageSuccessState>((state) => state.chatPartageState),
        ]);
      });

      test('should dispatch loading then failure when an evenement emploi fails to be shared', () {
        // Given
        mockChatRepository.onPartageEvenementEmploiFails(dummyEvenementEmploiPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageFailureState>((state) => state.chatPartageState),
        ]);
      });

      test('should track when event is successfully partagé', () async {
        // Given
        mockChatRepository.onPartageEvenementEmploiSucceeds(dummyEvenementEmploiPartage());

        // Then
        sut.then(
          () => verify(
            () => evenementEngagementRepository.send(
              user: miloUser,
              event: EvenementEngagement.EVENEMENT_EXTERNE_PARTAGE,
            ),
          ).called(1),
        );
      });
    });

    group('partage session milo', () {
      sut.whenDispatchingAction(() => ChatPartagerSessionMiloAction(dummySessionMiloPartage()));

      test('should dispatch loading then succeed action a session milo is successfully partagé', () async {
        // Given
        mockChatRepository.onPartageSessionMiloSuccess(dummySessionMiloPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageSuccessState>((state) => state.chatPartageState),
        ]);
      });

      test('should dispatch loading then failure when a session milo fails to be shared', () {
        // Given
        mockChatRepository.onPartageSessionMiloFails(dummySessionMiloPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageFailureState>((state) => state.chatPartageState),
        ]);
      });

      test('should track when session milo is successfully partagé', () async {
        // Given
        mockChatRepository.onPartageSessionMiloSuccess(dummySessionMiloPartage());

        // Then
        sut.then(
          () => verify(
            () => evenementEngagementRepository.send(
              user: miloUser,
              event: EvenementEngagement.MESSAGE_SESSION_MILO_PARTAGE,
            ),
          ).called(1),
        );
      });
    });
  });
}

class _MockChatRepository extends Mock implements ChatRepository {
  void onSendEventPartageSuccess(EventPartage eventPartage) {
    when(() => sendEventPartage(any(), eventPartage)).thenAnswer((_) async => true);
  }

  void onSendEventPartageFailure(EventPartage eventPartage) {
    when(() => sendEventPartage(any(), eventPartage)).thenAnswer((_) async => false);
  }

  void onPartageOffreEmploiSucceeds(OffrePartagee offrePartagee) {
    when(() => sendOffrePartagee(any(), offrePartagee)).thenAnswer((_) async => true);
  }

  void onPartageOffreEmploiFails(OffrePartagee offrePartagee) {
    when(() => sendOffrePartagee(any(), offrePartagee)).thenAnswer((_) async => false);
  }

  void onPartageEvenementEmploiSucceeds(EvenementEmploiPartage evenementEmploiPartage) {
    when(() => sendEvenementEmploiPartage(any(), evenementEmploiPartage)).thenAnswer((_) async => true);
  }

  void onPartageEvenementEmploiFails(EvenementEmploiPartage evenementEmploiPartage) {
    when(() => sendEvenementEmploiPartage(any(), evenementEmploiPartage)).thenAnswer((_) async => false);
  }

  void onPartageSessionMiloSuccess(SessionMiloPartage sessionMiloPartage) {
    when(() => sendSessionMiloPartage(any(), sessionMiloPartage)).thenAnswer((_) async => true);
  }

  void onPartageSessionMiloFails(SessionMiloPartage sessionMiloPartage) {
    when(() => sendSessionMiloPartage(any(), sessionMiloPartage)).thenAnswer((_) async => false);
  }
}
