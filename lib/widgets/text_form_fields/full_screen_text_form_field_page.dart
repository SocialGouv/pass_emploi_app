import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/recherches_derniers_mots_cles/recherches_derniers_mots_cles_actions.dart';
import 'package:pass_emploi_app/presentation/derniers_mots_cles_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/debounce_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/full_screen_text_form_field_scaffold.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/multiline_app_bar.dart';

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
            title: title,
            hint: hint,
            selectedKeyword: selectedKeyword,
            heroTag: heroTag,
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
    required this.title,
    required this.hint,
    required this.selectedKeyword,
    required this.heroTag,
  }) : super(key: key);

  final String title;
  final String hint;
  final String? selectedKeyword;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MultilineAppBar(
          title: title,
          hint: hint,
          onCloseButtonPressed: () => Navigator.pop(context, selectedKeyword),
        ),
        DebounceTextFormField(
          heroTag: heroTag,
          initialValue: selectedKeyword,
          onFieldSubmitted: (keyword) => Navigator.pop(context, keyword),
        ),
      ],
    );
  }
}
