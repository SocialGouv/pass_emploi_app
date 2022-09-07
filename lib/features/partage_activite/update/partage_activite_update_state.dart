abstract class PartageActiviteUpdateState {}

class PartageActiviteUpdateNotInitializedState extends PartageActiviteUpdateState {}

class PartageActiviteUpdateLoadingState extends PartageActiviteUpdateState {}

class PartageActiviteUpdateSuccessState extends PartageActiviteUpdateState {
  final bool favorisShared;

  PartageActiviteUpdateSuccessState(this.favorisShared);
}

class PartageActiviteUpdateFailureState extends PartageActiviteUpdateState {}
