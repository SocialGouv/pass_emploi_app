import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';

void main() {
  late bool hasBeenNotified;

  setUp(() {
    hasBeenNotified = false;
  });

  void notify() => hasBeenNotified = true;

  group('CreateUserActionFormViewModel', () {
    group('navigation', () {
      group('viewChangedForward', () {
        test('should display step 2 when current step is step 1', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step1)
            ..addListener(notify);

          // When
          viewModel.viewChangedForward();

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.step2);
          expect(hasBeenNotified, true);
        });

        test('should display step 3 when current step is step 2', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step2)
            ..addListener(notify);

          // When
          viewModel.viewChangedForward();

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.step3);
          expect(hasBeenNotified, true);
        });

        test('should display submitted when current step is step 3 and action is terminee and has description', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(
            initialDisplayState: CreateUserActionDisplayState.step3,
            initialStep2: MockCreateUserActionStep2ViewModel(valid: true)..withDescription("any"),
            initialStep3: MockCreateUserActionStep3ViewModel(valid: true)..withEstTerminee(true),
          )..addListener(notify);

          // When
          viewModel.viewChangedForward();

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.submitted);
          expect(hasBeenNotified, true);
        });

        test('should display submitted when current step is step 3 and action is not terminee', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(
            initialDisplayState: CreateUserActionDisplayState.step3,
            initialStep2: MockCreateUserActionStep2ViewModel(valid: false)..withDescription(""),
            initialStep3: MockCreateUserActionStep3ViewModel(valid: true)..withEstTerminee(false),
          )..addListener(notify);

          // When
          viewModel.viewChangedForward();

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.submitted);
          expect(hasBeenNotified, true);
        });

        test('should display descriptionConfimation when current step is step 3 and description is empty and terminee',
            () {
          // Given
          final viewModel = CreateUserActionFormViewModel(
            initialDisplayState: CreateUserActionDisplayState.step3,
            initialStep2: MockCreateUserActionStep2ViewModel(valid: false)..withDescription(""),
            initialStep3: MockCreateUserActionStep3ViewModel(valid: true)..withEstTerminee(true),
          )..addListener(notify);

          // When
          viewModel.viewChangedForward();

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.descriptionConfimation);
          expect(hasBeenNotified, true);
        });
      });
      group('viewChangedBackward', () {
        test('should display aborted when current step is step 1', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step1)
            ..addListener(notify);

          // When
          viewModel.viewChangedBackward();

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.aborted);
          expect(hasBeenNotified, true);
        });

        test('should display step 1 when current step is step 2', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step2)
            ..addListener(notify);

          // When
          viewModel.viewChangedBackward();

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.step1);
          expect(hasBeenNotified, true);
        });

        test('should display step 2 when current step is step 3', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step3)
            ..addListener(notify);

          // When
          viewModel.viewChangedBackward();

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.step2);
          expect(hasBeenNotified, true);
        });

        test('should display step 3 when current step is descriptionConfimation', () {
          // Given
          final viewModel =
              CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.descriptionConfimation)
                ..addListener(notify);

          // When
          viewModel.viewChangedBackward();

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.step2);
          expect(hasBeenNotified, true);
        });
      });

      group('goBackToStep2', () {
        test('should display step 2', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step3)
            ..addListener(notify);

          // When
          viewModel.goBackToStep2();

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.step2);
          expect(hasBeenNotified, true);
        });
      });

      group('confirmDescription', () {
        test('should display submitted', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step3)
            ..addListener(notify);

          // When
          viewModel.confirmDescription();

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.submitted);
          expect(hasBeenNotified, true);
        });
      });

      group('canGoForward', () {
        group('when step is step 1', () {
          test('should return true when valid', () {
            // Given
            final viewModel = CreateUserActionFormViewModel(
              initialStep1: MockCreateUserActionStep1ViewModel(valid: true),
              initialDisplayState: CreateUserActionDisplayState.step1,
            );

            // When & Then
            expect(viewModel.canGoForward, true);
          });

          test('should return false when invalid', () {
            // Given
            final viewModel = CreateUserActionFormViewModel(
              initialStep1: MockCreateUserActionStep1ViewModel(valid: false),
              initialDisplayState: CreateUserActionDisplayState.step1,
            );

            // When & Then
            expect(viewModel.canGoForward, false);
          });
        });
        group('when step is step 2', () {
          test('should return true when valid', () {
            // Given
            final viewModel = CreateUserActionFormViewModel(
              initialStep2: MockCreateUserActionStep2ViewModel(valid: true),
              initialDisplayState: CreateUserActionDisplayState.step2,
            );

            // When & Then
            expect(viewModel.canGoForward, true);
          });
          test('should return false when invalid', () {
            // Given
            final viewModel = CreateUserActionFormViewModel(
              initialStep2: MockCreateUserActionStep2ViewModel(valid: false),
              initialDisplayState: CreateUserActionDisplayState.step2,
            );

            // When & Then
            expect(viewModel.canGoForward, false);
          });
        });
        group('when step is step 3', () {
          test('should return true when valid', () {
            // Given
            final viewModel = CreateUserActionFormViewModel(
              initialStep3: MockCreateUserActionStep3ViewModel(valid: true),
              initialDisplayState: CreateUserActionDisplayState.step3,
            );

            // When & Then
            expect(viewModel.canGoForward, true);
          });
          test('should return false when invalid', () {
            // Given
            final viewModel = CreateUserActionFormViewModel(
              initialStep3: MockCreateUserActionStep3ViewModel(valid: false),
              initialDisplayState: CreateUserActionDisplayState.step3,
            );

            // When & Then
            expect(viewModel.canGoForward, false);
          });
        });

        group('when step is description confirmation', () {
          test('should return true when step 3 is valid', () {
            // Given
            final viewModel = CreateUserActionFormViewModel(
              initialStep3: MockCreateUserActionStep3ViewModel(valid: true),
              initialDisplayState: CreateUserActionDisplayState.descriptionConfimation,
            );

            // When & Then
            expect(viewModel.canGoForward, true);
          });
          test('should return false when step 3 invalid', () {
            // Given
            final viewModel = CreateUserActionFormViewModel(
              initialStep3: MockCreateUserActionStep3ViewModel(valid: false),
              initialDisplayState: CreateUserActionDisplayState.descriptionConfimation,
            );

            // When & Then
            expect(viewModel.canGoForward, false);
          });
        });
      });
    });

    group('currentstate', () {
      test('should return step 1 view model when display state is aborted', () {
        // Given
        final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.aborted);

        // When & Then
        expect(viewModel.currentstate, isA<CreateUserActionStep1ViewModel>());
      });

      test('should return step 1 view model when display state is step 1', () {
        // Given
        final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step1);

        // When & Then
        expect(viewModel.currentstate, isA<CreateUserActionStep1ViewModel>());
      });

      test('should return step 2 view model when display state is step 2', () {
        // Given
        final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step2);

        // When & Then
        expect(viewModel.currentstate, isA<CreateUserActionStep2ViewModel>());
      });

      test('should return step 3 view model when display state is step 3', () {
        // Given
        final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step3);

        // When & Then
        expect(viewModel.currentstate, isA<CreateUserActionStep3ViewModel>());
      });

      test('should return step 3 view model when display state is submitted', () {
        // Given
        final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.submitted);

        // When & Then
        expect(viewModel.currentstate, isA<CreateUserActionStep3ViewModel>());
      });
    });

    group('value changed', () {
      group('userActionTypeSelected', () {
        test('should update type and notify listeners', () {
          // Given
          final viewModel = CreateUserActionFormViewModel()..addListener(notify);

          // When
          viewModel.userActionTypeSelected(UserActionReferentielType.formation);

          // Then
          expect(viewModel.step1.actionCategory, UserActionReferentielType.formation);
          expect(hasBeenNotified, true);
        });
      });

      group('titleChanged', () {
        test('should be on step 2', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step3)
            ..addListener(notify);

          // When
          viewModel.titleChanged(CreateActionTitleFromUserInput("title"));

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.step2);
          expect(hasBeenNotified, true);
        });

        test('should update title and notify listeners', () {
          // Given
          final viewModel = CreateUserActionFormViewModel()..addListener(notify);

          // When
          viewModel.titleChanged(CreateActionTitleFromUserInput("title"));

          // Then
          expect(viewModel.step2.titleSource.title, "title");
          expect(hasBeenNotified, true);
        });
      });

      group('descriptionChanged', () {
        test('should be on step 2', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step3)
            ..addListener(notify);

          // When
          viewModel.descriptionChanged("description");

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.step2);
          expect(hasBeenNotified, true);
        });

        test('should update description and notify listeners', () {
          // Given
          final viewModel = CreateUserActionFormViewModel()..addListener(notify);

          // When
          viewModel.descriptionChanged("description");

          // Then
          expect(viewModel.step2.description, "description");
          expect(hasBeenNotified, true);
        });
      });

      group('statusChanged', () {
        test('should be on step 3', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step2)
            ..addListener(notify);

          // When
          viewModel.statusChanged(true);

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.step3);
          expect(hasBeenNotified, true);
        });

        test('should update status and notify listeners', () {
          // Given
          final viewModel = CreateUserActionFormViewModel()..addListener(notify);

          // When
          viewModel.statusChanged(false);

          // Then
          expect(viewModel.step3.estTerminee, false);
          expect(hasBeenNotified, true);
        });
      });
      group('dateChanged', () {
        test('should be on step 3', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step2)
            ..addListener(notify);

          // When
          viewModel.dateChanged(DateFromPicker(DateTime(2023)));

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.step3);
          expect(hasBeenNotified, true);
        });

        test('should update date and notify listeners', () {
          // Given
          final viewModel = CreateUserActionFormViewModel()..addListener(notify);

          // When
          viewModel.dateChanged(DateFromPicker(DateTime(2023)));

          // Then
          expect(viewModel.step3.dateSource.selectedDate, DateTime(2023));
          expect(hasBeenNotified, true);
        });
      });
      group('withRappelChanged', () {
        test('should be on step 3', () {
          // Given
          final viewModel = CreateUserActionFormViewModel(initialDisplayState: CreateUserActionDisplayState.step2)
            ..addListener(notify);

          // When
          viewModel.withRappelChanged(true);

          // Then
          expect(viewModel.displayState, CreateUserActionDisplayState.step3);
          expect(hasBeenNotified, true);
        });
        test('should update withRappel and notify listeners', () {
          // Given
          final viewModel = CreateUserActionFormViewModel()..addListener(notify);

          // When
          viewModel.withRappelChanged(true);

          // Then
          expect(viewModel.step3.withRappel, true);
          expect(hasBeenNotified, true);
        });
      });
    });
  });
}

class MockCreateUserActionStep1ViewModel with Mock implements CreateUserActionStep1ViewModel {
  final bool valid;

  MockCreateUserActionStep1ViewModel({required this.valid}) {
    when(() => isValid).thenReturn(valid);
  }
}

class MockCreateUserActionStep2ViewModel with Mock implements CreateUserActionStep2ViewModel {
  final bool valid;

  MockCreateUserActionStep2ViewModel({required this.valid}) {
    when(() => isValid).thenReturn(valid);
  }

  void withDescription(String description) {
    when(() => this.description).thenReturn(description);
  }
}

class MockCreateUserActionStep3ViewModel with Mock implements CreateUserActionStep3ViewModel {
  final bool valid;

  MockCreateUserActionStep3ViewModel({required this.valid}) {
    when(() => isValid).thenReturn(valid);
  }

  void withEstTerminee(bool estTerminee) {
    when(() => this.estTerminee).thenReturn(estTerminee);
  }
}
