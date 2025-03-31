part of '../create_demarche_form_view_model.dart';

class CreateDemarche2PersonnaliseeStep3ViewModel extends CreateDemarche2ViewModel {
  final DateInputSource dateSource;
  CreateDemarche2PersonnaliseeStep3ViewModel({DateInputSource? initialDateInput})
      : dateSource = initialDateInput ?? DateNotInitialized();

  @override
  List<Object?> get props => [dateSource];

  CreateDemarche2PersonnaliseeStep3ViewModel copyWith({DateInputSource? dateSource}) {
    return CreateDemarche2PersonnaliseeStep3ViewModel(initialDateInput: dateSource ?? this.dateSource);
  }
}
