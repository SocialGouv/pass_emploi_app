import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class BoiteAOutilsCard extends StatelessWidget {
  const BoiteAOutilsCard({
    Key? key,
    required this.outil,
    required this.isLastItem,
  }) : super(key: key);

  final Outil outil;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: InkWell(
            onTap: () {
              launch(outil.urlRedirect);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (outil.imagePath != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "assets/${outil.imagePath!}",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    SizedBox(height: 16),
                    Text(outil.title, style: TextStyles.textBaseBold),
                    SizedBox(height: 16),
                    Text(outil.description, style: TextStyles.textSRegular),
                    SizedBox(height: 16),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(height: 1, color: AppColors.bluePurpleAlpha20),
                ),
                SizedBox(height: 16),
                Center(
                    child: Text(outil.actionLabel,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontFamily: 'Marianne',
                          fontSize: FontSizes.medium,
                          fontWeight: FontWeight.w700,
                        ))),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
        if (isLastItem) SizedBox(height: 16),
      ],
    );
  }
}
