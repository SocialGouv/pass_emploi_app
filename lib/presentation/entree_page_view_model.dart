import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class EntreePageViewModel extends Equatable {
  final bool withRequestAccountButton;

  EntreePageViewModel({required this.withRequestAccountButton});

  factory EntreePageViewModel.create(Store<AppState> store) {
    final brand = store.state.configurationState.getBrand();
    return EntreePageViewModel(
      withRequestAccountButton: brand.isCej,
    );
  }

  @override
  List<Object?> get props => [withRequestAccountButton];
}
