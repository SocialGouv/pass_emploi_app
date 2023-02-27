import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

enum OffreFilter { tous, emploi, immersion, alternance, serviceCivique }

class OffreFiltersPage extends StatefulWidget {
  final OffreFilter initialFilter;
  const OffreFiltersPage({required this.initialFilter});

  static MaterialPageRoute<OffreFilter> materialPageRoute({OffreFilter initialFilter = OffreFilter.tous}) =>
      MaterialPageRoute(builder: (_) {
        return OffreFiltersPage(
          initialFilter: initialFilter,
        );
      });

  @override
  State<OffreFiltersPage> createState() => _OffreFiltersPageState();
}

class _OffreFiltersPageState extends State<OffreFiltersPage> {
  OffreFilter _selectedFilter = OffreFilter.tous;

  @override
  void initState() {
    _selectedFilter = widget.initialFilter;
    super.initState();
  }

  void _onFilterSelected(OffreFilter? filter) {
    setState(() {
      _selectedFilter = filter ?? OffreFilter.tous;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.filterList),
      body: _Body(onFilterSelected: _onFilterSelected, offreFilter: _selectedFilter),
      floatingActionButton: _ApplyFiltersButton(onPressed: () => Navigator.pop(context, _selectedFilter)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _Body extends StatelessWidget {
  final void Function(OffreFilter?) onFilterSelected;
  final OffreFilter offreFilter;
  const _Body({required this.onFilterSelected, required this.offreFilter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Margins.spacing_base),
          _OffreFilterSubtitle(),
          SizedBox(height: Margins.spacing_base),
          _buildRadioListTile(OffreFilter.tous, Strings.filterAll),
          _buildRadioListTile(OffreFilter.emploi, Strings.filterEmploi),
          _buildRadioListTile(OffreFilter.immersion, Strings.filterImmersion),
          _buildRadioListTile(OffreFilter.alternance, Strings.filterAlternance),
          _buildRadioListTile(OffreFilter.serviceCivique, Strings.filterServiceCivique),
        ],
      ),
    );
  }

  Widget _buildRadioListTile(OffreFilter value, String title) {
    return RadioListTile<OffreFilter>(
      contentPadding: EdgeInsets.zero,
      activeColor: AppColors.primary,
      title: Text(title),
      value: value,
      groupValue: offreFilter,
      onChanged: onFilterSelected,
    );
  }
}

class _OffreFilterSubtitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(Strings.filterByType, style: TextStyles.textBaseBold);
  }
}

class _ApplyFiltersButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _ApplyFiltersButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      onPressed: onPressed,
      label: Strings.applyFiltres,
    );
  }
}
