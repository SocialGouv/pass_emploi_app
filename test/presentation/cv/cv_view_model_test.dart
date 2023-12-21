import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/cv/cv_actions.dart';
import 'package:pass_emploi_app/presentation/cv/cv_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('CvViewModel', () {
    group("display state", (() {
      test('should be loading when CvListPage is loading', () {
        // Given
        final store = givenState().loggedInPoleEmploiUser().withCvLoading().store();

        // When
        final viewModel = CvViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.chargement);
      });

      test('should be empty when CvListPage is success and there is no CV', () {
        // Given
        final store = givenState().loggedInPoleEmploiUser().withCvEmptySuccess().store();

        // When
        final viewModel = CvViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.vide);
      });

      test('should be content when CvListPage is success', () {
        // Given
        final store = givenState().loggedInPoleEmploiUser().withCvSuccess().store();

        // When
        final viewModel = CvViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.contenu);
      });

      test('should be failure when CvListPage is failure', () {
        // Given
        final store = givenState().loggedInPoleEmploiUser().withCvFailure().store();

        // When
        final viewModel = CvViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.erreur);
      });
    }));

    group('downloadStatus', () {
      test('should display nothing when state is not success', () {
        // Given
        final store = givenState().withCvLoading().store();

        // When
        final viewModel = CvViewModel.create(store);

        // Then
        expect(viewModel.downloadStatus(mockCvPoleEmploi().url), DisplayState.contenu);
      });

      test('should display loading when status is loading', () {
        // Given
        final store = givenState().withCvDownloadInProgress().store();

        // When
        final viewModel = CvViewModel.create(store);

        // Then
        expect(viewModel.downloadStatus(mockCvPoleEmploi().url), DisplayState.chargement);
      });

      test('should display nothing when status is success', () {
        // Given
        final store = givenState().withCvDownloadSuccess().store();

        // When
        final viewModel = CvViewModel.create(store);

        // Then
        expect(viewModel.downloadStatus(mockCvPoleEmploi().url), DisplayState.contenu);
      });

      test('should display nothing when status is failure', () {
        // Given
        final store = givenState().withCvDownloadFailure().store();

        // When
        final viewModel = CvViewModel.create(store);

        // Then
        expect(viewModel.downloadStatus(mockCvPoleEmploi().url), DisplayState.contenu);
      });
    });

    test('should have all CVs', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().withCvSuccess().store();

      // When
      final viewModel = CvViewModel.create(store);

      // Then
      expect(viewModel.cvList, mockCvPoleEmploiList());
    });

    test('should retry', () {
      // Given
      final store = StoreSpy();
      final viewModel = CvViewModel.create(store);

      // When
      viewModel.retry();

      // Then
      expect(store.dispatchedAction, isA<CvRequestAction>());
    });

    test('should download cv', () {
      // Given
      final cv = mockCvPoleEmploi();
      final store = StoreSpy();
      final viewModel = CvViewModel.create(store);

      // When
      viewModel.onDownload(cv);

      // Then
      expect(store.dispatchedAction, isA<CvDownloadRequestAction>());
    });

    test('should display api pe ko message', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().withCvSuccess().store();

      // When
      final viewModel = CvViewModel.create(store);

      // Then
      expect(viewModel.apiPeKo, false);
    });
  });
}
