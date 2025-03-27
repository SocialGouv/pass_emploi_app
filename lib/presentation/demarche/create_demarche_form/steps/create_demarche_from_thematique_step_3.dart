part of '../create_demarche_form_view_model.dart';

class CreateDemarche2FromThematiqueStep3ViewModel extends CreateDemarche2ViewModel {
  final bool valid;
  CreateDemarche2FromThematiqueStep3ViewModel({this.valid = true});

  @override
  bool get isValid => valid;

  @override
  List<Object?> get props => [valid];
}
