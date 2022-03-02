import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';

abstract class ImmersionDetailsState {}

class ImmersionDetailsNotInitializedState extends ImmersionDetailsState {}

class ImmersionDetailsLoadingState extends ImmersionDetailsState {}

class ImmersionDetailsIncompleteDataState extends ImmersionDetailsState {
  final Immersion immersion;

  ImmersionDetailsIncompleteDataState(this.immersion);
}

class ImmersionDetailsSuccessState extends ImmersionDetailsState {
  final ImmersionDetails immersion;

  ImmersionDetailsSuccessState(this.immersion);
}

class ImmersionDetailsFailureState extends ImmersionDetailsState {}
