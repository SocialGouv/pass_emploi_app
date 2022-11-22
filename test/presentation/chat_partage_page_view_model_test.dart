import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/presentation/chat_partage_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  group('when sharing an offer', () {
    test('should throw error on failure', () {
      final store = givenState().store();
      expect(() => ChatPartagePageViewModel.sharingOffre(store), throwsA(isA<Exception>()));
    });

    test('should display title on success', () {
      // Given
      final store = givenState().offreEmploiDetailsSuccess().store();

      // When
      final viewModel = ChatPartagePageViewModel.sharingOffre(store);

      // Then
      expect(viewModel.shareableTitle, "Technicien / Technicienne d'installation de réseaux câblés  (H/F)");
    });

    test('should partager offre', () {
      // Given
      final store = givenState().offreEmploiDetailsSuccess().spyStore();
      final viewModel = ChatPartagePageViewModel.sharingOffre(store);

      // When
      viewModel.onShare("Regardes ça", OffreType.emploi);

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
          final viewModel = ChatPartagePageViewModel.sharingOffre(store);

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
      final viewModel = ChatPartagePageViewModel.sharingOffre(store);

      // When
      viewModel.snackbarDisplayed();

      // Then
      expect(store.dispatchedAction, isA<ChatPartageResetAction>());
    });
  });
}
