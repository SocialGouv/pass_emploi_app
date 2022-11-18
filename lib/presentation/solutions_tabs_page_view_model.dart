import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

enum SolutionsTab { offres, events, outils }

class SolutionsTabPageViewModel {
  final List<SolutionsTab> tabs;

  SolutionsTabPageViewModel._({
    required this.tabs,
  });

  factory SolutionsTabPageViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final loginMode = loginState is LoginSuccessState ? loginState.user.loginMode : null;
    final tabs = [
      SolutionsTab.offres,
      if (loginMode.isMiLo()) SolutionsTab.events,
      SolutionsTab.outils,
    ];
    return SolutionsTabPageViewModel._(tabs: tabs);
  }

  @override
  List<Object?> get props => [tabs];
}

extension SolutionsTabTitles on List<SolutionsTab> {
  List<String> titles() {
    return map((tab) {
      switch (tab) {
        case SolutionsTab.offres:
          return Strings.offresTabTitle;
        case SolutionsTab.events:
          return Strings.eventsTabTitle;
        case SolutionsTab.outils:
          return Strings.boiteAOutilsTabTitle;
      }
    }).toList();
  }
}
