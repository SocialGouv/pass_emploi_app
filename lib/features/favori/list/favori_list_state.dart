import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/favori.dart';

abstract class FavoriListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriListNotInitializedState extends FavoriListState {}

class FavoriListLoadingState extends FavoriListState {}

class FavoriListFailureState extends FavoriListState {}

class FavoriListSuccessState extends FavoriListState {
  final List<Favori> results;

  FavoriListSuccessState(this.results);

  @override
  List<Object?> get props => [results];
}
