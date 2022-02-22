import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/pages/immersion_details_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/immersion_saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/empty_offre_widget.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';

import '../widgets/buttons/secondary_button.dart';
import 'offre_page.dart';

class ImmersionListPage extends TraceableStatelessWidget {
  final List<Immersion> immersions;
  final bool fromSavedSearch;

  ImmersionListPage(this.immersions, [this.fromSavedSearch = false])
      : super(
          name: immersions.isEmpty ? AnalyticsScreenNames.immersionNoResults : AnalyticsScreenNames.immersionResults,
        );

  @override
  Widget build(BuildContext context) {
    return FavorisStateContext<Immersion>(
      selectState: (store) => store.state.immersionFavorisState,
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        appBar: passEmploiAppBar(label: Strings.immersionsTitle, withBackButton: true),
        body: immersions.isEmpty ? _empty(context) : _content(context),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return EmptyOffreWidget(
      withModifyButton: !fromSavedSearch,
      additional: Padding(
        padding: const EdgeInsets.only(top: Margins.spacing_base),
        child: fromSavedSearch ? Container() : _alertSecondaryButton(context),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) => _buildItem(context, immersions[index], index),
          separatorBuilder: (context, index) => Container(height: Margins.spacing_base),
          itemCount: immersions.length,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_m),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _alertPrimaryButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, Immersion immersion, int index) {
    return DataCard<Immersion>(
      titre: immersion.metier,
      sousTitre: immersion.nomEtablissement,
      lieu: immersion.ville,
      dataTag: [immersion.secteurActivite],
      onTap: () => pushAndTrackBack(context, ImmersionDetailsPage.materialPageRoute(immersion.id)),
      from: OffrePage.immersionResults,
      id: immersion.id,
    );
  }

  Widget _alertPrimaryButton(BuildContext context) {
    return PrimaryActionButton(
      label: Strings.createAlert,
      drawableRes: Drawables.icAlert,
      rippleColor: AppColors.primaryDarken,
      heightPadding: 6,
      widthPadding: 6,
      iconSize: 16,
      onPressed: () => _onAlertButtonPressed(context),
    );
  }

  Widget _alertSecondaryButton(BuildContext context) {
    return SecondaryButton(
      label: Strings.createAlert,
      drawableRes: Drawables.icAlert,
      onPressed: () => _onAlertButtonPressed(context),
    );
  }

  void _onAlertButtonPressed(BuildContext context) {
    showPassEmploiBottomSheet(context: context, builder: (context) => ImmersionSavedSearchBottomSheet());
  }
}
