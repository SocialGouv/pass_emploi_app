import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';

abstract class DetailsJeuneState extends Equatable {
  @override
  List<Object> get props => [];

  DetailsJeune? get detailsJeuneOrNull => switch (this) {
        DetailsJeuneSuccessState(:final detailsJeune) => detailsJeune,
        _ => null,
      };
}

class DetailsJeuneNotInitializedState extends DetailsJeuneState {}

class DetailsJeuneLoadingState extends DetailsJeuneState {}

class DetailsJeuneSuccessState extends DetailsJeuneState {
  final DetailsJeune detailsJeune;

  DetailsJeuneSuccessState({required this.detailsJeune});

  @override
  List<Object> get props => [detailsJeune];
}

class DetailsJeuneFailureState extends DetailsJeuneState {}
