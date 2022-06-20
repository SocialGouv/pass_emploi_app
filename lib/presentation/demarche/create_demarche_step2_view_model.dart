import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class CreateDemarcheStep2ViewModel extends Equatable {
  final List<CreateDemarcheStep2Item> items;

  CreateDemarcheStep2ViewModel(this.items);

  factory CreateDemarcheStep2ViewModel.create(Store<AppState> store) {
    final state = store.state.searchDemarcheState;
    final List<DemarcheDuReferentiel> demarches =
        state is SearchDemarcheSuccessState ? state.demarchesDuReferentiel : [];
    return CreateDemarcheStep2ViewModel(_items(demarches));
  }

  @override
  List<Object?> get props => [items];
}

List<CreateDemarcheStep2Item> _items(List<DemarcheDuReferentiel> demarches) {
  return [
    CreateDemarcheStep2TitleItem(demarches.isNotEmpty ? Strings.selectDemarche : Strings.noDemarcheFound),
    ...demarches.mapIndexed((index, _) => CreateDemarcheStep2DemarcheFoundItem(index)),
    CreateDemarcheStep2ButtonItem(),
  ];
}

abstract class CreateDemarcheStep2Item extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateDemarcheStep2TitleItem extends CreateDemarcheStep2Item {
  final String title;

  CreateDemarcheStep2TitleItem(this.title);

  @override
  List<Object?> get props => [title];
}

class CreateDemarcheStep2DemarcheFoundItem extends CreateDemarcheStep2Item {
  final int indexOfDemarche;

  CreateDemarcheStep2DemarcheFoundItem(this.indexOfDemarche);

  @override
  List<Object?> get props => [indexOfDemarche];
}

class CreateDemarcheStep2ButtonItem extends CreateDemarcheStep2Item {}
