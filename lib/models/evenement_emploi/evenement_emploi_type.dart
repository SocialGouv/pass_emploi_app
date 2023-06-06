import 'package:pass_emploi_app/ui/strings.dart';

enum EvenementEmploiType {
  reunionInformation(Strings.evenementEmploiTypeReunionInformation),
  forum(Strings.evenementEmploiTypeForum),
  conference(Strings.evenementEmploiTypeConference),
  atelier(Strings.evenementEmploiTypeAtelier),
  salonEnLigne(Strings.evenementEmploiTypeSalonEnLigne),
  jobDating(Strings.evenementEmploiTypeJobDating),
  visiteEntreprise(Strings.evenementEmploiTypeVisiteEntreprise),
  portesOuvertes(Strings.evenementEmploiTypePortesOuvertes);

  const EvenementEmploiType(this.label);

  final String label;
}
