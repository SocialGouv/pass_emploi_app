class AnalyticsScreenNames {
  AnalyticsScreenNames._();

  static const splash = "splash";
  static const forceUpdate = "force_update";
  static const entree = "entree";
  static const choixOrganisme = "entree/choix-organisme";
  static const choixOrganismePE = "entree/choix-organisme/pe";
  static const choixOrganismeMilo = "entree/choix-organisme/milo";
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
  static const immersionFavoris = "favoris/list/immersion";
  static const plus = "plus";
}

class AnalyticsActionNames {
  AnalyticsActionNames._();

  static String emploiResultUpdateFavori(bool added) => "recherche/emploi/search_results?favori=$added";

  static String emploiDetailUpdateFavori(bool added) => "recherche/emploi/detail?favori=$added";

  static String? emploiFavoriUpdateFavori(bool added) => added ? null : "favoris/list/emploi?favori=false";

  static String alternanceResultUpdateFavori(bool added) => "recherche/alternance/search_results?favori=$added";

  static String alternanceDetailUpdateFavori(bool added) => "recherche/alternance/detail?favori=$added";

  static String? alternanceFavoriUpdateFavori(bool added) => added ? null : "favoris/list/alternance?favori=false";

  static String immersionResultUpdateFavori(bool added) => "/solutions/immersion/search_results?favori=$added";

  static String immersionDetailUpdateFavori(bool added) => "/solutions/immersion/detail?favori=$added";

  static String immersionFavoriUpdateFavori(bool added) => "/favoris/list/immersion?favori=$added";

  static const deleteUserAction = "actions/list?deleteSuccess=true";
}
