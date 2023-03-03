import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/models/diagoriente_urls.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:pass_emploi_app/ui/strings.dart';

enum DiagorienteWebviewMode { chatbot, favoris }

class DiagorienteWebviewViewModel extends Equatable {
  final String url;
  final String appBarTitle;

  DiagorienteWebviewViewModel({required this.url, required this.appBarTitle});

  factory DiagorienteWebviewViewModel.create(Store<AppState> store, DiagorienteWebviewMode mode) {
    final state = store.state.diagorientePreferencesMetierState;
    if (state is! DiagorientePreferencesMetierSuccessState) {
      throw Exception('DiagorientePreferencesMetierState must be successful when calling create method');
    }
    return DiagorienteWebviewViewModel(
      url: _url(state.urls, mode),
      appBarTitle: _appBarTitleFromMode(mode),
    );
  }

  @override
  List<Object?> get props => [url, appBarTitle];
}

String _appBarTitleFromMode(DiagorienteWebviewMode mode) {
  switch (mode) {
    case DiagorienteWebviewMode.chatbot:
      return Strings.diagorienteChatBotPageTitle;
    case DiagorienteWebviewMode.favoris:
      return Strings.diagorienteMetiersFavorisPageTitle;
  }
}

String _url(DiagorienteUrls urls, DiagorienteWebviewMode mode) {
  switch (mode) {
    case DiagorienteWebviewMode.chatbot:
      return urls.chatBotUrl;
    case DiagorienteWebviewMode.favoris:
      return urls.metiersFavorisUrl;
  }
}
