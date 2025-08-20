import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/ia_ft_suggestions/ia_ft_suggestions_actions.dart';
import 'package:pass_emploi_app/models/demarche_ia_suggestion.dart';
import 'package:pass_emploi_app/presentation/create_demarche_ia_ft_step_3_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker.dart';

class CreateDemarcheIaFtStep3Page extends StatelessWidget {
  const CreateDemarcheIaFtStep3Page(this.formViewModel);
  final CreateDemarcheFormViewModel formViewModel;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.createDemarcheIaFtStep3,
      child: StoreConnector<AppState, CreateDemarcheIaFtStep3ViewModel>(
        converter: (store) => CreateDemarcheIaFtStep3ViewModel.create(store),
        onInit: (store) =>
            store.dispatch(IaFtSuggestionsRequestAction(query: formViewModel.iaFtStep2ViewModel.description)),
        builder: (context, viewModel) => _Body(
          formViewModel: formViewModel,
          viewModel: viewModel,
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.formViewModel, required this.viewModel});
  final CreateDemarcheFormViewModel formViewModel;
  final CreateDemarcheIaFtStep3ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.loadDisplayState) {
      DisplayState.CONTENT => _Content(
          viewModel,
          formViewModel,
        ),
      DisplayState.FAILURE => _Failure(formViewModel),
      _ => const _Loading(),
    };
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Column(
        children: [
          Image.asset(
            Drawables.iaFtSuggestionsLoading,
            width: 200,
            height: 200,
          ),
          const SizedBox(height: Margins.spacing_base),
          Text(
            Strings.iaFtSuggestionsLoading,
            style: TextStyles.textMBold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Margins.spacing_l),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure(this.viewModel);
  final CreateDemarcheFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            Drawables.iaFtSuggestionsFailure,
            width: 200,
            height: 200,
          ),
          const SizedBox(height: Margins.spacing_m),
          Text(
            Strings.iaFtSuggestionsFailure,
            style: TextStyles.textMBold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Margins.spacing_m),
          PrimaryActionButton(
            onPressed: () => viewModel.navigateToCreateDemarcheIaFtStep2(),
            label: Strings.back,
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty(this.viewModel);
  final CreateDemarcheFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          Drawables.iaFtSuggestionsEmpty,
          width: 200,
          height: 200,
        ),
        const SizedBox(height: Margins.spacing_m),
        Text(
          Strings.iaFtSuggestionsEmpty,
          style: TextStyles.textMBold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Margins.spacing_m),
        PrimaryActionButton(
          onPressed: () => viewModel.navigateToCreateDemarcheIaFtStep2(),
          label: Strings.back,
        ),
      ],
    );
  }
}

