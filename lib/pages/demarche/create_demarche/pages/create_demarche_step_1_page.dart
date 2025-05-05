import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/thematiques_demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/media_sizes.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class CreateDemarcheStep1Page extends StatelessWidget {
  const CreateDemarcheStep1Page(this.formViewModel, {super.key});
  final CreateDemarcheFormViewModel formViewModel;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ThematiqueDemarchePageViewModel>(
      onInit: (store) => store.dispatch(ThematiqueDemarcheRequestAction()),
      converter: (store) => ThematiqueDemarchePageViewModel.create(store),
      builder: (context, thematiqueViewModel) => _Content(
        thematiqueViewModel: thematiqueViewModel,
        formViewModel: formViewModel,
      ),
      distinct: true,
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.thematiqueViewModel, required this.formViewModel});
  final ThematiqueDemarchePageViewModel thematiqueViewModel;
  final CreateDemarcheFormViewModel formViewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: AnimatedSwitcher(
        duration: AnimationDurations.fast,
        child: switch (thematiqueViewModel.displayState) {
          DisplayState.FAILURE => _ErrorMessage(
              thematiqueViewModel,
              onCreateCustomDemarche: _onCreateCustomDemarcheSelected,
            ),
          DisplayState.CONTENT => _Success(
              thematiqueViewModel,
              formViewModel,
              onCreateCustomDemarche: _onCreateCustomDemarcheSelected,
            ),
          _ => _LoadingPlaceholder(),
        },
      ),
    );
  }

  void _onCreateCustomDemarcheSelected() {
    formViewModel.navigateToCreateCustomDemarche();
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: Margins.spacing_base,
          mainAxisSpacing: Margins.spacing_base,
        ),
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 7,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: AnimationDurations.fast,
            delay: AnimationDurations.veryFast,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(Dimens.radius_base),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage(this.viewModel, {required this.onCreateCustomDemarche});
  final ThematiqueDemarchePageViewModel viewModel;
  final void Function() onCreateCustomDemarche;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyStatePlaceholder(
              illustration: Illustration.orange(AppIcons.construction),
              title: Strings.thematiquesErrorTitle,
              subtitle: Strings.thematiquesErrorSubtitle,
            ),
            const SizedBox(height: Margins.spacing_m),
            PrimaryActionButton(label: Strings.retry, onPressed: viewModel.onRetry),
            const SizedBox(height: Margins.spacing_xl),
            _CreateCustomDemarche(onCreateCustomDemarche),
          ],
        ),
      ),
    );
  }
}

class _Success extends StatelessWidget {
  const _Success(this.thematiqueViewModel, this.formViewModel, {required this.onCreateCustomDemarche});
  final ThematiqueDemarchePageViewModel thematiqueViewModel;
  final void Function() onCreateCustomDemarche;
  final CreateDemarcheFormViewModel formViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.thematiquesDemarcheDescriptionShort, style: TextStyles.textMBold),
        const SizedBox(height: Margins.spacing_base),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: _responsiveChildAspectRatioForA11y(context),
            crossAxisSpacing: Margins.spacing_base,
            mainAxisSpacing: Margins.spacing_base,
          ),
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: thematiqueViewModel.thematiques.length,
          itemBuilder: (context, index) {
            return _ThematiqueTile(
              thematiqueViewModel.thematiques[index],
              (thematique) {
                formViewModel.thematiqueSelected(thematique);
              },
            );
          },
        ),
        const SizedBox(height: Margins.spacing_base),
        _CreateCustomDemarche(onCreateCustomDemarche),
        const SizedBox(height: Margins.spacing_xl),
      ],
    );
  }

  double _responsiveChildAspectRatioForA11y(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    if (height < MediaSizes.height_xs) return textScaleFactor > 1 ? 0.5 : 2 / 3;
    // manualy ajusted for a11y at 235%
    return min(1, 0.9 / textScaleFactor);
  }
}

class _ThematiqueTile extends StatelessWidget {
  const _ThematiqueTile(this.thematique, this.onThematiqueSelected);
  final ThematiqueDemarcheItem thematique;
  final void Function(ThematiqueDemarcheItem) onThematiqueSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: CardContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(thematique.icon, size: Dimens.icon_size_l, color: AppColors.primary),
            const SizedBox(height: Margins.spacing_base),
            Text(
              thematique.title,
              textAlign: TextAlign.center,
              style: TextStyles.textSBold,
            ),
          ],
        ),
        onTap: () => onThematiqueSelected(thematique),
      ),
    );
  }
}

class _CreateCustomDemarche extends StatelessWidget {
  final void Function() onCreateCustomDemarche;

  const _CreateCustomDemarche(this.onCreateCustomDemarche);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: CardContainer(
        onTap: onCreateCustomDemarche,
        child: Row(
          children: [
            Icon(AppIcons.search_rounded, size: Dimens.icon_size_l, color: AppColors.primary),
            SizedBox(width: Margins.spacing_base),
            Expanded(
              child: Column(
                children: [
                  Text(
                    Strings.customDemarcheTitle,
                    style: TextStyles.textBaseBold,
                  ),
                  SizedBox(height: Margins.spacing_base),
                  Text(
                    Strings.customDemarcheSubtitle,
                    style: TextStyles.textBaseRegular,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
