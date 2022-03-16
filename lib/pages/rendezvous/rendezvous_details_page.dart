import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';

class RendezvousDetailsPage extends TraceableStatelessWidget {
  final String rendezvousId;
  final RendezvousCardViewModel rendezvous;

  RendezvousDetailsPage._(this.rendezvousId, this.rendezvous) : super(name: AnalyticsScreenNames.rendezvousDetails);

  static MaterialPageRoute<void> materialPageRoute(String rendezvousId, RendezvousCardViewModel rendezvous) {
    return MaterialPageRoute(builder: (context) => RendezvousDetailsPage._(rendezvousId, rendezvous));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.myRendezVous, withBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (rendezvous.title != null) Text(rendezvous.title!, style: TextStyles.textLBold()),
              SizedBox(height: Margins.spacing_xs),
              Text(rendezvous.subtitle, style: TextStyles.textBaseRegular),
              SizedBox(height: Margins.spacing_m),
              Row(
                children: [
                  SvgPicture.asset(Drawables.icCalendar),
                  SizedBox(width: Margins.spacing_s),
                  Text(rendezvous.dateWithoutHour, style: TextStyles.textBaseBold),
                  Expanded(child: SizedBox()),
                  SvgPicture.asset(Drawables.icClock),
                  SizedBox(width: Margins.spacing_s),
                  Text(rendezvous.hourAndDuration, style: TextStyles.textBaseBold),
                ],
              ),
              SizedBox(height: Margins.spacing_m),
              Container(height: 1, color: AppColors.primaryLighten),
              SizedBox(height: Margins.spacing_s),
              Text(rendezvous.modality, style: TextStyles.textBaseBold),
              SizedBox(height: Margins.spacing_m),
              Container(height: 1, color: AppColors.primaryLighten),
              SizedBox(height: Margins.spacing_s),
              Text(Strings.rendezVousConseillerCommentLabel, style: TextStyles.textBaseBold),
              SizedBox(height: Margins.spacing_s),
              TextWithClickableLinks(rendezvous.comment, style: TextStyles.textSRegular()),
              SizedBox(height: Margins.spacing_m),
              Container(height: 1, color: AppColors.primaryLighten),
              SizedBox(height: Margins.spacing_base),
              Text(Strings.cantMakeItNoBigDeal, style: TextStyles.textBaseBold),
              SizedBox(height: Margins.spacing_s),
              Text(
                Strings.shouldInformConseiller,
                style: TextStyles.textSRegular(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
