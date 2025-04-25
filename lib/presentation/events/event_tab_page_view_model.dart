import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum EventTab { maMissionLocale, rechercheExternes }

class EventsTabPageViewModel extends Equatable {
  final List<EventTab> tabs;

  EventsTabPageViewModel._({
    required this.tabs,
  });

  factory EventsTabPageViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    final user = state is LoginSuccessState ? state.user : null;
    final isMiLo = user?.loginMode.isMiLo() == true;
    return EventsTabPageViewModel._(
      tabs: [
        if (isMiLo) EventTab.maMissionLocale,
        EventTab.rechercheExternes,
      ],
    );
  }

  @override
  List<Object?> get props => [tabs];
}
