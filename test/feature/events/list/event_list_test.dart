import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/event_list_repository.dart';

import '../../../doubles/dummies.dart';
import '../../../doubles/fixtures.dart';
import '../../../dsl/app_state_dsl.dart';
import '../../../dsl/matchers.dart';
import '../../../dsl/sut_redux.dart';

void main() {
  group('Event list', () {
    final sut = StoreSut();

    group("when requesting agenda", () {
      sut.when(() => EventListRequestAction());

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.eventListRepository = EventListRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.eventListRepository = EventListRepositoryErrorStub()});

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
      expect(state.rendezvous.length, 1);
    },
  );
}

class EventListRepositorySuccessStub extends EventListRepository {
  EventListRepositorySuccessStub() : super("", DummyHttpClient());

  @override
  Future<List<Rendezvous>?> get(String userId) async {
    return [mockRendezvous()];
  }
}

class EventListRepositoryErrorStub extends EventListRepository {
  EventListRepositoryErrorStub() : super("", DummyHttpClient());

  @override
  Future<List<Rendezvous>?> get(String userId) async {
    return null;
  }
}
