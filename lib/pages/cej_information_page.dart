import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/onboarding_background.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';

import 'choix_organisme_page.dart';

class CejInformationPage extends StatelessWidget {
  static MaterialPageRoute materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CejInformationPage());
  }

  CejInformationPage({Key? key}) : super(key: key);

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OnboardingBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      _backButton(context),
                      Spacer(),
                      InkWell(
                        onTap: () => Navigator.push(context, ChoixOrganismePage.materialPageRoute()),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Margins.spacing_s,
                            horizontal: Margins.spacing_base,
                          ),
                          child: Text("Passer", style: TextStyles.textPrimaryButton.copyWith(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    children: [
                      _firstCard(),
                      _secondCard(),
                      _thirdCard(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(Margins.spacing_m, 0, Margins.spacing_m, Margins.spacing_m),
                  child: PrimaryActionButton(
                    label: "Continuer",
                    onPressed: () {
                      final currentPage = _controller.page;
                      if (currentPage != null && currentPage < 2) {
                        _controller.animateToPage(
                          currentPage.floor() + 1,
                          duration: Duration(milliseconds: 600),
                          curve: Curves.linearToEaseOut,
                        );
                      } else {
                        Navigator.push(context, ChoixOrganismePage.materialPageRoute());
                      }
                    },
                  ),
                ),
                //Text("Current page : ${controller.page}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        Drawables.icChevronLeft,
        color: Colors.white,
        height: Margins.spacing_xl,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _contentCard(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_m),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Widget _firstCard() {
    return _contentCard(
      [
        Text("Qu’est-ce que pass emploi ?", style: TextStyles.textMBold.copyWith(color: AppColors.primary)),
        SizedBox(height: Margins.spacing_base),
        Text("L’application dédiée aux bénéficiaires du Contrat Engagement Jeune", style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icDone, "Un suivi personnalisé"),
        SizedBox(height: Margins.spacing_s),
        Text(
          "pass emploi vous permet de suivre toutes vos actions en lien avec vos démarches professionnelles.",
          style: TextStyles.textBaseRegular,
        ),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icOnboardingChat, "Un moyen de contact privilégié"),
        SizedBox(height: Margins.spacing_s),
        Text(
          "Restez en contact avec votre conseiller à l’aide d’une messagerie instantanée.",
          style: TextStyles.textBaseRegular,
        ),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icSearch, "Un outil de recherche"),
        SizedBox(height: Margins.spacing_s),
        Text(
          "Grâce à pass emploi, recherchez un emploi, gérez vos offres favorites et trouvez des solutions.",
          style: TextStyles.textBaseRegular,
        ),
      ],
    );
  }

  Widget _secondCard() {
    return _contentCard(
      [
        Text("Qu’est-ce que le Contrat Engagement Jeune ?",
            style: TextStyles.textMBold.copyWith(color: AppColors.primary)),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icFlash, "Un suivi personnalisé"),
        SizedBox(height: Margins.spacing_s),
        Text(
          "Pendant plusieurs mois, vous êtes accompagnés de 15 à 20 heures par semaine minimum.",
          style: TextStyles.textBaseRegular,
        ),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icPeople, "Un référent unique"),
        SizedBox(height: Margins.spacing_s),
        Text(
          "Un conseiller vous accompagne tout au long de votre parcours. ",
          style: TextStyles.textBaseRegular,
        ),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icEuro, "Une allocation financière"),
        SizedBox(height: Margins.spacing_s),
        Text(
          "Une allocation pouvant aller jusqu’à 500 euros par mois si vous en avez besoin.",
          style: TextStyles.textBaseRegular,
        ),
      ],
    );
  }

  Widget _thirdCard() {
    return _contentCard([
      Text("Qui est concerné ?", style: TextStyles.textMBold.copyWith(color: AppColors.primary)),
      SizedBox(height: Margins.spacing_m),
      SvgPicture.asset(Drawables.puzzle),
      SizedBox(height: Margins.spacing_m),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "→ Les personnes entre ", style: TextStyles.textBaseRegular),
            TextSpan(text: "16 et 25 ans", style: TextStyles.textBaseBold),
            TextSpan(text: " (moins de ", style: TextStyles.textBaseRegular),
            TextSpan(text: "30 ans", style: TextStyles.textBaseBold),
            TextSpan(text: " pour celles en situation de handicap)", style: TextStyles.textBaseRegular),
          ],
        ),
      ),
      SizedBox(height: Margins.spacing_m),
      RichText(
        text: TextSpan(
          children: [
            // → Les personnes qui ne sont pas en formation ni en emploi durable (CDI ou CDD de longue durée)
            TextSpan(text: "→ Les personnes qui ne sont ", style: TextStyles.textBaseRegular),
            TextSpan(text: "pas en formation ni en emploi durable", style: TextStyles.textBaseBold),
            TextSpan(text: " (CDI ou CDD de longue durée)", style: TextStyles.textBaseRegular),
          ],
        ),
      ),
    ]);
  }

  Widget _cardBulletPoint(String icon, String text) {
    return Row(
      children: [
        SvgPicture.asset(icon),
        SizedBox(width: Margins.spacing_s),
        Text(text, style: TextStyles.textBaseBold),
      ],
    );
  }
}
