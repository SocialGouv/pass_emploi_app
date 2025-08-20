import 'package:collection/collection.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/ia_ft_suggestions/ia_ft_suggestions_actions.dart';
import 'package:pass_emploi_app/models/demarche_ia_dto.dart';
import 'package:pass_emploi_app/models/demarche_ia_suggestion.dart';
import 'package:pass_emploi_app/models/matching_demarche_du_referentiel.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/ia_ft_suggestions_repository.dart';
import 'package:pass_emploi_app/repositories/matching_demarche_repository.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

class IaFtSuggestionsMiddleware extends MiddlewareClass<AppState> {
  final IaFtSuggestionsRepository _iaFtRepository;
  final MatchingDemarcheRepository _matchingDemarcheRepository;

  IaFtSuggestionsMiddleware(
    this._iaFtRepository,
    this._matchingDemarcheRepository,
  );

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is IaFtSuggestionsRequestAction) {
      store.dispatch(IaFtSuggestionsLoadingAction());
      final demarchesSuggestionsRaw = await _iaFtRepository.get(userId, action.query);
      if (demarchesSuggestionsRaw != null) {
        final List<(DemarcheIaDto, MatchingDemarcheDuReferentiel?)> matchingDemarcheDuReferentiel = [];
        for (final raw in demarchesSuggestionsRaw) {
          final matchingDemarche =
              await _matchingDemarcheRepository.getMatchingDemarcheDuReferentielFromCode(codeQuoi: raw.codeQuoi);
          matchingDemarcheDuReferentiel.add((raw, matchingDemarche));
        }

        final demarchesSuggestions = matchingDemarcheDuReferentiel
            .map((doubleEntry) => DemarcheIaSuggestion(
                  id: Uuid().v4(),
                  label: doubleEntry.$2?.thematique.libelle,
                  titre: doubleEntry.$2?.demarcheDuReferentiel.quoi,
                  sousTitre: doubleEntry.$1.description,
                  codeQuoi: doubleEntry.$1.codeQuoi,
                  codePourquoi: doubleEntry.$1.codePourquoi,
                ))
            .whereNotNull()
            .toList();

        store.dispatch(IaFtSuggestionsSuccessAction(demarchesSuggestions));
        PassEmploiMatomoTracker.instance.trackEvent(
          eventCategory: AnalyticsEventNames.createDemarcheEventCategory,
          action: AnalyticsEventNames.createDemarcheIaSuggestionsListCount,
          eventValue: demarchesSuggestionsRaw.length,
        );
      } else {
        store.dispatch(IaFtSuggestionsFailureAction());
      }
    }
  }
}
