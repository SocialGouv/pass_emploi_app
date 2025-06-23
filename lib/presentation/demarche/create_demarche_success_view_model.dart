import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche/create_demarche_success_page.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class CreateDemarcheSuccessViewModel extends Equatable {
  final String? demarcheId;
  final String demarcheSuccessTitle;
  final String demarcheSuccessSubtitle;

  CreateDemarcheSuccessViewModel({
    required this.demarcheId,
    required this.demarcheSuccessTitle,
    required this.demarcheSuccessSubtitle,
  });

  factory CreateDemarcheSuccessViewModel.create(Store<AppState> store, CreateDemarcheSource source) {
    return CreateDemarcheSuccessViewModel(
      demarcheId: _demarcheId(store, source),
      demarcheSuccessTitle: switch (source) {
        CreateDemarcheSource.iaFt => Strings.demarcheSuccessTitlePlural,
        _ => Strings.demarcheSuccessTitle,
      },
      demarcheSuccessSubtitle: switch (source) {
        CreateDemarcheSource.iaFt => Strings.demarcheSuccessSubtitlePlural,
        _ => Strings.demarcheSuccessSubtitle,
      },
    );
  }

  @override
  List<Object?> get props => [demarcheId];
}

String? _demarcheId(Store<AppState> store, CreateDemarcheSource source) {
  if (source == CreateDemarcheSource.iaFt) {
    return null;
  } else {
    final createState = store.state.createDemarcheState;
    return createState is CreateDemarcheSuccessState ? createState.demarcheCreatedId : "";
  }
}
