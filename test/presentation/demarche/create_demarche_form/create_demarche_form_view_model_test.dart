import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_display_state.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step3_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_du_referentiel_card_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/thematiques_demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';

void main() {
  late bool hasBeenNotified;

  setUp(() {
    hasBeenNotified = false;
  });

  void notify() => hasBeenNotified = true;

  group('CreateDemarcheFormViewModel', () {
    group('navigation', () {
      group('onNavigateBackward', () {
        test('should stay on step 1 when current step is step 1', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel(displayState: CreateDemarche2Step1())..addListener(notify);

          // When
          viewModel.onNavigateBackward();

          // Then
          expect(viewModel.displayState, isA<CreateDemarche2Step1>());
          expect(hasBeenNotified, true);
        });

        test('should go back to step 1 when current step is thematique step 2', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel(displayState: CreateDemarche2FromThematiqueStep2())
            ..addListener(notify);

          // When
          viewModel.onNavigateBackward();

          // Then
          expect(viewModel.displayState, isA<CreateDemarche2Step1>());
          expect(hasBeenNotified, true);
        });

        test('should go back to step 1 when current step is personnalisee step 2', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel(displayState: CreateDemarche2PersonnaliseeStep2())
            ..addListener(notify);

          // When
          viewModel.onNavigateBackward();

          // Then
          expect(viewModel.displayState, isA<CreateDemarche2Step1>());
          expect(hasBeenNotified, true);
        });

        test('should go back to thematique step 2 when current step is thematique step 3', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel(displayState: CreateDemarche2FromThematiqueStep3())
            ..addListener(notify);

          // When
          viewModel.onNavigateBackward();

          // Then
          expect(viewModel.displayState, isA<CreateDemarche2FromThematiqueStep2>());
          expect(hasBeenNotified, true);
        });

        test('should go back to personnalisee step 2 when current step is personnalisee step 3', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel(displayState: CreateDemarche2PersonnaliseeStep3())
            ..addListener(notify);

          // When
          viewModel.onNavigateBackward();

          // Then
          expect(viewModel.displayState, isA<CreateDemarche2PersonnaliseeStep2>());
          expect(hasBeenNotified, true);
        });

        test('should stay on submitted state when current step is submitted', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel(displayState: CreateDemarche2FromThematiqueSubmitted())
            ..addListener(notify);

          // When
          viewModel.onNavigateBackward();

          // Then
          expect(viewModel.displayState, isA<CreateDemarche2FromThematiqueSubmitted>());
          expect(hasBeenNotified, true);
        });
      });

      group('navigateToCreateCustomDemarche', () {
        test('should navigate to personnalisee step 2', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel()..addListener(notify);

          // When
          viewModel.navigateToCreateCustomDemarche();

          // Then
          expect(viewModel.displayState, isA<CreateDemarche2PersonnaliseeStep2>());
          expect(hasBeenNotified, true);
        });
      });

      group('navigateToCreateDemarchePersonnaliseeStep3', () {
        test('should navigate to personnalisee step 3', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel()..addListener(notify);

          // When
          viewModel.navigateToCreateDemarchePersonnaliseeStep3();

          // Then
          expect(viewModel.displayState, isA<CreateDemarche2PersonnaliseeStep3>());
          expect(hasBeenNotified, true);
        });
      });
    });

    group('value changed', () {
      group('descriptionChanged', () {
        test('should update description and notify listeners', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel()..addListener(notify);

          // When
          viewModel.descriptionChanged("new description");

          // Then
          expect(viewModel.personnaliseeStep2ViewModel.description, "new description");
          expect(hasBeenNotified, true);
        });
      });

      group('dateDemarchePersonnaliseeChanged', () {
        test('should update date and notify listeners', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel()..addListener(notify);
          final newDate = DateFromPicker(DateTime(2024));

          // When
          viewModel.dateDemarchePersonnaliseeChanged(newDate);

          // Then
          expect(viewModel.personnaliseeStep3ViewModel.dateSource, newDate);
          expect(hasBeenNotified, true);
        });
      });

      group('dateDemarcheThematiqueChanged', () {
        test('should update date and notify listeners', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel()..addListener(notify);
          final newDate = DateFromPicker(DateTime(2024));

          // When
          viewModel.dateDemarcheThematiqueChanged(newDate);

          // Then
          expect(viewModel.fromThematiqueStep3ViewModel.dateSource, newDate);
          expect(hasBeenNotified, true);
        });
      });

      group('commentChanged', () {
        test('should update comment and notify listeners', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel()..addListener(notify);
          final newComment = CommentTextItem(label: "label", code: "code");

          // When
          viewModel.commentChanged(newComment);

          // Then
          expect(viewModel.fromThematiqueStep3ViewModel.commentItem, newComment);
          expect(hasBeenNotified, true);
        });
      });

      group('thematiqueSelected', () {
        test('should update selected thematique and navigate to thematique step 2', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel()..addListener(notify);
          final thematique = ThematiqueDemarcheItem(id: "id", title: "title");

          // When
          viewModel.thematiqueSelected(thematique);

          // Then
          expect(viewModel.step1ViewModel.selectedThematique, thematique);
          expect(viewModel.displayState, isA<CreateDemarche2FromThematiqueStep2>());
          expect(hasBeenNotified, true);
        });
      });

      group('demarcheSelected', () {
        test('should update selected demarche and navigate to thematique step 3', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel()..addListener(notify);
          final demarche = DemarcheDuReferentielCardViewModel(
            idDemarche: "id",
            quoi: "quoi",
            pourquoi: "pourquoi",
          );

          // When
          viewModel.demarcheSelected(demarche);

          // Then
          expect(viewModel.thematiqueStep2ViewModel.selectedDemarcheVm, demarche);
          expect(viewModel.displayState, isA<CreateDemarche2FromThematiqueStep3>());
          expect(hasBeenNotified, true);
        });
      });
    });

    group('validation', () {
      group('isDescriptionValid', () {
        test('should return true when description is not empty', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel();
          viewModel.descriptionChanged("not empty");

          // When & Then
          expect(viewModel.isDescriptionValid, true);
        });

        test('should return false when description is empty', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel();
          viewModel.descriptionChanged("");

          // When & Then
          expect(viewModel.isDescriptionValid, false);
        });
      });

      group('isDemarchePersonnaliseeDateValid', () {
        test('should return true when date is valid', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel();
          viewModel.dateDemarchePersonnaliseeChanged(DateFromPicker(DateTime(2024)));

          // When & Then
          expect(viewModel.isDemarchePersonnaliseeDateValid, true);
        });

        test('should return false when date is invalid', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel();
          viewModel.dateDemarchePersonnaliseeChanged(DateNotInitialized());

          // When & Then
          expect(viewModel.isDemarchePersonnaliseeDateValid, false);
        });
      });
    });

    group('submission', () {
      group('submitDemarchePersonnalisee', () {
        test('should set state to personnalisee submitted', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel()..addListener(notify);

          // When
          viewModel.submitDemarchePersonnalisee();

          // Then
          expect(viewModel.displayState, isA<CreateDemarche2PersonnaliseeSubmitted>());
          expect(hasBeenNotified, true);
        });
      });

      group('submitDemarcheThematique', () {
        test('should set state to thematique submitted', () {
          // Given
          final viewModel = CreateDemarcheFormViewModel()..addListener(notify);

          // When
          viewModel.submitDemarcheThematique();

          // Then
          expect(viewModel.displayState, isA<CreateDemarche2FromThematiqueSubmitted>());
          expect(hasBeenNotified, true);
        });
      });
    });

    group('createDemarcheRequestAction', () {
      test('should create action with correct values', () {
        // Given
        final viewModel = CreateDemarcheFormViewModel();
        final demarche = DemarcheDuReferentielCardViewModel(
          idDemarche: "id",
          quoi: "test_quoi",
          pourquoi: "test_pourquoi",
          codeQuoi: "test_quoi",
          codePourquoi: "test_pourquoi",
        );
        final comment = CommentTextItem(label: "label", code: "test_code");
        final date = DateFromPicker(DateTime(2024));

        // When
        viewModel.demarcheSelected(demarche);
        viewModel.commentChanged(comment);
        viewModel.dateDemarcheThematiqueChanged(date);

        final action = viewModel.createDemarcheRequestAction();

        // Then
        expect(action.codeQuoi, "test_quoi");
        expect(action.codePourquoi, "test_pourquoi");
        expect(action.codeComment, "test_code");
        expect(action.dateEcheance, DateTime(2024));
        expect(action.estDuplicata, false);
      });
    });
  });
}
