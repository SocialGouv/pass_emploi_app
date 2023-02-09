import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/autocomplete/location_autocomplete.dart';
import 'package:pass_emploi_app/widgets/autocomplete/metier_autocomplete.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class TemporaryPage extends StatefulWidget {
  @override
  State<TemporaryPage> createState() => _TemporaryPageState();
}

class _TemporaryPageState extends State<TemporaryPage> {
  Metier? _selectedMetier;
  Location? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PrimaryAppBar(title: 'Autocompletion', backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimens.radius_base),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                MetierAutocomplete(
                  title: Strings.metierCompulsoryLabel,
                  onMetierSelected: (metier) => {setState(() => _selectedMetier = metier)},
                ),
                SizedBox(height: 16),
                LocationAutocomplete(
                  title: Strings.jobLocationTitle,
                  hint: Strings.jobLocationHint,
                  onLocationSelected: (location) => {setState(() => _selectedLocation = location)},
                ),
                SizedBox(height: 16),
                Text('Selected metier: ${_selectedMetier?.libelle}', style: TextStyles.textSRegular()),
                Text('Selected location: ${_selectedLocation?.libelle}', style: TextStyles.textSRegular()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
