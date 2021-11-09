import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

enum OffreEmploiListDisplayState { SHOW_CONTENT, SHOW_LOADER, SHOW_ERROR }

class OffreEmploiListPageViewModel {
  final OffreEmploiListDisplayState displayState;
  final List<OffreEmploiItemViewModel> items;
  final Function() onRetry;

  OffreEmploiListPageViewModel._(this.displayState, this.items, this.onRetry);

  factory OffreEmploiListPageViewModel.create(Store<AppState> store) {
    return OffreEmploiListPageViewModel._(
      OffreEmploiListDisplayState.SHOW_CONTENT,
      [
        OffreEmploiItemViewModel(
          "123DXPM",
          "Technicien / Technicienne en froid et climatisation",
          "RH TT INTERIM",
          "MIS",
          "77 - LOGNES",
        ),
        OffreEmploiItemViewModel(
          "123DXPK",
          " #SALONDEMANDELIEU2021: RECEPTIONNISTE TOURNANT (H/F)",
          "STAND CHATEAU DE LA BEGUDE",
          "CDD",
          "06 - OPIO",
        ),
        OffreEmploiItemViewModel(
          "123DXPG",
          "Technicien / Technicienne terrain Structure          (H/F)",
          "GEOTEC",
          "CDI",
          "78 - PLAISIR",
        ),
        OffreEmploiItemViewModel(
          "123DXPF",
          "Responsable de boutique",
          "GINGER",
          "CDD",
          "13 - AIX EN PROVENCE",
        ),
        OffreEmploiItemViewModel(
          "123DXPD",
          "Agent de fabrication polyvalent / Agente de fabrication pol (H/F)",
          "TEMPORIS",
          "MIS",
          "40 - PONTONX SUR L ADOUR",
        )
      ],
      () => null,
    );
  }
}

class OffreEmploiItemViewModel {
  final String id;
  final String title;
  final String companyName;
  final String contractType;
  final String location;

  OffreEmploiItemViewModel(this.id, this.title, this.companyName, this.contractType, this.location);
}
