import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ChoixModeDemoViewModel extends Equatable {
  final List<LoginMode> demoLoginModes;

  ChoixModeDemoViewModel({required this.demoLoginModes});

  factory ChoixModeDemoViewModel.create(Store<AppState> store) {
    final isCej = store.state.configurationState.configuration?.brand == Brand.cej;
    return ChoixModeDemoViewModel(
      demoLoginModes: [
        LoginMode.DEMO_PE,
        if (isCej) LoginMode.DEMO_MILO,
      ],
    );
  }

  @override
  List<Object?> get props => [demoLoginModes];
}

extension ChoixModeDemoViewModelExt on ChoixModeDemoViewModel {
  bool get shouldDisplayMiloMode => demoLoginModes.contains(LoginMode.DEMO_MILO);
}
