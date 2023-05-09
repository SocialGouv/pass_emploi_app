import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/cv_pole_emploi.dart';

abstract class CvState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CvNotInitializedState extends CvState {}

class CvLoadingState extends CvState {}

class CvFailureState extends CvState {}

class CvSuccessState extends CvState {
  final List<CvPoleEmploi>? cvList;

  CvSuccessState(this.cvList);

  @override
  List<Object?> get props => [cvList];
}
