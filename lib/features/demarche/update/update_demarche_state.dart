abstract class UpdateDemarcheState {}

class UpdateDemarcheNotInitializedState extends UpdateDemarcheState {}

class UpdateDemarcheLoadingState extends UpdateDemarcheState {}

class UpdateDemarcheSuccessState extends UpdateDemarcheState {}

class UpdateDemarcheFailureState extends UpdateDemarcheState {}