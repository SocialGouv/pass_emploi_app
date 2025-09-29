import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/presentation/offre_filters_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/radio_list_tile.dart';

enum OffreFilter { tous, emploi, immersion, alternance, serviceCivique }

class OffreFiltersBottomSheet extends StatefulWidget {
  final OffreFilter initialFilter;

  const OffreFiltersBottomSheet({required this.initialFilter});

  static Future<OffreFilter?> show(BuildContext context, OffreFilter initialFilter) {
    return showPassEmploiBottomSheet(
      context: context,
      builder: (context) => OffreFiltersBottomSheet(initialFilter: initialFilter),
    );
  }

  @override
  State<OffreFiltersBottomSheet> createState() => _OffreFiltersBottomSheetState();
}

class _OffreFiltersBottomSheetState extends State<OffreFiltersBottomSheet> {
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
    return StoreConnector<AppState, OffreFiltersPageViewModel>(
      converter: (store) => OffreFiltersPageViewModel.create(store),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, OffreFiltersPageViewModel viewModel) {
    return BottomSheetWrapper(
      title: Strings.filterList,
      body: Scaffold(
        backgroundColor: Colors.white,
        body: _Body(
          onFilterSelected: _onFilterSelected,
          offreFilter: _selectedFilter,
          offreTypes: viewModel.offreTypes,
        ),
        floatingActionButton: _ApplyFiltersButton(onPressed: () => Navigator.pop(context, _selectedFilter)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final void Function(OffreFilter?) onFilterSelected;
  final OffreFilter offreFilter;
  final List<OffreType> offreTypes;

  const _Body({
    required this.onFilterSelected,
    required this.offreFilter,
    required this.offreTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Margins.spacing_base),
        _OffreFilterSubtitle(),
        SizedBox(height: Margins.spacing_base),
        _buildRadioGroup(OffreFilter.tous, Strings.filterAll),
        if (offreTypes.contains(OffreType.emploi)) _buildRadioGroup(OffreFilter.emploi, Strings.filterEmploi),
        if (offreTypes.contains(OffreType.alternance))
          _buildRadioGroup(OffreFilter.alternance, Strings.filterAlternance),
        if (offreTypes.contains(OffreType.immersion)) _buildRadioGroup(OffreFilter.immersion, Strings.filterImmersion),
        if (offreTypes.contains(OffreType.serviceCivique))
          _buildRadioGroup(OffreFilter.serviceCivique, Strings.filterServiceCivique),
      ],
    );
  }

  Widget _buildRadioGroup(OffreFilter value, String title) {
    return CustomRadioGroup<OffreFilter>(
      title: title,
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
