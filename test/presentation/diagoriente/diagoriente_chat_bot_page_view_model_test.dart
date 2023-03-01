import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_chat_bot_page_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  test('create when diagoriente url state is not successful should throw exception', () {
    // Given
    final store = givenState().store();

    // When /Then
    expect(() => DiagorienteChatBotPageViewModel.create(store, DiagorienteChatBotPageMode.chatbot), throwsException);
  });

  group('chatBotUrl when diagoriente url state is successful should return proper URL', () {
    test("on chatbot mode", () {
      // Given
      final store = givenState().diagorientePreferencesMetierSuccessState().store();

      // When
      final viewModel = DiagorienteChatBotPageViewModel.create(store, DiagorienteChatBotPageMode.chatbot);

      // When /Then
      expect(viewModel.url, 'chatBotUrl');
    });

    test("on favoris mode", () {
      // Given
      final store = givenState().diagorientePreferencesMetierSuccessState().store();

      // When
      final viewModel = DiagorienteChatBotPageViewModel.create(store, DiagorienteChatBotPageMode.favoris);

      // When /Then
      expect(viewModel.url, 'metiersFavorisUrl');
    });
  });
}
