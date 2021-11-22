class AnalyticsScreenNames {
  AnalyticsScreenNames._();

  static const splash = "splash";
  static const forceUpdate = "force_update";
  static const login = "login";
  static const home = "home";
  static const rendezvousList = "rendezvous_list";
  static const rendezvousDetails = "rendezvous_details";
  static const userActionList = "actions_list";
  static const userActionDetails = "action_details";
  static const createUserAction = "create_action";
  static const chat = "chat";
  static const offreEmploiResearch = "recherche_offres_list";
  static const offreEmploiResults = "resultats_offres_emploi";

  static const offresEmploi = "resultats_offres";
  static const detailsOffreEmploi = "offre_details";
}

abstract class AnalyticsRouteSettings {
  static RouteSettings splash() => RouteSettings(name: AnalyticsScreenNames.splash);

  static RouteSettings login() => RouteSettings(name: AnalyticsScreenNames.login);

  static RouteSettings main() => RouteSettings(name: AnalyticsScreenNames.main);

  static RouteSettings home() => RouteSettings(name: AnalyticsScreenNames.home);

  static RouteSettings rendezvous() => RouteSettings(name: AnalyticsScreenNames.rendezvous);

  static RouteSettings userAction() => RouteSettings(name: AnalyticsScreenNames.userAction);

  static RouteSettings userActionDetails() => RouteSettings(name: AnalyticsScreenNames.userActionDetails);

  static RouteSettings createUserAction() => RouteSettings(name: AnalyticsScreenNames.createUserAction);

  static RouteSettings chat() => RouteSettings(name: AnalyticsScreenNames.chat);

  static RouteSettings offreEmploiList() => RouteSettings(name: AnalyticsScreenNames.offresEmploi);

  static RouteSettings detailsOffreEmploi() => RouteSettings(name: AnalyticsScreenNames.detailsOffreEmploi);
}
