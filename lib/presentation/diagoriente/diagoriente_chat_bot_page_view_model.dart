import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DiagorienteChatBotPageViewModel extends Equatable {
  final String chatBotUrl;

  DiagorienteChatBotPageViewModel({required this.chatBotUrl});

  factory DiagorienteChatBotPageViewModel.create(Store<AppState> store) {
    final state = store.state.diagorienteUrlsState;
    if (state is! DiagorienteUrlsSuccessState) {
      throw Exception('DiagorienteUrlsState must be successful when calling create method');
    }
    return DiagorienteChatBotPageViewModel(chatBotUrl: state.result.chatBotUrl);
  }

  @override
  List<Object?> get props => [chatBotUrl];
}
