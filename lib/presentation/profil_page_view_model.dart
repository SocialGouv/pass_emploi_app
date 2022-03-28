import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/conseiller/conseiller_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class ProfilPageViewModel extends Equatable {
  final String userName;
  final String userEmail;

  ProfilPageViewModel({required this.userName, required this.userEmail});

  factory ProfilPageViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    final user = state is LoginSuccessState ? state.user : null;
    return ProfilPageViewModel(
      userName: user != null ? "${user.firstName} ${user.lastName}" : "",
      userEmail: user?.email ?? Strings.missingEmailAddressValue,
    );
  }

  @override
  List<Object?> get props => [userName, userEmail];
}

class ConseillerProfilePageViewModel extends Equatable {
  final ConseillerProfilePageViewModelDisplayState displayState;

  ConseillerProfilePageViewModel({required this.displayState});

  factory ConseillerProfilePageViewModel.create(Store<AppState> store) {
    final state = store.state.conseillerState;
    if (state is ConseillerSuccessState) {
      return ConseillerProfilePageViewModel(
        displayState: ConseillerProfilePageViewModelDisplayStateContent(
          sinceDate: Strings.sinceDate(state.conseillerInfo.sinceDate),
          name: "${state.conseillerInfo.firstname} ${state.conseillerInfo.lastname}",
        ),
      );
    } else if (state is ConseillerLoadingState) {
      return ConseillerProfilePageViewModel(displayState: ConseillerProfilePageViewModelDisplayStateLoading());
    }
    return ConseillerProfilePageViewModel(displayState: ConseillerProfilePageViewModelDisplayStateHidden());
  }

  @override
  List<Object?> get props => [displayState];
}

class ConseillerProfilePageViewModelDisplayState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConseillerProfilePageViewModelDisplayStateLoading extends ConseillerProfilePageViewModelDisplayState {}

class ConseillerProfilePageViewModelDisplayStateHidden extends ConseillerProfilePageViewModelDisplayState {}

class ConseillerProfilePageViewModelDisplayStateContent extends ConseillerProfilePageViewModelDisplayState {
  final String sinceDate;
  final String name;

  ConseillerProfilePageViewModelDisplayStateContent({required this.sinceDate, required this.name});

  @override
  List<Object?> get props => [sinceDate, name];
}