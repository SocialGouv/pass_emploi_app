import 'package:pass_emploi_app/models/date/interval.dart';

String? getDemoFileName(String url, String query) {
  if (url.contains('/milo/accueil')) return 'accueil_mission_locale';
  if (url.contains('/pole-emploi/accueil')) return 'accueil_pole_emploi';
  if (url.contains('/home/agenda/pole-emploi')) return 'home_agenda_pole_emploi';
  if (url.contains('/home/agenda')) return 'home_agenda_mission_locale';
  if (url.endsWith('/home/demarches')) return 'home_demarches';
  if (url.endsWith('/home/actions')) return 'home_actions';
  if (url.endsWith('/favoris/offres-immersion')) return 'favoris_ids_immersion';
  if (url.endsWith('/favoris/offres-emploi')) return 'favoris_ids_offres_emploi';
  if (url.endsWith('/favoris/services-civique')) return 'favoris_ids_service_civique';
  if (url.endsWith('/rendezvous')) return 'rendez_vous_list';
  if (url.endsWith('/recherches')) return 'alertes';
  if (url.endsWith('/offres-emploi') && query.contains('alternance=true')) return 'alternance_list';
  if (url.endsWith('/offres-emploi')) return 'offres_emploi_list';
  if (url.endsWith('alternance_detail')) return 'alternance_detail';
  if (url.endsWith('/offres-immersion')) return 'offres_immersion_list';
  if (url.endsWith('/services-civique')) return 'offres_services_civique';
  if (url.endsWith('/preferences')) return 'preferences';
  if (url.endsWith('/referentiels/pole-emploi/types-demarches')) return 'referentiel_demarches';
  if (url.endsWith('/commentaires')) return 'commentaires';
  if (url.endsWith('/favoris')) return 'favoris';
  if (url.endsWith('/mon-suivi') && _queryIntervalContainsNow(query)) return 'mon_suivi_mission_locale_maintenant';
  if (url.endsWith('/mon-suivi')) return 'mon_suivi_mission_locale_autre_periode';
  if (url.contains('recherches/suggestions')) return 'suggestions_recherche';
  if (url.removeLastPath().endsWith('/services-civique')) return 'service_civique_detail';
  if (url.removeLastPath().endsWith('/offres-immersion')) return 'immersion_detail';
  if (url.removeLastPath().endsWith('/offres-emploi')) return 'offre_emploi_detail';
  if (url.removeLastPath().endsWith('/jeunes')) return 'jeune_detail';
  if (url.removeLastPath().endsWith('/rendezvous')) return 'rendez_vous_detail';
  if (url.contains('/animations-collectives')) return 'event_list';
  if (url.endsWith('/sessions')) return 'session_milo_list';
  if (url.contains('/diagoriente/urls')) return 'diagoriente_urls';
  if (url.contains('/diagoriente/metiers-favoris')) return 'diagoriente_metiers_favoris';
  if (url.contains('/pole-emploi/cv')) return 'cv_pole_emploi';
  if (url.endsWith('/evenements-emploi')) return 'recherche_evenements_emploi';
  if (url.contains('/evenements-emploi/')) return 'evenement_emploi_details';
  if (url.contains('/catalogue')) return 'thematiques_demarche';
  if (url.contains('/sessions/')) return 'session_milo_details';

  return null;
}

bool _queryIntervalContainsNow(String query) {
  final interval = Interval(
    DateTime.parse(query.split('debut=')[1].substring(0, 10)),
    DateTime.parse(query.split('fin=')[1].substring(0, 10)),
  );
  return interval.contains(DateTime.now());
}

extension UrlExtensions on String {
  bool isSupposedToBeMocked() {
    return !contains('referentiels/communes-et-departements') &&
        !contains('fichiers') &&
        !contains('referentiels/metiers') &&
        !contains('/docnums/');
  }

  String removeLastPath() => substring(0, lastIndexOf('/'));
}
