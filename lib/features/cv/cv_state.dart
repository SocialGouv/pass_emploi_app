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
  final Map<String, CvDownloadStatus> cvDownloadStatus;

  CvSuccessState({required this.cvList, required this.cvDownloadStatus});

  CvSuccessState updateDownloadStatus(String url, CvDownloadStatus status) {
    final updatedData = Map<String, CvDownloadStatus>.from(cvDownloadStatus);
    updatedData.update(url, (value) => status, ifAbsent: () => status);
    return CvSuccessState(cvList: cvList, cvDownloadStatus: updatedData);
  }

  @override
  List<Object?> get props => [cvList, cvDownloadStatus];
}

enum CvDownloadStatus { loading, success, failure }
