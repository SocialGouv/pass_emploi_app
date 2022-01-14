import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class RendezvousPage extends TraceableStatelessWidget {
  final RendezvousViewModel rendezvous;

  RendezvousPage._(this.rendezvous) : super(name: AnalyticsScreenNames.rendezvousDetails);

  static MaterialPageRoute materialPageRoute(RendezvousViewModel rendezvous) {
    return MaterialPageRoute(builder: (context) => RendezvousPage._(rendezvous));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: passEmploiAppBar(label: Strings.myRendezVous, withBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(rendezvous.title, style: TextStyles.textLgMedium),
              SizedBox(height: 4),
              Text(rendezvous.subtitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
              SizedBox(height: 20),
              Row(
                children: [
                  SvgPicture.asset(Drawables.icCalendar),
                  SizedBox(width: 8),
                  Text(rendezvous.dateWithoutHour, style: TextStyles.textMdMedium),
                  Expanded(child: SizedBox()),
                  SvgPicture.asset(Drawables.icClock),
                  SizedBox(width: 8),
                  Text(rendezvous.hourAndDuration, style: TextStyles.textMdMedium),
                ],
              ),
              SizedBox(height: 24),
              Container(height: 1, color: AppColors.blueGrey),
              SizedBox(height: 12),
              Text(rendezvous.modality, style: TextStyles.textMdRegular),
              SizedBox(height: 24),
              Container(height: 1, color: AppColors.blueGrey),
              SizedBox(height: 12),
              Text(Strings.rendezVousConseillerCommentLabel, style: TextStyles.textLgMedium),
              SizedBox(height: 8),
              Text(rendezvous.comment, style: TextStyles.textSmRegular(color: AppColors.bluePurple)),
              SizedBox(height: 24),
              Container(height: 1, color: AppColors.blueGrey),
              SizedBox(height: 12),
              Text(Strings.cantMakeItNoBigDeal, style: TextStyles.textLgMedium),
              SizedBox(height: 8),
              Text(
                Strings.shouldInformConseiller,
                style: TextStyles.textSmRegular(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
