import 'package:equatable/equatable.dart';

abstract class CreateDemarcheState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateDemarcheNotInitializedState extends CreateDemarcheState {}

class CreateDemarcheLoadingState extends CreateDemarcheState {}

class CreateDemarcheSuccessState extends CreateDemarcheState {}

class CreateDemarcheFailureState extends CreateDemarcheState {}
