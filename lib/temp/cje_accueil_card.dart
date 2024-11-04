import 'package:flutter/material.dart';
import 'package:pass_emploi_app/app_initializer.dart';
import 'package:pass_emploi_app/temp/cje_page.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

const _dismissedKey = "cje_dismissed";

// TODO-CJE(04/11/24): remove file when feature deleted
class CjeAccueilCard extends StatefulWidget {
  @override
  State<CjeAccueilCard> createState() => _CjeAccueilCardState();
}

class _CjeAccueilCardState extends State<CjeAccueilCard> {
  Future<bool>? showCardFuture;

  @override
  void initState() {
    showCardFuture = AppInitializer.preferences.containsKey(key: _dismissedKey).then((value) => !value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: showCardFuture,
      builder: (context, snapshot) => snapshot.data == true ? _Card() : SizedBox.shrink(),
    );
  }
}

class _Card extends StatefulWidget {
  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (_visible) {
      PassEmploiMatomoTracker.instance.trackEvent(eventCategory: "Card CJE - accueil", action: "Affichage");
    }
    return AnimatedCrossFade(
      duration: AnimationDurations.fast,
      firstChild: SizedBox.shrink(),
      crossFadeState: _visible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      secondChild: Semantics(
        button: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: Margins.spacing_m),
          child: CardContainer(
            backgroundColor: AppColors.primary,
            splashColor: AppColors.primaryDarken.withOpacity(0.5),
            padding: EdgeInsets.zero,
            onTap: () => Navigator.of(context).push(CjePage.materialPageRoute(CjePageSource.accueil)),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(Margins.spacing_base),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(Margins.spacing_xs),
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Semantics(
                                excludeSemantics: true,
                                child: Image.asset("assets/cje/logo.webp"),
                              ),
                            ),
                          ),
                          SizedBox(width: Margins.spacing_m),
                          Expanded(
                            child: Text(
                              "Retrouvez votre carte “jeune engagé” dans votre profil et accédez à toutes vos réductions",
                              style: TextStyles.textBaseBold.copyWith(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: Margins.spacing_m),
                        ],
                      ),
                      SizedBox(height: Margins.spacing_s),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Je découvre la carte jeune engagé",
                                style: TextStyles.textSMedium().copyWith(
                                  color: Colors.white,
                                  decorationColor: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: Margins.spacing_xs),
                                  child: Icon(AppIcons.chevron_right_rounded, color: Colors.white, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    tooltip: "Fermer la boîte de dialogue Carte jeune engagé",
                    onPressed: () async {
                      await AppInitializer.preferences.write(key: _dismissedKey, value: "true");
                      PassEmploiMatomoTracker.instance.trackEvent(
                        eventCategory: "Card CJE - accueil",
                        action: "Fermeture",
                      );
                      setState(() => _visible = false);
                    },
                    icon: Icon(AppIcons.close_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
