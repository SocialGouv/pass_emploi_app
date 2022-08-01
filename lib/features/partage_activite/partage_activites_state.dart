import 'package:pass_emploi_app/models/partage_activite.dart';

abstract class PartageActiviteState {}

class PartageActiviteNotInitializedState extends PartageActiviteState {}

class PartageActiviteLoadingState extends PartageActiviteState {}

class PartageActiviteSuccessState extends PartageActiviteState {
  final PartageActivite preferences;

  PartageActiviteSuccessState(this.preferences);
}

class PartageActiviteFailureState extends PartageActiviteState {}
