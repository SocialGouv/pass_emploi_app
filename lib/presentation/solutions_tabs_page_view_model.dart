import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

enum SolutionsTab { recherche, offresEnregistrees, outils }

class SolutionsTabPageViewModel extends Equatable {
  final List<SolutionsTab> tabs;

  SolutionsTabPageViewModel._({
    required this.tabs,
  });

  factory SolutionsTabPageViewModel.create(Store<AppState> store) {
    return SolutionsTabPageViewModel._(tabs: [
      SolutionsTab.recherche,
      SolutionsTab.offresEnregistrees,
      SolutionsTab.outils,
    ]);
  }

  @override
  List<Object?> get props => [tabs];
}

extension SolutionsTabTitles on List<SolutionsTab> {
  List<String> titles() {
    return map((tab) {
      return switch (tab) {
        SolutionsTab.recherche => Strings.rechercheTabTitle,
        SolutionsTab.offresEnregistrees => Strings.offresEnregistreesTabTitle,
        SolutionsTab.outils => Strings.boiteAOutilsTabTitle
      };
    }).toList();
  }
}
