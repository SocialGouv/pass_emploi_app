import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class AccueilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccueilViewModel>(
      onInit: (store) => store.dispatch(AccueilRequestAction()),
      converter: (store) => AccueilViewModel.create(store),
      builder: (context, viewModel) => _scaffold(viewModel),
      distinct: true,
    );
  }

  Scaffold _scaffold(AccueilViewModel viewModel) {
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PrimaryAppBar(title: Strings.accueilAppBarTitle, backgroundColor: backgroundColor),
      body: SafeArea(
        child: _Blocs(viewModel),
      ),
    );
  }
}

class _Blocs extends StatelessWidget {
  final AccueilViewModel viewModel;

  const _Blocs(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_base),
      itemCount: viewModel.items.length,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final item = viewModel.items[index];
    if (item is AccueilCetteSemaineItem) return _CetteSemaine(item);
    if (item is AccueilProchainRendezvousItem) return _ProchainRendezVous(item);
    if (item is AccueilEvenementsItem) return _Evenements(item);
    if (item is AccueilAlertesItem) return _Alertes(item);
    if (item is AccueilFavorisItem) return _Favoris(item);
    if (item is AccueilOutilsItem) return _Outils(item);
    return SizedBox.shrink();
  }
}

//TODO: move 1 file / item

class _CetteSemaine extends StatelessWidget {
  final AccueilCetteSemaineItem item;

  _CetteSemaine(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.accueilCetteSemaineSection, style: TextStyles.secondaryAppBar),
        SizedBox(height: Margins.spacing_s),
        CardContainer(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CetteSemaineRow(
                icon: Icon(AppIcons.today_rounded, color: AppColors.primary),
                text: item.rendezVous,
                addBorderRadius: true,
                onTap: () => {},
              ),
              SepLine(0, 0),
              _CetteSemaineRow(
                icon: Icon(AppIcons.error_rounded, color: AppColors.warning),
                text: item.actionsDemarchesEnRetard,
                onTap: () => {},
              ),
              SepLine(0, 0),
              _CetteSemaineRow(
                icon: Icon(AppIcons.description_rounded, color: AppColors.accent1),
                text: item.actionsDemarchesARealiser,
                onTap: () => {},
              ),
              _CetteSemaineVoirDetails(
                onTap: () => {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CetteSemaineRow extends StatelessWidget {
  final Icon icon;
  final String text;
  final bool addBorderRadius;
  final Function() onTap;

  const _CetteSemaineRow({required this.icon, required this.text, required this.onTap, this.addBorderRadius = false});

  @override
  Widget build(BuildContext context) {
    final borderRadius = addBorderRadius
        ? BorderRadius.only(
            topLeft: Radius.circular(Dimens.radius_base),
            topRight: Radius.circular(Dimens.radius_base),
          )
        : BorderRadius.zero;
    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: Margins.spacing_xs, right: Margins.spacing_base),
                  child: icon,
                ),
                Expanded(
                  child: Text(text, style: TextStyles.textBaseBold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_xs),
                  child: Icon(AppIcons.chevron_right_rounded, color: AppColors.contentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CetteSemaineVoirDetails extends StatelessWidget {
  final Function() onTap;

  const _CetteSemaineVoirDetails({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_m, horizontal: Margins.spacing_base),
      child: SecondaryButton(label: Strings.accueilVoirDetailsCetteSemaine, onPressed: onTap),
    );
  }
}

class _ProchainRendezVous extends StatelessWidget {
  final AccueilProchainRendezvousItem item;

  _ProchainRendezVous(this.item);

  @override
  Widget build(BuildContext context) {
    return Text("Prochain rendez-vous");
  }
}

class _Evenements extends StatelessWidget {
  final AccueilEvenementsItem item;

  _Evenements(this.item);

  @override
  Widget build(BuildContext context) {
    return Text("Événements");
  }
}

class _Alertes extends StatelessWidget {
  final AccueilAlertesItem item;

  _Alertes(this.item);

  @override
  Widget build(BuildContext context) {
    return Text("Alertes");
  }
}

class _Favoris extends StatelessWidget {
  final AccueilFavorisItem item;

  _Favoris(this.item);

  @override
  Widget build(BuildContext context) {
    return Text("Favoris");
  }
}

class _Outils extends StatelessWidget {
  final AccueilOutilsItem item;

  _Outils(this.item);

  @override
  Widget build(BuildContext context) {
    return Text("Outils");
  }
}
