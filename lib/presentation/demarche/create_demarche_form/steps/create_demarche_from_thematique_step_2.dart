part of '../create_demarche_form_view_model.dart';

class CreateDemarche2FromThematiqueStep2ViewModel extends CreateDemarche2ViewModel {
  final DemarcheDuReferentielCardViewModel? selectedDemarcheVm;
  CreateDemarche2FromThematiqueStep2ViewModel({this.selectedDemarcheVm});

  @override
  List<Object?> get props => [selectedDemarcheVm];

  CreateDemarche2FromThematiqueStep2ViewModel copyWith({
    DemarcheDuReferentielCardViewModel? demarcheCardViewModel,
  }) {
    return CreateDemarche2FromThematiqueStep2ViewModel(
      selectedDemarcheVm: demarcheCardViewModel ?? selectedDemarcheVm,
    );
  }
}
