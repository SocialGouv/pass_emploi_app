import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';

import '../ui/drawables.dart';
import '../ui/margins.dart';
import '../ui/strings.dart';
import '../ui/text_styles.dart';

class EmptyOffreWidget extends StatelessWidget {
  final Widget? additional;

  EmptyOffreWidget({Key? key, this.additional}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Flexible(child: SvgPicture.asset(Drawables.icEmptyOffres)),
                Text(Strings.noContentError, style: TextStyles.textSBold, textAlign: TextAlign.center),
              ],
            ),
            flex: 7,
          ),
          SizedBox(height: Margins.spacing_base),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryActionButton(onPressed: () => Navigator.pop(context), label: Strings.updateCriteria),
                if (additional != null) additional!,
              ],
            ),
            flex: 3,
          ),
        ],
      ),
    );
  }
}
