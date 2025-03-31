part of '../create_demarche_form_view_model.dart';

class CreateDemarche2Step1ViewModel extends CreateDemarche2ViewModel {
  final ThematiqueDemarcheItem? selectedThematique;
  CreateDemarche2Step1ViewModel({this.selectedThematique});

  @override
  List<Object?> get props => [selectedThematique];

  CreateDemarche2Step1ViewModel copyWith({ThematiqueDemarcheItem? selectedThematique}) {
    return CreateDemarche2Step1ViewModel(selectedThematique: selectedThematique ?? this.selectedThematique);
  }
}
