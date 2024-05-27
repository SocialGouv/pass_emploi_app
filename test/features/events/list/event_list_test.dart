import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/animations_collectives_repository.dart';

import '../../../doubles/dio_mock.dart';
import '../../../doubles/fixtures.dart';
import '../../../doubles/mocks.dart';
import '../../../dsl/app_state_dsl.dart';
import '../../../dsl/matchers.dart';
import '../../../dsl/sut_redux.dart';

void main() {
  group('Event list', () {
    final sut = StoreSut();
    final sessionMiloRepository = MockSessionMiloRepository();

    setUp(() {
      reset(sessionMiloRepository);
    });

    group("when requesting event list", () {
      sut.whenDispatchingAction(() => EventListRequestAction(DateTime.now()));

      test('should load then succeed when both request succeed', () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) {
          f.animationsCollectivesRepository = AnimationsCollectivesRepositorySuccessStub();
          f.sessionMiloRepository = sessionMiloRepository;
          sessionMiloRepository.mockGetListSuccess();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed(animations: true, sessions: true)]);
      });

      group('should load then succeed when one of the two request fail', () {
        test('animations KO session OK', () {
          sut.givenStore = givenState()
              .loggedInUser() //
              .store((f) {
            f.animationsCollectivesRepository = AnimationsCollectivesRepositoryErrorStub();
            f.sessionMiloRepository = sessionMiloRepository;
            sessionMiloRepository.mockGetListSuccess();
          });

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed(animations: false, sessions: true)]);
        });

        test('animations OK session KO', () {
          sut.givenStore = givenState()
              .loggedInUser() //
              .store((f) {
            f.animationsCollectivesRepository = AnimationsCollectivesRepositorySuccessStub();
            f.sessionMiloRepository = sessionMiloRepository;
            sessionMiloRepository.mockGetListFailure();
          });

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed(animations: true, sessions: false)]);
        });
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) {
          f.animationsCollectivesRepository = AnimationsCollectivesRepositoryErrorStub();
          f.sessionMiloRepository = sessionMiloRepository;
          sessionMiloRepository.mockGetListFailure();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<EventListLoadingState>((state) => state.eventListState);

Matcher _shouldFail() => StateIs<EventListFailureState>((state) => state.eventListState);

Matcher _shouldSucceed({required bool animations, required bool sessions}) {
  return StateIs<EventListSuccessState>(
    (state) => state.eventListState,
    (state) {
      expect(state.animationsCollectives.length, animations ? 1 : 0);
      expect(state.sessionsMilos.length, sessions ? 1 : 0);
    },
  );
}

class AnimationsCollectivesRepositorySuccessStub extends AnimationsCollectivesRepository {
  AnimationsCollectivesRepositorySuccessStub() : super(DioMock());

  @override
  Future<List<Rendezvous>?> get(String userId, DateTime maintenant) async {
    return [mockRendezvous()];
  }
}

class AnimationsCollectivesRepositoryErrorStub extends AnimationsCollectivesRepository {
  AnimationsCollectivesRepositoryErrorStub() : super(DioMock());

  @override
  Future<List<Rendezvous>?> get(String userId, DateTime maintenant) async {
    return null;
  }
}
