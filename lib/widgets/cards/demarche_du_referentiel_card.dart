import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_du_referentiel_card_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/tags/status_tag.dart';

class DemarcheDuReferentielCard extends StatelessWidget {
  final String idDemarche;
  final Function() onTap;

  const DemarcheDuReferentielCard({required this.idDemarche, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DemarcheDuReferentielCardViewModel>(
      builder: _buildBody,
      converter: (store) => DemarcheDuReferentielCardViewModel.create(store, idDemarche),
      distinct: true,
    );
  }

  Widget _buildBody(BuildContext context, DemarcheDuReferentielCardViewModel viewModel) {
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
            onTap: onTap,
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Tag(viewModel.pourquoi),
                  Text(viewModel.quoi, style: TextStyles.textBaseBold),
                ],
              ),
            ),
          ),
        ),
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
        textColor: AppColors.accent2,
        title: text,
      ),
    );
  }
}
