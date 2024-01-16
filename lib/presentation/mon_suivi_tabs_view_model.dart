import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

enum MonSuiviTab { AGENDA, ACTIONS, DEMARCHE, RENDEZVOUS }

class MonSuiviTabsViewModel extends Equatable {
  final List<MonSuiviTab> tabs;
  final List<String> tabTitles;
  final int initialTabIndex;
  final bool isModeDemo;

  MonSuiviTabsViewModel._({
    required this.tabs,
    required this.tabTitles,
    required this.initialTabIndex,
    required this.isModeDemo,
  });

  factory MonSuiviTabsViewModel.create(Store<AppState> store, [MonSuiviTab? initialTab]) {
    final loginState = store.state.loginState;
    final loginMode = loginState is LoginSuccessState ? loginState.user.loginMode : null;
    final tabs = [
      MonSuiviTab.AGENDA,
      loginMode.isPe() ? MonSuiviTab.DEMARCHE : MonSuiviTab.ACTIONS,
      MonSuiviTab.RENDEZVOUS,
    ];
    return MonSuiviTabsViewModel._(
      tabs: tabs,
      tabTitles: _tabTitles(tabs),
      initialTabIndex: _initialTabIndex(tabs, initialTab),
      isModeDemo: store.state.demoState,
    );
  }

  @override
  List<Object?> get props => [tabs, tabTitles, initialTabIndex, isModeDemo];
}

int _initialTabIndex(List<MonSuiviTab> tabs, MonSuiviTab? initialTab) {
  if (initialTab == null) return 0;
  final index = tabs.indexOf(initialTab);
  if (index < 0) return 0;
  return index;
}

List<String> _tabTitles(List<MonSuiviTab> tabs) {
  return tabs.map((tab) {
    switch (tab) {
      case MonSuiviTab.AGENDA:
        return Strings.agendaTabTitle;
      case MonSuiviTab.ACTIONS:
        return Strings.actionsTabTitle;
      case MonSuiviTab.DEMARCHE:
        return Strings.demarcheTabTitle;
      case MonSuiviTab.RENDEZVOUS:
        return Strings.rendezvousTabTitle;
    }
  }).toList();
}
