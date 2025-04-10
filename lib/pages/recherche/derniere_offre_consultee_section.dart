import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/pages/immersion/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/presentation/derniere_offre_consultee_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_derniere_consultation_provider.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:pass_emploi_app/widgets/offre_emploi_origin.dart';
import 'package:pass_emploi_app/widgets/tags/data_tag.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

class DerniereOffreConsulteeSection extends StatelessWidget {
  const DerniereOffreConsulteeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DerniereOffreConsulteeViewModel>(
      converter: (store) => DerniereOffreConsulteeViewModel.create(store),
      builder: (context, viewModel) {
        if (viewModel.id.isEmpty) return SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MediumSectionTitle(Strings.rechercheDerniereOffreConsultee),
            SizedBox(height: Margins.spacing_base),
            DateDerniereActionProvider(
              id: viewModel.id,
              builder: (dateActionViewModel) {
                return BaseCard(
                  title: viewModel.titre,
                  subtitle: viewModel.organisation,
                  tag: viewModel.originViewModel?.toWidget(OffreEmploiOriginSize.small),
                  onTap: () => switch (viewModel.type) {
                    OffreType.emploi => Navigator.of(context).push(
                        OffreEmploiDetailsPage.materialPageRoute(
                          viewModel.id,
                          fromAlternance: false,
                        ),
                      ),
                    OffreType.alternance => Navigator.of(context).push(
                        OffreEmploiDetailsPage.materialPageRoute(
                          viewModel.id,
                          fromAlternance: true,
                        ),
                      ),
                    OffreType.immersion => Navigator.of(context).push(
                        ImmersionDetailsPage.materialPageRoute(viewModel.id),
                      ),
                    OffreType.serviceCivique => Navigator.of(context).push(
                        ServiceCiviqueDetailPage.materialPageRoute(viewModel.id),
                      ),
                  },
                  secondaryTags: [
                    viewModel.type.toCardTag(),
                    if (viewModel.localisation != null) DataTag.location(viewModel.localisation!),
                  ],
                  complements: [
                    if (dateActionViewModel.datePostulation != null)
                      CardComplement.datePostulation(dateActionViewModel.datePostulation!)
                    else if (dateActionViewModel.dateDerniereConsultation != null)
                      CardComplement.dateDerniereConsultation(dateActionViewModel.dateDerniereConsultation!)
                  ],
                );
              },
            ),
            SizedBox(height: Margins.spacing_base),
          ],
        );
      },
    );
  }
}
