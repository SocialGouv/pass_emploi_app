import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class EmptyPoleEmploiContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.02),
          Flexible(flex: 1, child: SvgPicture.asset(Drawables.icEmpty)),
          SizedBox(height: screenHeight * 0.05),
          Text(Strings.emptyContentTitle(Strings.demarchesToDo), style: TextStyles.textBaseBold, textAlign: TextAlign.center),
          SizedBox(height: screenHeight * 0.03),
          Text(Strings.emptyContentDescription(Strings.demarches), style: TextStyles.textBaseRegular, textAlign: TextAlign.center),
          SizedBox(height: screenHeight * 0.04),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: PrimaryActionButton(
              onPressed: () => launchExternalUrl(Strings.espacePoleEmploiUrl),
              label: Strings.poleEmploiUrlButton,
            ),
          ),
          SizedBox(height: screenHeight * 0.1),
        ],
      ),
    );
  }
}
