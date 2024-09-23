import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class EmailObjectViewModel extends Equatable {
  final String contactEmailObject;
  final String ratingEmailObject;

  EmailObjectViewModel({
    required this.contactEmailObject,
    required this.ratingEmailObject,
  });

  factory EmailObjectViewModel.create(Store<AppState> store) {
    final user = store.state.user();
    if (user == null) return EmailObjectViewModel(contactEmailObject: '', ratingEmailObject: '');

    final brand = store.state.configurationState.getBrand();
    return EmailObjectViewModel(
      contactEmailObject: _emailSubject(user, brand),
      ratingEmailObject: _ratingSubject(user, brand),
    );
  }

  @override
  List<Object?> get props => [contactEmailObject, ratingEmailObject];
}

String _emailSubject(User user, Brand brand) {
  return "${user.emailObjectPrefix()} - ${Strings.objetPriseDeContact(brand)}";
}

String _ratingSubject(User user, Brand brand) {
  return "${user.emailObjectPrefix()} - ${Strings.ratingEmailObject(brand)}";
}

extension on User {
  String emailObjectPrefix() {
    return switch (accompagnement) {
      Accompagnement.cej => switch (loginMode) {
          LoginMode.MILO => Strings.milo,
          LoginMode.POLE_EMPLOI => Strings.poleEmploi,
          _ => '',
        },
      Accompagnement.rsaFranceTravail => '${Strings.poleEmploi} - RSA',
      Accompagnement.aij => '${Strings.poleEmploi} - AIJ',
    };
  }
}
