import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
//TODO(1418): à supprimer ?
class EmptyOffreWidget extends StatelessWidget {
  final Widget? additional;
  final bool withModifyButton;

  EmptyOffreWidget({Key? key, this.additional, this.withModifyButton = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: SvgPicture.asset(Drawables.emptyOffresIllustration)),
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_base),
            child: Text(Strings.noContentError, style: TextStyles.textSBold, textAlign: TextAlign.center),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (withModifyButton)
                PrimaryActionButton(onPressed: () => Navigator.pop(context), label: Strings.updateCriteria),
              if (additional != null) additional!,
            ],
          ),
        ],
      ),
    );
  }
}
