import 'package:pass_emploi_app/ui/strings.dart';

enum SecteurActivite {
  agriculture(Strings.secteurActiviteAgriculture),
  art(Strings.secteurActiviteArt),
  banque(Strings.secteurActiviteBanque),
  commerce(Strings.secteurActiviteCommerce),
  communication(Strings.secteurActiviteCommunication),
  batiment(Strings.secteurActiviteBatiment),
  tourisme(Strings.secteurActiviteTourisme),
  industrie(Strings.secteurActiviteIndustrie),
  installation(Strings.secteurActiviteInstallation),
  sante(Strings.secteurActiviteSante),
  services(Strings.secteurActiviteServices),
  spectacle(Strings.secteurActiviteSpectacle),
  support(Strings.secteurActiviteSupport),
  transport(Strings.secteurActiviteTransport);

  const SecteurActivite(this.label);

  final String label;
}
