import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_state.dart';
import 'package:pass_emploi_app/features/message_informatif/message_informatif_state.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  late _MockChatRepository chatRepository;

  setUp(() {
    chatRepository = _MockChatRepository();
  });

  group('MessageInformatif', () {
    final sut = StoreSut();

    group('on init', () {
      sut.whenDispatchingAction(() => SubscribeToChatAction());

      test("On chat first subscription, should display display message informatif", () async {
        // Given
        sut.givenStore = givenState()
            .copyWith(detailsJeuneState: DetailsJeuneSuccessState(detailsJeune: detailsJeune())) //
            .store((f) => {f.chatRepository = chatRepository..withGetMessageInformatifSuccess()});

        // When & Then
        sut.thenExpectAtSomePoint(_shouldSucceed());
      });

      test("On chat first subscription, should display nothing when failure occurs", () async {
        // Given
        sut.givenStore = givenState()
            .copyWith(detailsJeuneState: DetailsJeuneSuccessState(detailsJeune: detailsJeune())) //
            .store((f) => {f.chatRepository = chatRepository..withGetMessageInformatifFailure()});

        // When & Then
        sut.thenExpectAtSomePoint(_shouldFail());
      });
    });
  });
}

class _MockChatRepository extends Mock implements ChatRepository {
  _MockChatRepository() {
    withMessageStream();
    withChatStatusStream();
  }

  void withGetMessageInformatifSuccess() =>
      when(() => getMessageInformatif(any())).thenAnswer((_) async => dummyMessageInformatif());

  void withGetMessageInformatifFailure() => when(() => getMessageInformatif(any())).thenAnswer((_) async => null);

  void withMessageStream() => when(() => messagesStream(any())).thenAnswer((_) => Stream.value([]));
  void withChatStatusStream() =>
      when(() => chatStatusStream(any())).thenAnswer((_) => Stream.value(ConseillerMessageInfo(false, null)));
}

Matcher _shouldFail() => StateIs<MessageInformatifFailureState>((state) => state.messageInformatifState);

Matcher _shouldSucceed() => StateIs<MessageInformatifSuccessState>((state) => state.messageInformatifState);
