import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/models/diagoriente_urls.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum DiagorienteChatBotPageMode { chatbot, favoris }

class DiagorienteChatBotPageViewModel extends Equatable {
  final String url;

  DiagorienteChatBotPageViewModel({required this.url});

  factory DiagorienteChatBotPageViewModel.create(Store<AppState> store, DiagorienteChatBotPageMode mode) {
    final state = store.state.diagorientePreferencesMetierState;
    if (state is! DiagorientePreferencesMetierSuccessState) {
      throw Exception('DiagorientePreferencesMetierState must be successful when calling create method');
    }
    return DiagorienteChatBotPageViewModel(
      url: _url(state.urls, mode),
    );
  }

  @override
  List<Object?> get props => [url];
}

String _url(DiagorienteUrls urls, DiagorienteChatBotPageMode mode) {
  switch (mode) {
    case DiagorienteChatBotPageMode.chatbot:
      return urls.chatBotUrl;
    case DiagorienteChatBotPageMode.favoris:
      return urls.metiersFavorisUrl;
  }
}
