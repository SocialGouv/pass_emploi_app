import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/evenement_emploi/secteur_activite.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/radio_list_tile.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/multiline_app_bar.dart';

class SecteurActiviteSelectionPage extends StatefulWidget {
  final SecteurActivite? _initialValue;

  SecteurActiviteSelectionPage(this._initialValue);

  static MaterialPageRoute<SecteurActivite?> materialPageRoute({required SecteurActivite? initialValue}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => SecteurActiviteSelectionPage(initialValue),
    );
  }

  @override
  State<SecteurActiviteSelectionPage> createState() => _SecteurActiviteSelectionPageState();
}

class _SecteurActiviteSelectionPageState extends State<SecteurActiviteSelectionPage> {
  SecteurActivite? _selectedValue;

  @override
  void initState() {
    _selectedValue = widget._initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Required to delegate top padding to system
      appBar: AppBar(toolbarHeight: 0, scrolledUnderElevation: 0),
      body: Column(
        children: [
          MultilineAppBar(
            title: Strings.secteurActiviteLabel,
            hint: Strings.secteurActiviteHint,
            onCloseButtonPressed: () => Navigator.pop(context, widget._initialValue),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: Margins.spacing_x_huge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <SecteurActivite?>[null, ...SecteurActivite.values]
                      .map(
                        (secteur) => _SecteurActiviteListTile(
                          secteurActivite: secteur,
                          selectedValue: _selectedValue,
                          onChanged: (value) => setState(() => _selectedValue = value),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: PrimaryActionButton(
        label: Strings.validateButtonTitle,
        onPressed: () => Navigator.pop(context, _selectedValue),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _SecteurActiviteListTile extends StatelessWidget {
  final SecteurActivite? secteurActivite;
  final SecteurActivite? selectedValue;
  final ValueChanged<SecteurActivite?> onChanged;

  const _SecteurActiviteListTile({
    required this.secteurActivite,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: CustomRadioGroup<SecteurActivite?>(
        title: secteurActivite?.label ?? Strings.secteurActiviteAll,
        value: secteurActivite,
        groupValue: selectedValue,
        onChanged: onChanged,
      ),
    );
  }
}
