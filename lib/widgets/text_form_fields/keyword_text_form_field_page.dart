import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/presentation/mots_cles_view_model.dart';
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
import 'package:pass_emploi_app/widgets/text_form_fields/utils/text_form_field_sep_line.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/title_tile.dart';

class KeywordTextFormFieldPage extends StatelessWidget {
  final String title;
  final String hint;
  final String? selectedKeyword;
  final String heroTag;

  KeywordTextFormFieldPage({required this.title, required this.hint, this.selectedKeyword, required this.heroTag});

  static MaterialPageRoute<String?> materialPageRoute({
    required String title,
    required String hint,
    required String? selectedKeyword,
    required final String heroTag,
  }) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => KeywordTextFormFieldPage(
        title: title,
        hint: hint,
        selectedKeyword: selectedKeyword,
        heroTag: heroTag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FullScreenTextFormFieldScaffold(
      body: StoreConnector<AppState, MotsClesViewModel>(
        onInit: (store) => store.dispatch(DiagorientePreferencesMetierRequestAction()),
        onInitialBuild: _onInitialBuild,
        converter: (store) => MotsClesViewModel.create(store),
        builder: (context, viewModel) {
          return _Body(
            viewModel: viewModel,
            title: title,
            hint: hint,
            selectedKeyword: selectedKeyword,
            heroTag: heroTag,
          );
        },
        distinct: true,
      ),
    );
  }

  void _onInitialBuild(MotsClesViewModel viewModel) {
    if (viewModel.containsMotsClesRecents) {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.lastRechercheMotsClesEventCategory,
        action: AnalyticsEventNames.lastRechercheMotsClesDisplayAction,
      );
    }
    if (viewModel.containsDiagorienteFavoris) {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.autocompleteMotCleDiagorienteMetiersFavorisEventCategory,
        action: AnalyticsEventNames.autocompleteMotCleDiagorienteMetiersFavorisDisplayAction,
      );
    }
  }
}

class _Body extends StatefulWidget {
  final MotsClesViewModel viewModel;
  final String title;
  final String hint;
  final String? selectedKeyword;
  final String heroTag;

  const _Body({
    required this.viewModel,
    required this.title,
    required this.hint,
    required this.selectedKeyword,
    required this.heroTag,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool emptyInput = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MultilineAppBar(
          title: widget.title,
          hint: widget.hint,
          onCloseButtonPressed: () => Navigator.pop(context, widget.selectedKeyword),
        ),
        Semantics(
          label: '${widget.title} ${Strings.a11YKeywordExplanationLabel}',
          child: DebounceTextFormField(
            heroTag: widget.heroTag,
            initialValue: widget.selectedKeyword,
            onChanged: (text) {
              if (text.isEmpty != emptyInput) setState(() => emptyInput = text.isEmpty);
            },
            onFieldSubmitted: (keyword) => Navigator.pop(context, keyword),
          ),
        ),
        TextFormFieldSepLine(),
        if (emptyInput)
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final item = widget.viewModel.motsCles[index];
                if (item is MotsClesTitleItem) return TitleTile(title: item.title);
                if (item is MotsClesSuggestionItem) {
                  return _MotCleListTile(
                    motCle: item.text,
                    source: item.source,
                    onTap: (selectedMotCle) {
                      if (item.source == MotCleSource.dernieresRecherches) {
                        PassEmploiMatomoTracker.instance.trackEvent(
                          eventCategory: AnalyticsEventNames.lastRechercheMotsClesEventCategory,
                          action: AnalyticsEventNames.lastRechercheMotsClesClickAction,
                        );
                      } else if (item.source == MotCleSource.diagorienteMetiersFavoris) {
                        PassEmploiMatomoTracker.instance.trackEvent(
                          eventCategory: AnalyticsEventNames.autocompleteMotCleDiagorienteMetiersFavorisEventCategory,
                          action: AnalyticsEventNames.autocompleteMotCleDiagorienteMetiersFavorisClickAction,
                        );
                      }
                      Navigator.pop(context, selectedMotCle);
                    },
                  );
                }
                return SizedBox.shrink();
              },
              separatorBuilder: (context, index) => TextFormFieldSepLine(),
              itemCount: widget.viewModel.motsCles.length,
            ),
          ),
      ],
    );
  }
}

class _MotCleListTile extends StatelessWidget {
  final String motCle;
  final MotCleSource source;
  final Function(String) onTap;

  const _MotCleListTile({required this.motCle, required this.source, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Margins.spacing_l),
      title: Row(
        children: [
          Icon(
            source == MotCleSource.dernieresRecherches ? AppIcons.schedule_rounded : AppIcons.bolt_rounded,
            size: Dimens.icon_size_base,
            color: AppColors.grey800,
          ),
          SizedBox(width: Margins.spacing_s),
          Expanded(child: Text(motCle, style: TextStyles.textBaseRegular)),
        ],
      ),
      onTap: () => onTap(motCle),
    );
  }
}
