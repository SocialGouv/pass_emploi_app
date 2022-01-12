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

  static const emploiResearch = "recherche/emploi/search";
  static const emploiResults = "recherche/emploi/search_results";
  static const emploiNoResults = "recherche/emploi/search_no_results";
  static const emploiDetails = "recherche/emploi/detail";
  static const emploiFiltres = "recherche/emploi/search_results/filters";

  static const alternanceResearch = "recherche/alternance/search";
  static const alternanceResults = "recherche/alternance/search_results";
  static const alternanceNoResults = "recherche/alternance/search_no_results";
  static const alternanceDetails = "recherche/alternance/detail";
  static const alternanceFiltres = "recherche/alternance/search_results/filters";

  static const immersionResearch = "recherche/immersion/search";
  static const immersionResults = "recherche/immersion/search_results";
  static const immersionNoResults = "recherche/immersion/search_no_results";
  static const immersionDetails = "recherche/immersion/detail";

  static const serviceCiviqueResearch = "recherche/service_civique/search";

  static const toolbox = "recherche/boite_a_outils";
  static const emploiFavoris = "favoris/list/emploi";
  static const alternanceFavoris = "favoris/list/alternance";
  static const plus = "plus";
}

class AnalyticsActionNames {
  AnalyticsActionNames._();

  static const emploiResultAddFavori = "recherche/emploi/search_results?favori=true";
  static const emploiResultRemoveFavori = "recherche/emploi/search_results?favori=false";
  static const emploiDetailsAddFavori = "recherche/emploi/detail?favori=true";
  static const emploiDetailsRemoveFavori = "recherche/emploi/detail?favori=false";
  static const emploiFavoriRemoveFavori = "favoris/list/emploi?favori=false";

  static const alternanceResultAddFavori = "recherche/alternance/search_results?favori=true";
  static const alternanceResultRemoveFavori = "recherche/alternance/search_results?favori=false";
  static const alternanceDetailsAddFavori = "recherche/alternance/detail?favori=true";
  static const alternanceDetailsRemoveFavori = "recherche/alternance/detail?favori=false";
  static const alternanceFavoriRemoveFavori = "favoris/list/alternance?favori=false";

  static const deleteUserAction = "actions/list?deleteSuccess=true";
}