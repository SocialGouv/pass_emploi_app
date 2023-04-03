import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/accueil/accueil.dart';

abstract class AccueilState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccueilNotInitializedState extends AccueilState {}

class AccueilLoadingState extends AccueilState {}

class AccueilFailureState extends AccueilState {}

class AccueilSuccessState extends AccueilState {
  final Accueil accueil;

  AccueilSuccessState(this.accueil);

  @override
  List<Object?> get props => [accueil];
}
