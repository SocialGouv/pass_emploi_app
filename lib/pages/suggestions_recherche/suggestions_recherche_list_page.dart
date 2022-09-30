import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestion_recherche_card_view_model.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestions_recherche_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/loading_overlay.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class SuggestionsRechercheListPage extends StatelessWidget {
  SuggestionsRechercheListPage._() : super();

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return SuggestionsRechercheListPage._();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SuggestionsRechercheListViewModel>(
      builder: (context, viewModel) => _Scaffold(viewModel: viewModel),
      converter: (store) => SuggestionsRechercheListViewModel.create(store),
      distinct: true,
    );
  }
}

class _Scaffold extends StatelessWidget {
  final SuggestionsRechercheListViewModel viewModel;

  _Scaffold({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: passEmploiAppBar(
        label: Strings.suggestionsDeRechercheTitlePage,
        context: context,
        withBackButton: true,
      ),
      body: Stack(
        children: [
          ListView.separated(
            itemCount: viewModel.suggestionIds.length,
            padding: const EdgeInsets.all(Margins.spacing_s),
            separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
            itemBuilder: (context, index) {
              return _Card(suggestionId: viewModel.suggestionIds[index]);
            },
          ),
          if (viewModel.displayState == DisplayState.LOADING) LoadingOverlay(),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String suggestionId;

  _Card({required this.suggestionId});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SuggestionRechercheCardViewModel?>(
      builder: (context, viewModel) => _builder(viewModel),
      converter: (store) => SuggestionRechercheCardViewModel.create(store, suggestionId),
      distinct: true,
    );
  }

  Widget _builder(SuggestionRechercheCardViewModel? viewModel) {
    if (viewModel == null) return SizedBox(height: 0);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [Shadows.boxShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Margins.spacing_base,
          Margins.spacing_base,
          Margins.spacing_base,
          10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Type(viewModel.type),
            _Space(),
            _Titre(viewModel.titre),
            _Space(),
            if (viewModel.metier != null) ...[
              _Metier(viewModel.metier!),
              _Space(),
            ],
            if (viewModel.localisation != null) ...[
              _Localisation(viewModel.localisation!),
              _Space(),
            ],
            _Buttons(onTapAjouter: viewModel.ajouterSuggestion),
          ],
        ),
      ),
    );
  }
}

class _Space extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: Margins.spacing_base);
  }
}

class _Type extends StatelessWidget {
  final String text;

  _Type(this.text);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text, style: TextStyles.textSRegular(color: AppColors.accent2)),
      ),
    );
  }
}

class _Titre extends StatelessWidget {
  final String text;

  _Titre(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyles.textBaseBold);
  }
}

class _Metier extends StatelessWidget {
  final String text;

  _Metier(this.text);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text, style: TextStyles.textSRegular(color: AppColors.primaryDarken)),
      ),
    );
  }
}

class _Localisation extends StatelessWidget {
  final String text;

  _Localisation(this.text);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: SvgPicture.asset(
                Drawables.icPlace,
                color: AppColors.primary,
                height: 16,
              ),
            ),
            Text(text, style: TextStyles.textSRegular(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final Function() onTapAjouter;

  _Buttons({required this.onTapAjouter});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SepLine(0, 0),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _Supprimer(),
                VerticalDivider(thickness: 1, color: AppColors.primaryLighten),
                _Ajouter(onTapAjouter: onTapAjouter),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _Supprimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: Margins.spacing_s),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SvgPicture.asset(
                Drawables.icTrash,
                color: AppColors.primary,
                height: 12,
              ),
            ),
            Text(Strings.suppressionLabel, style: TextStyles.textBaseBoldWithColor(AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

class _Ajouter extends StatelessWidget {
  final Function() onTapAjouter;

  _Ajouter({required this.onTapAjouter});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
          alignment: Alignment.centerRight,
          child: PrimaryActionButton(
            label: Strings.ajouter,
            drawableRes: Drawables.icAdd,
            withShadow: false,
            heightPadding: 6,
            onPressed: onTapAjouter,
          )),
    );
  }
}
