import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/presentation/chat/chat_message_bottom_sheet_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  group('ChatMessageBottomSheetViewModel', () {
    final messageBase = Message(
      id: "uid",
      content: 'Mon message',
      creationDate: DateTime(2023),
      sentBy: Sender.jeune,
      type: MessageType.message,
      sendingStatus: MessageSendingStatus.sent,
      contentStatus: MessageContentStatus.content,
      pieceJointes: [],
    );
    test('should display edit and delete options when message is from jeune and not already deleted', () {
      // Given
      final message = messageBase;

      final store = givenState().chatSuccess([message]).store();

      // When
      final viewModel = ChatMessageBottomSheetViewModel.create(store, message.id);

      // Then
      expect(viewModel.withEditOption, true);
      expect(viewModel.withDeleteOption, true);
    });

    test('should not display edit options option when message is already deleted', () {
      // Given
      final message = messageBase.copyWith(sentBy: Sender.jeune, contentStatus: MessageContentStatus.deleted);

      final store = givenState().chatSuccess([message]).store();

      // When
      final viewModel = ChatMessageBottomSheetViewModel.create(store, message.id);

      // Then
      expect(viewModel.withEditOption, false);
      expect(viewModel.withDeleteOption, false);
    });

    test('should not display edit options option when message is from conseiller', () {
      // Given
      final message = messageBase.copyWith(sentBy: Sender.conseiller);

      final store = givenState().chatSuccess([message]).store();

      // When
      final viewModel = ChatMessageBottomSheetViewModel.create(store, message.id);

      // Then
      expect(viewModel.withEditOption, false);
      expect(viewModel.withDeleteOption, false);
    });

    test('should not display delete and edit option when message is not sent', () {
      // Given
      final message = messageBase.copyWith(sendingStatus: MessageSendingStatus.sending);

      final store = givenState().chatSuccess([message]).store();

      // When
      final viewModel = ChatMessageBottomSheetViewModel.create(store, message.id);

      // Then
      expect(viewModel.withEditOption, false);
      expect(viewModel.withDeleteOption, false);
    });

    test('should not display edit and copy option when message is pj', () {
      // Given
      final message = messageBase.copyWith(type: MessageType.messagePj);

      final store = givenState().chatSuccess([message]).store();

      // When
      final viewModel = ChatMessageBottomSheetViewModel.create(store, message.id);

      // Then
      expect(viewModel.withCopyOption, false);
      expect(viewModel.withEditOption, false);
      expect(viewModel.withDeleteOption, true);
    });
  });
}
