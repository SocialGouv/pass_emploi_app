import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AccueilViewModel extends Equatable {
  final List<AccueilItem> items;

  AccueilViewModel({
    required this.items,
  });

  factory AccueilViewModel.create(Store<AppState> store) {
    return AccueilViewModel(
      items: _items(store),
    );
  }

  @override
  List<Object?> get props => [items];
}

List<AccueilItem> _items(Store<AppState> store) {
  final accueilState = store.state.accueilState;
  if (accueilState is! AccueilSuccessState) return [];

  return [
    _cetteSemaineItem(accueilState),
    _prochainRendezvousItem(accueilState),
    _evenementsItem(accueilState),
    _alertesItem(accueilState),
    _favorisItem(accueilState),
    _outilsItem(accueilState),
  ].whereNotNull().toList();
}

AccueilItem? _cetteSemaineItem(AccueilSuccessState successState) {
  final cetteSemaine = successState.accueil.cetteSemaine;
  if (cetteSemaine == null) return null;

  return AccueilCetteSemaineItem(
    nombreRendezVous: cetteSemaine.nombreRendezVous,
    nombreActionsDemarchesEnRetard: cetteSemaine.nombreActionsDemarchesEnRetard,
    nombreActionsDemarchesARealiser: cetteSemaine.nombreActionsDemarchesARealiser,
  );
}

AccueilItem? _prochainRendezvousItem(AccueilSuccessState successState) {
  return null;
}

AccueilItem? _evenementsItem(AccueilSuccessState successState) {
  return null;
}

AccueilItem? _alertesItem(AccueilSuccessState successState) {
  return null;
}

AccueilItem? _favorisItem(AccueilSuccessState successState) {
  return null;
}

AccueilItem? _outilsItem(AccueilSuccessState successState) {
  return null;
}

abstract class AccueilItem extends Equatable {
  @override
  List<Object?> get props => [];
}

//TODO: move: 1 file / item

class AccueilCetteSemaineItem extends AccueilItem {
  final int nombreRendezVous;
  final int nombreActionsDemarchesEnRetard;
  final int nombreActionsDemarchesARealiser;

  AccueilCetteSemaineItem({
    required this.nombreRendezVous,
    required this.nombreActionsDemarchesEnRetard,
    required this.nombreActionsDemarchesARealiser,
  });

  @override
  List<Object?> get props => [nombreRendezVous, nombreActionsDemarchesEnRetard, nombreActionsDemarchesARealiser];
}

class AccueilProchainRendezvousItem extends AccueilItem {}

class AccueilEvenementsItem extends AccueilItem {}

class AccueilAlertesItem extends AccueilItem {}

class AccueilFavorisItem extends AccueilItem {}

class AccueilOutilsItem extends AccueilItem {}
