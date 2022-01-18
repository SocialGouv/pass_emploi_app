import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

import 'action_button.dart';

enum ContentType { ACTIONS, RENDEZVOUS }

class UnavailableContent extends StatelessWidget {
  final ContentType contentType;

  UnavailableContent({required this.contentType});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.02),
          Flexible(child: SvgPicture.asset(Drawables.icNoContent), flex: 1),
          SizedBox(height: screenHeight * 0.05),
          Text(_setTitle(), style: TextStyles.textSmMedium(), textAlign: TextAlign.center),
          SizedBox(height: screenHeight * 0.03),
          Text(Strings.unvailableContentDescription, style: TextStyles.textSmRegular(), textAlign: TextAlign.center),
          SizedBox(height: screenHeight * 0.04),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: ActionButton(
              onPressed: () => launch(Strings.espacePoleEmploiUrl),
              label: Strings.poleEmploiUrlButton,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
        ],
      ),
    );
  }

  String _setTitle() {
    switch (contentType) {
      case ContentType.ACTIONS:
        return Strings.unavailableContentTitle(Strings.actions);
      case ContentType.RENDEZVOUS:
        return Strings.unavailableContentTitle(Strings.rendezvous);
    }
  }
}
