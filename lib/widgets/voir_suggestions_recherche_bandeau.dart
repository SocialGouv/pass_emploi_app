import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/presentation/voir_suggestions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class VoirSuggestionsRechercheBandeau extends StatelessWidget {
  final EdgeInsets? padding;

  VoirSuggestionsRechercheBandeau({this.padding});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoirSuggestionsRechercheViewModel>(
      onInit: (store) => store.dispatch(SuggestionsRechercheRequestAction()),
      converter: (store) => VoirSuggestionsRechercheViewModel.create(store),
      builder: (context, viewModel) => _Body(viewModel: viewModel, padding: padding),
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  final VoirSuggestionsRechercheViewModel viewModel;
  final EdgeInsets? padding;

  _Body({required this.viewModel, this.padding});

  @override
  Widget build(BuildContext context) {
    if (viewModel.hasSuggestionsRecherche) {
      return Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: _Bandeau(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _Icon(),
              _Text(),
              _Chevron(),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(height: 0);
    }
  }
}

class _Icon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SvgPicture.asset(Drawables.icAlertSuggestions, color: AppColors.accent1, height: 20),
    );
  }
}

class _Text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(Strings.vosSuggestionsDeRecherche, style: TextStyles.textBaseBold),
    );
  }
}

class _Chevron extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SvgPicture.asset(Drawables.icChevronRight, color: AppColors.contentColor),
    );
  }
}

class _Bandeau extends StatelessWidget {
  final Widget child;

  _Bandeau({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [Shadows.boxShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => {},
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
