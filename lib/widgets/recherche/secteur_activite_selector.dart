import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/ignore_tracking_context_provider.dart';
import 'package:pass_emploi_app/models/evenement_emploi/secteur_activite.dart';
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
    return Semantics(
      button: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.secteurActiviteLabel, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_base),
          // A11y - GestureDetector is not focusable by itself
          Focus(
            child: GestureDetector(
              onTap: onFieldTap,
              child: Container(
                constraints: BoxConstraints(minHeight: 56),
                width: double.maxFinite,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.radius_base),
                  border: Border.all(color: AppColors.contentColor),
                ),
                child: _SelectedSecteurActivite(value?.label ?? Strings.secteurActiviteAll),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedSecteurActivite extends StatelessWidget {
  final String label;

  const _SelectedSecteurActivite(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_s),
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_s, vertical: Margins.spacing_xs),
            decoration: BoxDecoration(
              color: AppColors.primaryLighten,
              borderRadius: BorderRadius.all(Radius.circular(Dimens.radius_base)),
            ),
            child: Text(
              label,
              style: TextStyles.textSMedium(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
