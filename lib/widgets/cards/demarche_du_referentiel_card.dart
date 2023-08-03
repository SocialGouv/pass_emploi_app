import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_du_referentiel_card_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';
import 'package:pass_emploi_app/widgets/tags/status_tag.dart';

class DemarcheDuReferentielCard extends StatelessWidget {
  final String idDemarche;
  final DemarcheSource source;
  final Function() onTap;

  const DemarcheDuReferentielCard({required this.idDemarche, required this.onTap, required this.source});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DemarcheDuReferentielCardViewModel>(
      builder: _buildBody,
      converter: (store) => DemarcheDuReferentielCardViewModel.create(store, idDemarche, source),
      distinct: true,
    );
  }

  Widget _buildBody(BuildContext context, DemarcheDuReferentielCardViewModel viewModel) {
    return CardContainer(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Tag(viewModel.pourquoi),
          Text(viewModel.quoi, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_base),
          PressedTip(Strings.demarchePressedTip),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_base),
      child: StatutTag(
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.contentColor,
        title: text,
      ),
    );
  }
}
