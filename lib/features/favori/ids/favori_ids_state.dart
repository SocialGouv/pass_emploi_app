import 'package:collection/collection.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';

abstract class FavoriIdsState<T> {
  FavoriIdsState._();

  factory FavoriIdsState.notInitialized() = FavoriIdsNotInitialized;

  factory FavoriIdsState.success(Set<FavoriDto> favoris) => FavoriIdsSuccessState._(favoris);

  bool contains(String offreId);

  DateTime? datePostulationOf(String offreId);
}

class FavoriIdsSuccessState<T> extends FavoriIdsState<T> {
  final Set<FavoriDto> favoris;

  FavoriIdsSuccessState._(this.favoris) : super._();

  @override
  bool contains(String offreId) => favoris.any((favori) => favori.id == offreId);

  @override
  DateTime? datePostulationOf(String offreId) =>
      favoris.firstWhereOrNull((favori) => favori.id == offreId)?.datePostulation;
}

class FavoriIdsNotInitialized<T> extends FavoriIdsState<T> {
  FavoriIdsNotInitialized() : super._();

  @override
  bool contains(String offreId) => false;

  @override
  DateTime? datePostulationOf(String offreId) => null;
}
