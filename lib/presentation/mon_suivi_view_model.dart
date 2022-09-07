import 'package:pass_emploi_app/ui/strings.dart';

// todo Tests minimalists

enum MonSuiviTab { AGENDA, ACTIONS, DEMARCHE, RENDEZVOUS }

class MonSuiviViewModel {
  final List<MonSuiviTab> tabs;
  final MonSuiviTab? initialTab;

  MonSuiviViewModel._(this.tabs, this.initialTab);

  factory MonSuiviViewModel.create({required bool isPoleEmploiLogin, MonSuiviTab? initialTab}) {
    return MonSuiviViewModel._(isPoleEmploiLogin ? _tabsPE() : _tabsMilo(), initialTab);
  }

  static List<MonSuiviTab> _tabsPE() => [MonSuiviTab.DEMARCHE, MonSuiviTab.RENDEZVOUS];

  static List<MonSuiviTab> _tabsMilo() => [MonSuiviTab.AGENDA, MonSuiviTab.ACTIONS, MonSuiviTab.RENDEZVOUS];

  int indexOfTab(MonSuiviTab tab) {
    return tabs.indexOf(tab);
  }

  List<String> tabTitles() {
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

  int initialIndex() {
    if (initialTab == null) return 0;
    final index = indexOfTab(initialTab!);
    if (index < 0) return 0;
    return index;
  }
}
