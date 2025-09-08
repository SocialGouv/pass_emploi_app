part of '../create_demarche_form_view_model.dart';

class CreateDemarcheIaFtStep2ViewModel extends CreateDemarcheViewModel {
  CreateDemarcheIaFtStep2ViewModel({this.description = ''});
  final String description;

  static int maxLength = 1000;

  @override
  List<Object?> get props => [description];

  CreateDemarcheIaFtStep2ViewModel copyWith({String? description}) {
    return CreateDemarcheIaFtStep2ViewModel(description: description ?? this.description);
  }
}
