import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/animations_collectives_repository.dart';

import '../../../doubles/dio_mock.dart';
import '../../../doubles/fixtures.dart';
import '../../../dsl/app_state_dsl.dart';
import '../../../dsl/matchers.dart';
import '../../../dsl/sut_redux.dart';

void main() {
  group('Event list', () {
    final sut = StoreSut();

    group("when requesting agenda", () {
      sut.when(() => EventListRequestAction(DateTime.now()));

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.animationsCollectivesRepository = AnimationsCollectivesRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.animationsCollectivesRepository = AnimationsCollectivesRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<EventListLoadingState>((state) => state.eventListState);

Matcher _shouldFail() => StateIs<EventListFailureState>((state) => state.eventListState);

Matcher _shouldSucceed() {
  return StateIs<EventListSuccessState>(
    (state) => state.eventListState,
    (state) {
      expect(state.animationsCollectives.length, 1);
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
