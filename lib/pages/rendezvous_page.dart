import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat_floating_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class RendezvousPage extends StatelessWidget {
  final RendezvousViewModel rendezvous;

  RendezvousPage(this.rendezvous) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Text('Mon rendez-vous', style: TextStyles.h3Semi)),
      floatingActionButton: ChatFloatingActionButton(),
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
                  SvgPicture.asset("assets/ic_calendar.svg"),
                  SizedBox(width: 8),
                  Text(rendezvous.dateWithoutHour, style: TextStyles.textMdMedium),
                  Expanded(child: SizedBox()),
                  SvgPicture.asset("assets/ic_clock.svg"),
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
              Text('Commentaire de mon conseiller', style: TextStyles.textLgMedium),
              SizedBox(height: 8),
              Text(rendezvous.comment, style: TextStyles.textSmRegular(color: AppColors.bluePurple)),
              SizedBox(height: 24),
              Container(height: 1, color: AppColors.blueGrey),
              SizedBox(height: 12),
              Text('Un imprévu ? Ce n’est pas grave, mais…', style: TextStyles.textLgMedium),
              SizedBox(height: 8),
              Text(
                'En cas d’imprévu, il est impératif de prévenir ton conseiller. Pour cela, n’hésite pas à le contacter via la messagerie de Pass emploi.',
                style: TextStyles.textSmRegular(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
