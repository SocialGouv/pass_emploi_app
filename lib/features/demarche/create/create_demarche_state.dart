sealed class CreateDemarcheState {}

class CreateDemarcheNotInitializedState extends CreateDemarcheState {}

class CreateDemarcheLoadingState extends CreateDemarcheState {}

class CreateDemarcheSuccessState extends CreateDemarcheState {
  final String demarcheCreatedId;

  CreateDemarcheSuccessState(this.demarcheCreatedId);
}

class CreateDemarcheFailureState extends CreateDemarcheState {}
