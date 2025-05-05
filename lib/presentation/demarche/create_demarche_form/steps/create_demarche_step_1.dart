part of '../create_demarche_form_view_model.dart';

class CreateDemarcheStep1ViewModel extends CreateDemarcheViewModel {
  final ThematiqueDemarcheItem? selectedThematique;
  CreateDemarcheStep1ViewModel({this.selectedThematique});

  @override
  List<Object?> get props => [selectedThematique];

  CreateDemarcheStep1ViewModel copyWith({ThematiqueDemarcheItem? selectedThematique}) {
    return CreateDemarcheStep1ViewModel(selectedThematique: selectedThematique ?? this.selectedThematique);
  }
}
