import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/ignore_tracking_context_provider.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/presentation/autocomplete/metier_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/debounce_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/full_screen_text_form_field_scaffold.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/multiline_app_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/read_only_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/text_form_field_sep_line.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/title_tile.dart';

const _heroTag = 'metier';

class MetierAutocomplete extends StatefulWidget {
  final String title;
  final String? hint;
  final Function(Metier? location) onMetierSelected;
  final Metier? initialValue;

  const MetierAutocomplete({
    required this.title,
    this.hint,
    required this.onMetierSelected,
    this.initialValue,
  });

  @override
  State<MetierAutocomplete> createState() => _MetierAutocompleteState();
}

class _MetierAutocompleteState extends State<MetierAutocomplete> {
  Metier? _selectedMetier;

  @override
  void initState() {
    _selectedMetier = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReadOnlyTextFormField(
      title: widget.title,
      hint: widget.hint,
      a11ySuppressionLabel: Strings.a11YMetierSuppressionLabel,
      a11yLabel: Strings.a11YMetierLabel,
      heroTag: _heroTag,
      textFormFieldKey: Key(_selectedMetier.toString()),
      withDeleteButton: _selectedMetier != null,
      onTextTap: () => Navigator.push(
        IgnoreTrackingContext.of(context).nonTrackingContext,
        _MetierAutocompletePage.materialPageRoute(
          title: widget.title,
          hint: widget.hint,
          selectedMetier: _selectedMetier,
        ),
      ).then((metier) => _updateMetier(metier)),
      onDeleteTap: () => _updateMetier(null),
      initialValue: _selectedMetier?.libelle,
    );
  }

  void _updateMetier(Metier? metier) {
    setState(() => _selectedMetier = metier);
    widget.onMetierSelected(metier);
  }
}

class _MetierAutocompletePage extends StatefulWidget {
  final String title;
  final String? hint;
  final Metier? selectedMetier;

  _MetierAutocompletePage({required this.title, required this.hint, this.selectedMetier});

  static MaterialPageRoute<Metier?> materialPageRoute({
    required String title,
    required String? hint,
    required Metier? selectedMetier,
  }) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => _MetierAutocompletePage(
        title: title,
        hint: hint,
        selectedMetier: selectedMetier,
      ),
    );
  }

  @override
  State<_MetierAutocompletePage> createState() => _MetierAutocompletePageState();
}

class _MetierAutocompletePageState extends State<_MetierAutocompletePage> {
  bool emptyInput = true;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MetierViewModel>(
      onInit: (store) => store.dispatch(DiagorientePreferencesMetierRequestAction()),
      onInitialBuild: _onInitialBuild,
      converter: (store) => MetierViewModel.create(store),
      onDispose: (store) => store.dispatch(SearchMetierResetAction()),
      builder: _builder,
      distinct: true,
    );
  }

  void _onInitialBuild(MetierViewModel viewModel) {
    if (viewModel.containsMetiersRecents) {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.lastRechercheMetierEventCategory,
        action: AnalyticsEventNames.lastRechercheMetierDisplayAction,
      );
    }
    if (viewModel.containsDiagorienteFavoris) {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.autocompleteMetierDiagorienteMetiersFavorisEventCategory,
        action: AnalyticsEventNames.autocompleteMetierDiagorienteMetiersFavorisDisplayAction,
      );
    }

    viewModel.onInputMetier(widget.selectedMetier?.libelle);
  }

  Widget _builder(BuildContext context, MetierViewModel viewModel) {
    final autocompleteItems = viewModel.getAutocompleteItems(emptyInput);
    return FullScreenTextFormFieldScaffold(
      body: Column(
        children: [
          MultilineAppBar(
            title: widget.title,
            hint: widget.hint,
            onCloseButtonPressed: () => Navigator.pop(context, widget.selectedMetier),
          ),
          Semantics(
            label: '${widget.title} ${Strings.a11YMetiersExplanationLabel}',
            child: DebounceTextFormField(
              heroTag: _heroTag,
              initialValue: widget.selectedMetier?.libelle,
              onChanged: (text) {
                if (text.isEmpty != emptyInput) setState(() => emptyInput = text.isEmpty);
                viewModel.onInputMetier(text);
              },
            ),
          ),
          TextFormFieldSepLine(),
          Expanded(
            child: ListView.separated(
              itemCount: autocompleteItems.length,
              separatorBuilder: (context, index) => TextFormFieldSepLine(),
              itemBuilder: (context, index) {
                final item = autocompleteItems[index];
                if (item is MetierTitleItem) return TitleTile(title: item.title);
                if (item is MetierSuggestionItem) {
                  return _MetierListTile(
                    metier: item.metier,
                    source: item.source,
                    onMetierTap: (metier) => Navigator.pop(context, metier),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MetierListTile extends StatelessWidget {
  final Metier metier;
  final MetierSource source;
  final Function(Metier) onMetierTap;

  const _MetierListTile({required this.metier, required this.source, required this.onMetierTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Margins.spacing_l),
        title: Row(
          children: [
            Icon(
              source == MetierSource.dernieresRecherches ? AppIcons.schedule_rounded : AppIcons.bolt_rounded,
              size: Dimens.icon_size_base,
              color: AppColors.grey800,
            ),
            SizedBox(width: Margins.spacing_s),
            Expanded(child: Text(metier.libelle, style: TextStyles.textBaseRegular)),
          ],
        ),
        onTap: () {
          if (source == MetierSource.dernieresRecherches) {
            PassEmploiMatomoTracker.instance.trackEvent(
              eventCategory: AnalyticsEventNames.lastRechercheMetierEventCategory,
              action: AnalyticsEventNames.lastRechercheMetierClickAction,
            );
          }
          if (source == MetierSource.diagorienteMetiersFavoris) {
            PassEmploiMatomoTracker.instance.trackEvent(
              eventCategory: AnalyticsEventNames.autocompleteMetierDiagorienteMetiersFavorisEventCategory,
              action: AnalyticsEventNames.autocompleteMetierDiagorienteMetiersFavorisClickAction,
            );
          }
          onMetierTap(metier);
        },
      ),
    );
  }
}
