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
    final bool littleScreen = _isLittleScreen(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: littleScreen ? 0 : 24),
          Center(child: SvgPicture.asset(Drawables.icNoContent, width: screenWidth / (littleScreen ? 3 : 2))),
          SizedBox(height: littleScreen ? 8 : 36),
          Text(_setTitle(), style: TextStyles.textSmMedium(), textAlign: TextAlign.center),
          SizedBox(height: littleScreen ? 4: 24),
          Text(Strings.unvailableContentDescription, style: TextStyles.textSmRegular(), textAlign: TextAlign.center),
          SizedBox(height: littleScreen ? 12 : 48),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: ActionButton(
              onPressed: () => launch(Strings.espacePoleEmploiUrl),
              label: Strings.poleEmploiUrlButton,
            ),
          ),
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

  bool _isLittleScreen(BuildContext context) => MediaQuery.of(context).size.height < 600;
}
