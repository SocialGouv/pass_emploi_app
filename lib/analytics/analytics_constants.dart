class AnalyticsScreenNames {
  AnalyticsScreenNames._();

  static const splash = "splash";
  static const forceUpdate = "force_update";
  static const login = "login";
  static const rendezvousList = "rdv/list";
  static const rendezvousDetails = "rdv/detail";
  static const userActionList = "actions/list";
  static const userActionDetails = "actions/detail";
  static const updateUserAction = "actions/detail?modifySuccess=true";
  static const createUserAction = "actions/create";
  static const chat = "chat";
  static const offreEmploiResearch = "solutions/emploi/search";
  static const offreEmploiResults = "solutions/emploi/search_results";
  static const offreEmploiNoResults = "solutions/emploi/search_no_resuts";
  static const offreEmploiDetails = "solutions/emploi/detail";
  static const offreEmploiFiltres = "solutions/emploi/search_results/filters";
  static const immersionResearch = "solutions/immersion/search";
  static const immersionResults = "solutions/immersion/search_results";
  static const immersionNoResults = "solutions/immersion/search_no_results";
  static const immersionDetails = "solutions/immersion/detail";
  static const serviceCiviqueResearch = "solutions/service_civique/search";
  static const toolbox = "solutions/boite_a_outils";
  static const favoris = "favoris/list/emploi";
  static const plus = "plus";
}


class AnalyticsActionNames {
  AnalyticsActionNames._();

  static const offreEmploiAddFavori = "solutions/emploi/detail?favori=true";
  static const offreEmploiRemoveFavori = "solutions/emploi/detail?favori=false";

  static const deleteUserAction = "actions/list?deleteSuccess=true";
}