import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
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
  return [
    _cetteSemaineItem(store),
    _prochainRendezvousItem(store),
    _evenementsItem(store),
    _alertesItem(store),
    _favorisItem(store),
    _outilsItem(store),
  ].whereNotNull().toList();
}

AccueilItem? _cetteSemaineItem(Store<AppState> store) {
  return null;
}

AccueilItem? _prochainRendezvousItem(Store<AppState> store) {
  return null;
}

AccueilItem? _evenementsItem(Store<AppState> store) {
  return null;
}

AccueilItem? _alertesItem(Store<AppState> store) {
  return null;
}

AccueilItem? _favorisItem(Store<AppState> store) {
  return null;
}

AccueilItem? _outilsItem(Store<AppState> store) {
  return null;
}

abstract class AccueilItem extends Equatable {
  @override
  List<Object?> get props => [];
}

//TODO: move: 1 file / item

class AccueilCetteSemaineItem extends AccueilItem {}

class AccueilProchainRendezvousItem extends AccueilItem {}

class AccueilEvenementsItem extends AccueilItem {}

class AccueilAlertesItem extends AccueilItem {}

class AccueilFavorisItem extends AccueilItem {}

class AccueilOutilsItem extends AccueilItem {}
