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
  static const offreEmploiResearch = "recherche/emploi/search";
  static const offreEmploiResults = "recherche/emploi/search_results";
  static const offreEmploiNoResults = "recherche/emploi/search_no_resuts";
  static const offreEmploiDetails = "recherche/emploi/detail";
  static const offreEmploiFiltres = "recherche/emploi/search_results/filters";
  static const immersionResearch = "recherche/immersion/search";
  static const immersionResults = "recherche/immersion/search_results";
  static const immersionNoResults = "recherche/immersion/search_no_results";
  static const immersionDetails = "recherche/immersion/detail";
  static const serviceCiviqueResearch = "recherche/service_civique/search";
  static const toolbox = "recherche/boite_a_outils";
  static const favoris = "favoris/list/emploi";
  static const plus = "plus";
}


class AnalyticsActionNames {
  AnalyticsActionNames._();

  static const offreEmploiAddFavori = "recherche/emploi/detail?favori=true";
  static const offreEmploiRemoveFavori = "recherche/emploi/detail?favori=false";

  static const deleteUserAction = "actions/list?deleteSuccess=true";
}