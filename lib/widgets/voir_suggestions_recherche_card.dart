import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/presentation/voir_suggestions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class VoirSuggestionsRechercheCard extends StatelessWidget {
  final EdgeInsets? padding;

  VoirSuggestionsRechercheCard({this.padding});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoirSuggestionsRechercheViewModel>(
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
        child: _Card(
          child: Column(
            children: [
              _Icon(),
              _Title(),
              _Subitle(),
              _Button(),
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

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_s),
      child: Text(
        Strings.nouvellesSuggestionsDeRechercheTitre,
        style: TextStyles.textBaseBold,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _Subitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_base),
      child: Text(Strings.nouvellesSuggestionsDeRechercheDescription, style: TextStyles.textSRegular()),
    );
  }
}

class _Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_l, bottom: Margins.spacing_s),
      child: PrimaryActionButton(
        label: Strings.voirSuggestionsDeRecherche,
        withShadow: false,
        heightPadding: 8,
        onPressed: () => {},
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  _Card({required this.child});

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
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: child,
        ),
      ),
    );
  }
}
