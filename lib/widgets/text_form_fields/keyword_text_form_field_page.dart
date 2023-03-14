import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/recherches_derniers_mots_cles/recherches_derniers_mots_cles_actions.dart';
import 'package:pass_emploi_app/presentation/derniers_mots_cles_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/debounce_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/full_screen_text_form_field_scaffold.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/multiline_app_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/text_form_field_sep_line.dart';

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
        onInit: (store) => store.dispatch(RecherchesDerniersMotsClesRequestAction()),
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
  String _userInput = "";

  @override
  Widget build(BuildContext context) {
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
          onChanged: (text) => setState(() => _userInput = text),
          onFieldSubmitted: (keyword) => Navigator.pop(context, keyword),
        ),
        TextFormFieldSepLine(),
        if (_userInput.isEmpty)
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final item = widget.viewModel.derniersMotsCles[index];
                if (item is DerniersMotsClesAutocompleteTitleItem) return _TitleTile(title: item.title);

                if (item is DerniersMotsClesAutocompleteSuggestionItem) {
                  return _MotCleListTile(
                    motCle: item.text,
                    onTap: (selectedMotCle) => Navigator.pop(context, selectedMotCle),
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

class _TitleTile extends StatelessWidget {
  final String title;

  const _TitleTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Margins.spacing_l),
      title: Text(title, style: TextStyles.textBaseBold),
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
