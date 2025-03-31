part of '../create_demarche_form_view_model.dart';

class CreateDemarche2PersonnaliseeStep2ViewModel extends CreateDemarche2ViewModel {
  final String description;
  CreateDemarche2PersonnaliseeStep2ViewModel({this.description = ''});

  static int maxLength = 255;

  @override
  List<Object?> get props => [description];

  CreateDemarche2PersonnaliseeStep2ViewModel copyWith({String? description}) {
    return CreateDemarche2PersonnaliseeStep2ViewModel(description: description ?? this.description);
  }
}
