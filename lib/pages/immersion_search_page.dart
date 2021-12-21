import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/button.dart';

class ImmersionSearchPage extends StatelessWidget {
  const ImmersionSearchPage() : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Text(Strings.immersionLabel, style: TextStyles.textSmMedium()),
          SizedBox(height: 24),
          Text(Strings.metierCompulsoryLabel, style: TextStyles.textLgMedium),
          SizedBox(height: 24),
          Text("Ceci est un text input", style: TextStyles.textSmRegular(color: Colors.red)),
          SizedBox(height: 24),
          Text(Strings.villeCompulsoryLabel, style: TextStyles.textLgMedium),
          SizedBox(height: 24),
          Text("Ceci est un 2e text input", style: TextStyles.textSmRegular(color: Colors.green)),
          SizedBox(height: 24),
          _stretchedButton(),
          SizedBox(height: 24),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                Strings.immersionExpansionTileTitle,
                style: TextStyles.textMdMedium,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              expandedAlignment: Alignment.topLeft,
              children: _collapsableContent(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _collapsableContent() {
    return [
      Text(Strings.immersionObjectifTitle, style: TextStyles.textSmMedium()),
      SizedBox(height: 16),
      Text(Strings.immersionObjectifContent, style: TextStyles.textSmRegular()),
      SizedBox(height: 24),
      Text(Strings.immersionDemarchesTitle, style: TextStyles.textSmMedium()),
      SizedBox(height: 16),
      Text(Strings.immersionDemarchesContent, style: TextStyles.textSmRegular()),
      SizedBox(height: 24),
      Text(Strings.immersionStatutTitle, style: TextStyles.textSmMedium()),
      SizedBox(height: 16),
      Text(Strings.immersionStatutContent, style: TextStyles.textSmRegular())
    ];
  }

  Column _stretchedButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        primaryActionButton(onPressed: null, label: Strings.searchButton),
      ],
    );
  }
}
