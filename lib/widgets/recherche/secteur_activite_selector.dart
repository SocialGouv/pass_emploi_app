import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/ignore_tracking_context_provider.dart';
import 'package:pass_emploi_app/models/secteur_activite.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/recherche/secteur_activite_selection_page.dart';

class SecteurActiviteSelector extends StatefulWidget {
  final Function(SecteurActivite? secteur) onSecteurActiviteSelected;
  final SecteurActivite? initialValue;

  const SecteurActiviteSelector({
    required this.onSecteurActiviteSelected,
    this.initialValue,
  });

  @override
  State<SecteurActiviteSelector> createState() => _SecteurActiviteSelectorState();
}

class _SecteurActiviteSelectorState extends State<SecteurActiviteSelector> {
  SecteurActivite? _selectedSecteurActivite;

  @override
  void initState() {
    _selectedSecteurActivite = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _SecteurActiviteField(
      onFieldTap: () => Navigator.push(
        IgnoreTrackingContext.of(context).nonTrackingContext,
        SecteurActiviteSelectionPage.materialPageRoute(initialValue: _selectedSecteurActivite),
      ).then((secteur) => _updateSecteurActivite(secteur)),
      value: _selectedSecteurActivite,
    );
  }

  void _updateSecteurActivite(SecteurActivite? secteur) {
    setState(() => _selectedSecteurActivite = secteur);
    widget.onSecteurActiviteSelected(secteur);
  }
}

class _SecteurActiviteField extends StatelessWidget {
  final Function() onFieldTap;
  final SecteurActivite? value;

  const _SecteurActiviteField({
    required this.onFieldTap,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.secteurActiviteLabel, style: TextStyles.textBaseBold),
        Text(Strings.secteurActiviteHint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
        SizedBox(height: Margins.spacing_base),
        GestureDetector(
          onTap: onFieldTap,
          child: Container(
            height: 56,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.radius_base),
              border: Border.all(color: AppColors.contentColor),
            ),
            child: Text(value?.label ?? 'Tous'),
          ),
        ),
      ],
    );
  }
}
