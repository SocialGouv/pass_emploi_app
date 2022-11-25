import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/chat_partage_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  group('when sharing an event', () {
    test('should have corresponding titles', () {
      // Given
      final store = givenState().succeedEventList([mockRendezvous(id: "id-1")]).store();

      // When
      final viewModel = ChatPartagePageViewModel.fromSource(store, ChatPartageEventSource("id-1"));

      // Then
      expect(viewModel.pageTitle, "Partage d’événement");
      expect(viewModel.willShareTitle, "Ce que vous souhaitez partager");
      expect(viewModel.defaultMessage, "");
      expect(viewModel.information, "L’événement sera partagé à votre conseiller dans la messagerie");
      expect(viewModel.shareButtonTitle, "Partager à mon conseiller");
      expect(viewModel.snackbarSuccessText,
          "L’événement a été partagée à votre conseiller sur la messagerie de l’application");
      expect(viewModel.snackbarSuccessTracking, "events/detail?partage-conseiller=true");
    });

    test('should partager event', () {
      // Given
      final rdv = mockRendezvous(
        id: "id-1",
        title: "Fête foraine",
        date: DateTime(2022),
        type: RendezvousType(RendezvousTypeCode.ATELIER, 'Att'),
      );
      final store = givenState().succeedEventList([rdv]).spyStore();
      final viewModel = ChatPartagePageViewModel.fromSource(store, ChatPartageEventSource("id-1"));

      // When
      viewModel.onShare("Regardes ça");

      // Then
      expect(
        store.dispatchedAction,
        ChatPartagerEventAction(
          EventPartage(
            id: "id-1",
            type: RendezvousType(RendezvousTypeCode.ATELIER, 'Att'),
            titre: "Fête foraine",
            date: DateTime(2022),
            message: "Regardes ça",
          ),
        ),
      );
    });
  });

  group('when sharing an offer', () {
    test('should have titles corresponding for alternance', () {
      // Given
      final store = givenState().offreEmploiDetailsSuccess().store();

      // When
      final viewModel = ChatPartagePageViewModel.fromSource(store, ChatPartageOffreEmploiSource(OffreType.alternance));

      // Then
      expect(viewModel.pageTitle, "Partage de l’offre d’alternance");
      expect(viewModel.willShareTitle, "L’offre que vous souhaitez partager");
      expect(viewModel.defaultMessage, "Bonjour, je vous partage une offre d’emploi afin d’avoir votre avis");
      expect(viewModel.information, "L’offre d’emploi sera partagée à votre conseiller dans la messagerie");
      expect(viewModel.shareButtonTitle, "Partager l’offre d’alternance");
      expect(viewModel.snackbarSuccessText,
          "L’offre d’emploi a été partagée à votre conseiller sur la messagerie de l’application");
      expect(viewModel.snackbarSuccessTracking, "/recherche/emploi/detail?partage-conseiller=true");
    });

    test('should have titles corresponding for emploi', () {
      // Given
      final store = givenState().offreEmploiDetailsSuccess().store();

      // When
      final viewModel = ChatPartagePageViewModel.fromSource(store, ChatPartageOffreEmploiSource(OffreType.emploi));

      // Then
      expect(viewModel.pageTitle, "Partage de l’offre d’emploi");
      expect(viewModel.willShareTitle, "L’offre que vous souhaitez partager");
      expect(viewModel.defaultMessage, "Bonjour, je vous partage une offre d’emploi afin d’avoir votre avis");
      expect(viewModel.information, "L’offre d’emploi sera partagée à votre conseiller dans la messagerie");
      expect(viewModel.shareButtonTitle, "Partager l’offre d’emploi");
      expect(viewModel.snackbarSuccessText,
          "L’offre d’emploi a été partagée à votre conseiller sur la messagerie de l’application");
      expect(viewModel.snackbarSuccessTracking, "/recherche/emploi/detail?partage-conseiller=true");
    });

    test('should throw error on failure', () {
      final store = givenState().store();
      expect(
        () => ChatPartagePageViewModel.fromSource(store, ChatPartageOffreEmploiSource(OffreType.emploi)),
        throwsA(isA<Exception>()),
      );
    });

    test('should display shareable title', () {
      // Given
      final store = givenState().offreEmploiDetailsSuccess().store();

      // When
      final viewModel = ChatPartagePageViewModel.fromSource(store, ChatPartageOffreEmploiSource(OffreType.emploi));

      // Then
      expect(viewModel.shareableTitle, "Technicien / Technicienne d'installation de réseaux câblés  (H/F)");
    });

    test('should partager offre emploi', () {
      // Given
      final store = givenState().offreEmploiDetailsSuccess().spyStore();
      final viewModel = ChatPartagePageViewModel.fromSource(store, ChatPartageOffreEmploiSource(OffreType.emploi));

      // When
      viewModel.onShare("Regardes ça");

      // Then
      expect(store.dispatchedAction, isA<ChatPartagerOffreAction>());
      expect(
        (store.dispatchedAction as ChatPartagerOffreAction).offre,
        OffrePartagee(
          id: "123TZKB",
          titre: "Technicien / Technicienne d'installation de réseaux câblés  (H/F)",
          url: "https://candidat.pole-emploi.fr/offres/recherche/detail/123TZKB",
          message: "Regardes ça",
          type: OffreType.emploi,
        ),
      );
    });
  });

  group('snackbar', () {
    group('should display snackbar', () {
      void assertSnackBarDisplayState(ChatPartageState state, DisplayState expected) {
        test('when $expected', () {
          // Given
          final store = givenState().offreEmploiDetailsSuccess().copyWith(chatPartageState: state).store();

          // When
          final viewModel = ChatPartagePageViewModel.fromSource(store, ChatPartageOffreEmploiSource(OffreType.emploi));

          // Then
          expect(viewModel.snackbarState, expected);
        });
      }

      assertSnackBarDisplayState(ChatPartageState.notInitialized, DisplayState.EMPTY);
      assertSnackBarDisplayState(ChatPartageState.loading, DisplayState.LOADING);
      assertSnackBarDisplayState(ChatPartageState.success, DisplayState.CONTENT);
      assertSnackBarDisplayState(ChatPartageState.failure, DisplayState.FAILURE);
    });

    test('should reset snackbar', () {
      // Given
      final store = givenState().offreEmploiDetailsSuccess().spyStore();
      final viewModel = ChatPartagePageViewModel.fromSource(store, ChatPartageOffreEmploiSource(OffreType.emploi));

      // When
      viewModel.snackbarDisplayed();

      // Then
      expect(store.dispatchedAction, isA<ChatPartageResetAction>());
    });
  });
}
