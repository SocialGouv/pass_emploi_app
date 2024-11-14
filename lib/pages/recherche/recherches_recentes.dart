import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/presentation/recherches_recentes_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/alerte_card.dart';
import 'package:pass_emploi_app/widgets/apparition_animation.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class RecherchesRecentesPage extends StatelessWidget {
  const RecherchesRecentesPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => RecherchesRecentesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.derniereRecherche),
      body: RecherchesRecentesList(),
    );
  }
}

class RecherchesRecentesBandeau extends StatelessWidget {
  const RecherchesRecentesBandeau({this.paddingIfExists});
  final EdgeInsets? paddingIfExists;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RecherchesRecentesViewModel>(
      converter: (store) => RecherchesRecentesViewModel.create(store),
      builder: (context, viewModel) {
        final recherche = viewModel.rechercheRecente;
        return recherche != null
            ? ApparitionAnimation(
                child: Semantics(
                  button: true,
                  child: Padding(
                    padding: paddingIfExists ?? EdgeInsets.zero,
                    child: CardContainer(
                      onTap: () => Navigator.of(context).push(RecherchesRecentesPage.route()),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            AppIcons.search_rounded,
                            color: AppColors.accent1,
                            size: Dimens.icon_size_m,
                          ),
                          SizedBox(width: Margins.spacing_s),
                          Expanded(
                            child: Text(
                              Strings.derniereRecherche,
                              style: TextStyles.textBaseBold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_xs),
                            child: Icon(
                              AppIcons.chevron_right_rounded,
                              color: AppColors.contentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox.shrink();
      },
      distinct: true,
    );
  }
}

class RecherchesRecentesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RecherchesRecentesViewModel>(
      converter: (store) => RecherchesRecentesViewModel.create(store),
      builder: (context, viewModel) {
        final recherche = viewModel.rechercheRecente;
        return recherche != null ? _Body(recherche) : SizedBox.shrink();
      },
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  final Alerte alerte;

  _Body(this.alerte);

  @override
  Widget build(BuildContext context) {
    return AlerteNavigator(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: AlerteCard(alerte),
          ),
          SizedBox(height: Margins.spacing_base),
        ],
      ),
    );
  }
}
