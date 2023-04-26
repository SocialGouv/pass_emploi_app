import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ChoixModeDemoViewModel extends Equatable {
  final bool showMiloModeButton;

  ChoixModeDemoViewModel({required this.showMiloModeButton});

  factory ChoixModeDemoViewModel.create(Store<AppState> store) {
    final isBrsa = store.state.configurationState.configuration?.brand == Brand.brsa;
    return ChoixModeDemoViewModel(
      showMiloModeButton: !isBrsa,
    );
  }

  @override
  List<Object?> get props => [showMiloModeButton];
}
