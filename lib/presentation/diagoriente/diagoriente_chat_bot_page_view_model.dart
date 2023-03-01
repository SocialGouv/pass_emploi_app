import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DiagorienteChatBotPageViewModel extends Equatable {
  final String chatBotUrl;

  DiagorienteChatBotPageViewModel({required this.chatBotUrl});

  factory DiagorienteChatBotPageViewModel.create(Store<AppState> store) {
    final state = store.state.diagorientePreferencesMetierState;
    if (state is! DiagorientePreferencesMetierSuccessState) {
      throw Exception('DiagorientePreferencesMetierState must be successful when calling create method');
    }
    return DiagorienteChatBotPageViewModel(chatBotUrl: state.urls.chatBotUrl);
  }

  @override
  List<Object?> get props => [chatBotUrl];
}
