import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class CreateDemarcheStep2ViewModel extends Equatable {
  final List<CreateDemarcheStep2Item> items;

  CreateDemarcheStep2ViewModel(this.items);

  factory CreateDemarcheStep2ViewModel.create(Store<AppState> store, DemarcheSource source) {
    final List<DemarcheDuReferentiel> demarches = source.demarcheList(store);
    return CreateDemarcheStep2ViewModel(_items(demarches));
  }

  @override
  List<Object?> get props => [items];
}

List<CreateDemarcheStep2Item> _items(List<DemarcheDuReferentiel> demarches) {
  return [
    CreateDemarcheStep2TitleItem(demarches.isNotEmpty ? Strings.selectDemarche : Strings.noDemarcheFound),
    ...demarches.map((demarche) => CreateDemarcheStep2DemarcheFoundItem(demarche.id)),
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
  final String idDemarche;

  CreateDemarcheStep2DemarcheFoundItem(this.idDemarche);

  @override
  List<Object?> get props => [idDemarche];
}

class CreateDemarcheStep2ButtonItem extends CreateDemarcheStep2Item {}
