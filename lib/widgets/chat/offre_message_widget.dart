import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';

class OffreMessageWidget extends StatelessWidget {
  final OffreMessageItem item;

  OffreMessageWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: item is ConseillerMessageItem ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          _messageBubble(),
          SizedBox(height: Margins.spacing_xs),
          Text(item.caption, style: TextStyles.textXsRegular())
        ],
      ),
    );
  }

  Widget _messageBubble() {
    return Container(
      margin: EdgeInsets.only(left: 77.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _contentMessage(),
          SizedBox(height: Margins.spacing_base),
          _offre(),
        ],
      ),
    );
  }

  Widget _contentMessage() {
    return TextWithClickableLinks(
      item.content,
      linkStyle: TextStyles.textSRegular(color: Colors.white),
      style: TextStyles.textSRegular(color: Colors.white),
    );
  }

  Widget _offre() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(item.titreOffre, style: TextStyles.textBaseBold),
            SizedBox(height: Margins.spacing_s),
            Text(Strings.voirOffre, style: TextStyles.textSRegular(), textAlign: TextAlign.right),
          ],
        ),
      ),
    );
  }
}
