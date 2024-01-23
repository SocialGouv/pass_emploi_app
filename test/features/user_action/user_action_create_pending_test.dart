import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/repositories/user_action_pending_creation_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  final UserActionCreateRequest request = dummyUserActionCreateRequest();
  late MockUserActionPendingCreationRepository repository;

  setUp(() {
    repository = MockUserActionPendingCreationRepository();
  });

  group('UserActionCreatePending', () {
    final sut = StoreSut();

    group("on app bootstrap ", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should init state with proper pending action count', () {
        when(() => repository.getPendingActionCount()).thenAnswer((_) async => 7);
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.userActionPendingCreationRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldHavePendingCreations(7)]);
      });
    });

    group("when user action creation fails", () {
      sut.whenDispatchingAction(() => UserActionCreateFailureAction(request));

      test('should save request and update state', () {
        when(() => repository.save(request)).thenAnswer((_) async => 1);
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.userActionPendingCreationRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldHavePendingCreations(1)]);
      });
    });

    group("on connectivity retrieved", () {
      final request1 = dummyUserActionCreateRequest('1');
      final request2 = dummyUserActionCreateRequest('2');
      late MockUserActionRepository userActionRepository;

      setUp(() {
        userActionRepository = MockUserActionRepository();
      });

      group('with a single connectivity update event', () {
        late MockUserActionPendingCreationRepository pendingRepository;
        setUp(() {
          userActionRepository = MockUserActionRepository();
          pendingRepository = MockUserActionPendingCreationRepository();
          when(() => pendingRepository.load()).thenAnswer((_) async => [request1, request2]);
          when(() => pendingRepository.delete(request1)).thenAnswer((_) async {});
          when(() => pendingRepository.delete(request2)).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedInUser()
              .store(
                (f) => {
                  f.userActionPendingCreationRepository = pendingRepository,
                  f.userActionRepository = userActionRepository
                },
              );
        });

        sut.whenDispatchingAction(() => ConnectivityUpdatedAction(ConnectivityResult.wifi));

        test('should try to synchronize actions and delete them locally if it is successful', () async {
          // Given
          when(() => userActionRepository.createUserAction('id', request1)).thenAnswer((_) async => 'id-1');
          when(() => userActionRepository.createUserAction('id', request2)).thenAnswer((_) async => 'id-2');

          // Then
          await sut.thenExpectChangingStatesThroughOrder([_shouldHavePendingCreations(0)]);
          await _expectAfterAsynchronousProcess(() async {
            verify(() => pendingRepository.delete(request1)).called(1);
            verify(() => pendingRepository.delete(request2)).called(1);
          });
        });

        test('should try to synchronize actions but not delete them locally if it is not successful', () async {
          // Given
          when(() => userActionRepository.createUserAction('id', request1)).thenAnswer((_) async => 'id-1');
          when(() => userActionRepository.createUserAction('id', request2)).thenAnswer((_) async => null);

          // Then
          await sut.thenExpectChangingStatesThroughOrder([_shouldHavePendingCreations(1)]);
          await _expectAfterAsynchronousProcess(() async {
            verify(() => pendingRepository.delete(request1)).called(1);
            verifyNever(() => pendingRepository.delete(request2));
          });
        });
      });

      group("with multiple connectivity update events", () {
        late UserActionPendingCreationRepository pendingRepository;

        setUp(() async {
          pendingRepository = UserActionPendingCreationRepository(SharedPreferencesSpy());
          await pendingRepository.save(request1);
          await pendingRepository.save(request2);

          sut.givenStore = givenState() //
              .loggedInUser()
              .store(
                (f) => {
                  f.userActionPendingCreationRepository = pendingRepository,
                  f.userActionRepository = userActionRepository
                },
              );
        });

        sut.whenDispatchingActions([
          ConnectivityUpdatedAction(ConnectivityResult.wifi),
          ConnectivityUpdatedAction(ConnectivityResult.wifi),
        ]);

        test('should not create actions multiple times', () async {
          // Given
          when(() => userActionRepository.createUserAction('id', request1)).thenAnswer((_) async => 'id-1');
          when(() => userActionRepository.createUserAction('id', request2)).thenAnswer((_) async => 'id-2');

          // Then
          await sut.thenExpectChangingStatesThroughOrder([_shouldHavePendingCreations(0)]);
          await _expectAfterAsynchronousProcess(() async {
            expect(await pendingRepository.getPendingActionCount(), 0);
            verify(() => userActionRepository.createUserAction('id', request1)).called(1);
            verify(() => userActionRepository.createUserAction('id', request2)).called(1);
          });
        });
      });
    });
  });
}

Future<void> _expectAfterAsynchronousProcess(Future<void> Function() computation) async {
  await Future.delayed(Duration(milliseconds: 200), computation);
}

Matcher _shouldHavePendingCreations(int count) {
  return StateIs<UserActionCreatePendingSuccessState>(
    (state) => state.userActionCreatePendingState,
    (state) => expect(state.pendingCreationsCount, count),
  );
}

class MockUserActionRepository extends Mock implements UserActionRepository {}