class _Content extends StatefulWidget {
  const _Content(this.viewModel, this.formViewModel);
  final CreateDemarcheIaFtStep3ViewModel viewModel;
  final CreateDemarcheFormViewModel formViewModel;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late final DemarcheIaSuggestionsChangeNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = DemarcheIaSuggestionsChangeNotifier(
      suggestions: widget.viewModel.suggestions,
      onSubmit: (actions) => widget.formViewModel.submitDemarcheIaFt(actions),
    );
    notifier.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = notifier.suggestions;
    if (suggestions.isEmpty) {
      return _Empty(widget.formViewModel);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            padding: const EdgeInsets.only(bottom: Margins.spacing_huge),
            child: Column(
              children: [
                if (notifier.error != null) ...[
                  CardContainer(
                    backgroundColor: AppColors.warningLighten,
                    child: Row(
                      children: [
                        Icon(AppIcons.error_rounded, color: AppColors.warning),
                        SizedBox(width: Margins.spacing_s),
                        Expanded(
                          child: Text(notifier.error!, style: TextStyles.textSBold.copyWith(color: AppColors.warning)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Margins.spacing_base),
                ],
                Text(
                  Strings.iaFtSuggestionsContent(suggestions.length),
                  style: TextStyles.textMBold,
                ),
                const SizedBox(height: Margins.spacing_base),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) => _DemarcheIaCard(
                    showError: notifier.error != null && notifier.getDate(suggestions[index].id) == null,
                    suggestion: suggestions[index],
                    date: notifier.getDate(suggestions[index].id),
                    onDateChanged: (id, date) => notifier.updateDate(id, date),
                    onDelete: (id) {
                      notifier.deleteSuggestion(id);
                      PassEmploiMatomoTracker.instance.trackEvent(
                        eventCategory: AnalyticsEventNames.createDemarcheEventCategory,
                        action: AnalyticsEventNames.createDemarcheIaSuggestionsListDeleted,
                        eventValue: 1,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom,
          left: Margins.spacing_base,
          right: Margins.spacing_base,
          child: _SubmitButton(notifier),
        ),
      ],
    );
  }
}

class _DemarcheIaCard extends StatelessWidget {
  const _DemarcheIaCard({
    required this.showError,
    required this.suggestion,
    required this.date,
    required this.onDateChanged,
    required this.onDelete,
  });

  final bool showError;
  final DemarcheIaSuggestion suggestion;
  final DateTime? date;
  final void Function(String id, DateTime? date) onDateChanged;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
        child: BaseCard(
          tag: CardTag(
            icon: AppIcons.work_outline_rounded,
            text: suggestion.label ?? '',
            contentColor: AppColors.primary,
            backgroundColor: AppColors.primaryLighten,
          ),
          iconButton: IconButton(
            onPressed: () => onDelete(suggestion.id),
            icon: Icon(AppIcons.close_rounded, color: AppColors.primary),
          ),
          title: suggestion.titre ?? '',
          body: suggestion.sousTitre ?? '',
          additionalChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Strings.dateShortMandatory, style: TextStyles.textBaseMedium),
              const SizedBox(height: Margins.spacing_s),
              DatePicker(
                errorText: showError ? Strings.dateShortMandatory : null,
                initialDateValue: date,
                isActiveDate: true,
                onDateSelected: (date) => onDateChanged(suggestion.id, date),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton(this.notifier);
  final DemarcheIaSuggestionsChangeNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryActionButton(
        onPressed: () => notifier.submit(),
        label: Strings.iaFtSuggestionsSubmit,
      ),
    );
  }
}

class DemarcheIaSuggestionsChangeNotifier extends ChangeNotifier {
  DemarcheIaSuggestionsChangeNotifier({
    required List<DemarcheIaSuggestion> suggestions,
    required this.onSubmit,
  })  : _suggestions = List.from(suggestions),
        _dates = {for (var s in suggestions) s.id: null};

  final void Function(List<CreateDemarcheRequestAction>) onSubmit;
  final List<DemarcheIaSuggestion> _suggestions;
  final Map<String, DateTime?> _dates;
  String? error;

  List<DemarcheIaSuggestion> get suggestions => List.unmodifiable(_suggestions);

  DateTime? getDate(String id) => _dates[id];

  void updateDate(String id, DateTime? date) {
    if (_dates.containsKey(id)) {
      _dates[id] = date;
      error = null;
      notifyListeners();
    }
  }

  void deleteSuggestion(String id) {
    _suggestions.removeWhere((s) => s.id == id);
    _dates.remove(id);
    error = null;
    notifyListeners();
  }

  void submit() {
    int count = 0;
    for (var suggestion in _suggestions) {
      if (getDate(suggestion.id) == null) {
        count++;
      }
    }
    if (count > 0) {
      error = Strings.iaFtSuggestionsError(count);
      notifyListeners();
      return;
    }

    final List<CreateDemarcheRequestAction> actions = [];
    for (var suggestion in _suggestions) {
      actions.add(
        CreateDemarcheRequestAction(
          codeQuoi: suggestion.codeQuoi,
          codePourquoi: suggestion.codePourquoi,
          // description: suggestion.sousTitre,
          codeComment: null,
          dateEcheance: getDate(suggestion.id)!,
          estDuplicata: false,
        ),
      );
    }
    onSubmit(actions);
  }
}
