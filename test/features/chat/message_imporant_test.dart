import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_state.dart';
import 'package:pass_emploi_app/features/message_important/message_important_state.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  late _MockChatRepository chatRepository;
  late _MockDetailsJeuneRepository detailsJeuneRepository;

  setUp(() {
    chatRepository = _MockChatRepository();
    detailsJeuneRepository = _MockDetailsJeuneRepository();
  });

  group('MessageImportant', () {
    final sut = StoreSut();

    group('on init', () {
      sut.whenDispatchingAction(() => SubscribeToChatAction());

      test("On chat first subscription, should display display message informatif", () async {
        // Given
        sut.givenStore = givenState()
            .loggedInMiloUser()
            .copyWith(detailsJeuneState: DetailsJeuneSuccessState(detailsJeune: detailsJeune())) //
            .store((f) => {
                  f.chatRepository = chatRepository..withGetMessageImportantSuccess(),
                  f.detailsJeuneRepository = detailsJeuneRepository..withGetDetailsJeuneSuccess(),
                });

        // When & Then
        sut.thenExpectAtSomePoint(_shouldSucceed());
      });

      test("On chat first subscription, should display display nothing on fetch details jeune error", () async {
        // Given
        sut.givenStore = givenState()
            .loggedInMiloUser()
            .copyWith(detailsJeuneState: DetailsJeuneSuccessState(detailsJeune: detailsJeune())) //
            .store((f) => {
                  f.chatRepository = chatRepository..withGetMessageImportantSuccess(),
                  f.detailsJeuneRepository = detailsJeuneRepository..withGetDetailsJeuneFailure(),
                });

        // When & Then
        sut.thenExpectNever(_shouldSucceed());
      });
    });
  });
}

class _MockChatRepository extends Mock implements ChatRepository {
  _MockChatRepository() {
    withMessageStream();
    withChatStatusStream();
  }

  void withGetMessageImportantSuccess() =>
      when(() => getMessageImportant(any())).thenAnswer((_) async => dummyMessageImportant());

  void withGetMessageImportantFailure() => when(() => getMessageImportant(any())).thenAnswer((_) async => null);

  void withMessageStream() => when(() => messagesStream(any())).thenAnswer((_) => Stream.value([]));

  void withChatStatusStream() =>
      when(() => chatStatusStream(any())).thenAnswer((_) => Stream.value(ConseillerMessageInfo(false, null)));
}

class _MockDetailsJeuneRepository extends Mock implements DetailsJeuneRepository {
  void withGetDetailsJeuneSuccess() => when(() => get(any())).thenAnswer((_) async => detailsJeune());

  void withGetDetailsJeuneFailure() => when(() => get(any())).thenAnswer((_) async => null);
}

Matcher _shouldSucceed() => StateIs<MessageImportantSuccessState>((state) => state.messageImportantState);
