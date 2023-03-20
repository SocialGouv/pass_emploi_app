import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_webview_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  test('create when diagoriente url state is not successful should throw exception', () {
    // Given
    final store = givenState().store();

    // When /Then
    expect(() => DiagorienteWebviewViewModel.create(store, DiagorienteWebviewMode.chatbot), throwsException);
  });

  group('chatBotUrl when diagoriente url state is successful should return proper URL', () {
    test("on chatbot mode", () {
      // Given
      final store = givenState().withDiagorientePreferencesMetierSuccessState().store();

      // When
      final viewModel = DiagorienteWebviewViewModel.create(store, DiagorienteWebviewMode.chatbot);

      // When /Then
      expect(viewModel.url, 'chatBotUrl');
    });

    test("on favoris mode", () {
      // Given
      final store = givenState().withDiagorientePreferencesMetierSuccessState().store();

      // When
      final viewModel = DiagorienteWebviewViewModel.create(store, DiagorienteWebviewMode.favoris);

      // When /Then
      expect(viewModel.url, 'metiersFavorisUrl');
    });
  });

  group('appBarTitle', () {
    test("on chatbot mode", () {
      // Given
      final store = givenState().withDiagorientePreferencesMetierSuccessState().store();

      // When
      final viewModel = DiagorienteWebviewViewModel.create(store, DiagorienteWebviewMode.chatbot);

      // When /Then
      expect(viewModel.appBarTitle, 'Découvrir des métiers');
    });

    test("on favoris mode", () {
      // Given
      final store = givenState().withDiagorientePreferencesMetierSuccessState().store();

      // When
      final viewModel = DiagorienteWebviewViewModel.create(store, DiagorienteWebviewMode.favoris);

      // When /Then
      expect(viewModel.appBarTitle, 'Mes métiers favoris');
    });
  });
}
