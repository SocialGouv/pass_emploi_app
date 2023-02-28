import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

enum SolutionsTab { offres, outils }

class SolutionsTabPageViewModel extends Equatable {
  final List<SolutionsTab> tabs;

  SolutionsTabPageViewModel._({
    required this.tabs,
  });

  factory SolutionsTabPageViewModel.create(Store<AppState> store) {
    final tabs = [
      SolutionsTab.offres,
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
        case SolutionsTab.outils:
          return Strings.boiteAOutilsTabTitle;
      }
    }).toList();
  }
}
