import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/chat/offre_partagee.dart';
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Partage with Firebase chat', () {
    final sut = StoreSut();
    late MockEvenementEngagementRepository evenementEngagementRepository;
    late _MockChatRepository mockChatRepository;

    setUp(() {
      evenementEngagementRepository = MockEvenementEngagementRepository();
      registerFallbackValue(EvenementEngagement.ANIMATION_COLLECTIVE_PARTAGEE);
      when(
        () => evenementEngagementRepository.send(
          userId: 'id',
          event: any(named: "event"),
          loginMode: LoginMode.MILO,
          brand: Brand.cej,
        ),
      ).thenAnswer((_) async => true);

      mockChatRepository = _MockChatRepository();
      sut.givenStore = givenState() //
          .loggedIn()
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
              userId: 'id',
              event: EvenementEngagement.ANIMATION_COLLECTIVE_PARTAGEE,
              loginMode: LoginMode.MILO,
              brand: Brand.cej,
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
              userId: 'id',
              event: EvenementEngagement.MESSAGE_OFFRE_PARTAGEE,
              loginMode: LoginMode.MILO,
              brand: Brand.cej,
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
              userId: 'id',
              event: EvenementEngagement.EVENEMENT_EXTERNE_PARTAGE,
              loginMode: LoginMode.MILO,
              brand: Brand.cej,
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
              userId: 'id',
              event: EvenementEngagement.MESSAGE_SESSION_MILO_PARTAGE,
              loginMode: LoginMode.MILO,
              brand: Brand.cej,
            ),
          ).called(1),
        );
      });
    });
  });

  group('Partage with CVM chat', () {
    final sut = StoreSut();
    late MockEvenementEngagementRepository evenementEngagementRepository;
    late MockCvmBridge cvmBridge;

    setUp(() {
      evenementEngagementRepository = MockEvenementEngagementRepository();
      registerFallbackValue(EvenementEngagement.ANIMATION_COLLECTIVE_PARTAGEE);
      when(
        () => evenementEngagementRepository.send(
          userId: 'id',
          event: any(named: "event"),
          loginMode: LoginMode.POLE_EMPLOI,
          brand: Brand.cej,
        ),
      ).thenAnswer((_) async => true);

      cvmBridge = MockCvmBridge();
      sut.givenStore = givenState() //
          .loggedInPoleEmploiUser()
          .withCvmMessage()
          .store(
            (f) => {
              f.cvmBridge = cvmBridge,
              f.evenementEngagementRepository = evenementEngagementRepository,
            },
          );
    });

    group('partage event action', () {
      sut.whenDispatchingAction(() => ChatPartagerEventAction(dummyEventPartage()));

      test('should dispatch loading then succeed when an event is successfully partagé', () async {
        // Given
        when(() => cvmBridge.sendMessage(any())).thenAnswer((_) async => true);

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageSuccessState>((state) => state.chatPartageState),
        ]);

        final evenement = dummyEventPartage();
        final message = "${evenement.message}\n\n${evenement.titre} le ${evenement.date.toDayAndHour()}";
        verify(() => cvmBridge.sendMessage(message)).called(1);
      });

      test('should dispatch loading then failure when an event fails to be shared', () {
        // Given
        when(() => cvmBridge.sendMessage(any())).thenAnswer((_) async => false);

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageFailureState>((state) => state.chatPartageState),
        ]);
      });

      test('should track when event is successfully partagé', () async {
        // Given
        when(() => cvmBridge.sendMessage(any())).thenAnswer((_) async => true);

        // Then
        sut.then(
          () => verify(
            () => evenementEngagementRepository.send(
              userId: 'id',
              event: EvenementEngagement.ANIMATION_COLLECTIVE_PARTAGEE,
              loginMode: LoginMode.POLE_EMPLOI,
              brand: Brand.cej,
            ),
          ).called(1),
        );
      });
    });

    group('partage offre emploi action', () {
      sut.whenDispatchingAction(() => ChatPartagerOffreAction(dummyOffrePartagee()));

      test('should dispatch loading then succeed when an offre is successfully partagée', () async {
        // Given
        when(() => cvmBridge.sendMessage(any())).thenAnswer((_) async => true);

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageSuccessState>((state) => state.chatPartageState),
        ]);

        final offre = dummyOffrePartagee();
        final message = "${offre.message}\n\n${offre.titre}\n↗ ${offre.url}";
        verify(() => cvmBridge.sendMessage(message)).called(1);
      });

      test('should dispatch loading then failure when an offre fails to be shared', () {
        // Given
        when(() => cvmBridge.sendMessage(any())).thenAnswer((_) async => false);

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageFailureState>((state) => state.chatPartageState),
        ]);
      });

      test('should track when offre is successfully partagé', () async {
        // Given
        when(() => cvmBridge.sendMessage(any())).thenAnswer((_) async => true);

        // Then
        sut.then(
          () => verify(
            () => evenementEngagementRepository.send(
              userId: 'id',
              event: EvenementEngagement.MESSAGE_OFFRE_PARTAGEE,
              loginMode: LoginMode.POLE_EMPLOI,
              brand: Brand.cej,
            ),
          ).called(1),
        );
      });
    });

    group('partage evenement emploi', () {
      sut.whenDispatchingAction(() => ChatPartagerEvenementEmploiAction(dummyEvenementEmploiPartage()));

      test('should dispatch loading then succeed action an evenement emploi is successfully partagé', () async {
        // Given
        when(() => cvmBridge.sendMessage(any())).thenAnswer((_) async => true);

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageSuccessState>((state) => state.chatPartageState),
        ]);

        final evenementEmploi = dummyEvenementEmploiPartage();
        final message = "${evenementEmploi.message}\n\n${evenementEmploi.titre}\n↗ ${evenementEmploi.url}";
        verify(() => cvmBridge.sendMessage(message)).called(1);
      });

      test('should dispatch loading then failure when an evenement emploi fails to be shared', () {
        // Given
        when(() => cvmBridge.sendMessage(any())).thenAnswer((_) async => false);

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageFailureState>((state) => state.chatPartageState),
        ]);
      });

      test('should track when evenement emploi is successfully partagé', () async {
        // Given
        when(() => cvmBridge.sendMessage(any())).thenAnswer((_) async => true);

        // Then
        sut.then(
          () => verify(
            () => evenementEngagementRepository.send(
              userId: 'id',
              event: EvenementEngagement.EVENEMENT_EXTERNE_PARTAGE,
              loginMode: LoginMode.POLE_EMPLOI,
              brand: Brand.cej,
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
