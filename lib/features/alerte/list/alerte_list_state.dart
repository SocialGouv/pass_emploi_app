import 'package:pass_emploi_app/models/alerte/alerte.dart';

abstract class AlerteListState {}

class AlerteListNotInitializedState extends AlerteListState {}

class AlerteListLoadingState extends AlerteListState {}

class AlerteListSuccessState extends AlerteListState {
  final List<Alerte> alertes;

  AlerteListSuccessState(this.alertes);
}

class AlerteListFailureState extends AlerteListState {}
