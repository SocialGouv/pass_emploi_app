import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/favori.dart';

abstract class FavoriListV2State extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriListV2NotInitializedState extends FavoriListV2State {}

class FavoriListV2LoadingState extends FavoriListV2State {}

class FavoriListV2FailureState extends FavoriListV2State {}

class FavoriListV2SuccessState extends FavoriListV2State {
  final List<Favori> results;

  FavoriListV2SuccessState(this.results);

  @override
  List<Object?> get props => [results];
}
