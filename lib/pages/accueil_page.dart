import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class AccueilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccueilViewModel>(
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
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_base),
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
    return Text("Cette semaine");
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
