import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/derniers_mots_cles_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
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
      body: StoreConnector<AppState, DerniersMotsClesViewModel>(
        converter: (store) => DerniersMotsClesViewModel.create(store),
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
}

class _Body extends StatefulWidget {
  final DerniersMotsClesViewModel viewModel;
  final String title;
  final String hint;
  final String? selectedKeyword;
  final String heroTag;

  const _Body({
    Key? key,
    required this.viewModel,
    required this.title,
    required this.hint,
    required this.selectedKeyword,
    required this.heroTag,
  }) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool emptyInput = true;

  @override
  Widget build(BuildContext context) {
    if (emptyInput) {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.lastRechercheMetierEventCategory,
        action: AnalyticsEventNames.lastRechercheMetierDisplayAction,
      );
    }
    return Column(
      children: [
        MultilineAppBar(
          title: widget.title,
          hint: widget.hint,
          onCloseButtonPressed: () => Navigator.pop(context, widget.selectedKeyword),
        ),
        DebounceTextFormField(
          heroTag: widget.heroTag,
          initialValue: widget.selectedKeyword,
          onChanged: (text) {
            if (text.isEmpty != emptyInput) setState(() => emptyInput = text.isEmpty);
          },
          onFieldSubmitted: (keyword) => Navigator.pop(context, keyword),
        ),
        TextFormFieldSepLine(),
        if (emptyInput)
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final item = widget.viewModel.derniersMotsCles[index];
                if (item is DerniersMotsClesAutocompleteTitleItem) return TitleTile(title: item.title);

                if (item is DerniersMotsClesAutocompleteSuggestionItem) {
                  return _MotCleListTile(
                    motCle: item.text,
                    onTap: (selectedMotCle) {
                      if (emptyInput) {
                        PassEmploiMatomoTracker.instance.trackEvent(
                          eventCategory: AnalyticsEventNames.lastRechercheMetierEventCategory,
                          action: AnalyticsEventNames.lastRechercheMetierClickAction,
                        );
                      }
                      Navigator.pop(context, selectedMotCle);
                    },
                  );
                }
                return SizedBox.shrink();
              },
              separatorBuilder: (context, index) => TextFormFieldSepLine(),
              itemCount: widget.viewModel.derniersMotsCles.length,
            ),
          ),
      ],
    );
  }
}

class _MotCleListTile extends StatelessWidget {
  final String motCle;
  final Function(String) onTap;

  const _MotCleListTile({required this.motCle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Margins.spacing_l),
      title: Row(
        children: [
          Icon(AppIcons.schedule_rounded, size: Dimens.icon_size_base, color: AppColors.grey800),
          SizedBox(width: Margins.spacing_s),
          Text(motCle, style: TextStyles.textBaseRegular),
        ],
      ),
      onTap: () => onTap(motCle),
    );
  }
}
