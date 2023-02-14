import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/models/location.dart';

//TODO(1418): à supprimer ?
abstract class ImmersionSearchParametersState extends Equatable {
  ImmersionSearchParametersState._();
}

class ImmersionSearchParametersInitializedState extends ImmersionSearchParametersState {
  final String codeRome;
  final Location location;
  final ImmersionFiltresRecherche filtres;
  final String? title;

  ImmersionSearchParametersInitializedState({
    required this.codeRome,
    required this.location,
    required this.filtres,
    this.title,
  }) : super._();

  @override
  List<Object?> get props => [codeRome, location, filtres, title];
}

class ImmersionSearchParametersNotInitializedState extends ImmersionSearchParametersState {
  ImmersionSearchParametersNotInitializedState() : super._();

  @override
  List<Object> get props => [];
}
