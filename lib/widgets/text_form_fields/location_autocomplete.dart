import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/autocomplete/location_displayable_extension.dart';
import 'package:pass_emploi_app/presentation/autocomplete/location_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/debounce_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/full_screen_text_form_field_scaffold.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/multiline_app_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/read_only_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/text_form_field_sep_line.dart';

const _heroTag = 'location';

class LocationAutocomplete extends StatefulWidget {
  final String title;
  final String hint;
  final Function(Location? location) onLocationSelected;
  final bool villesOnly;

  const LocationAutocomplete({
    required this.title,
    required this.hint,
    required this.onLocationSelected,
    this.villesOnly = false,
  });

  @override
  State<LocationAutocomplete> createState() => _LocationAutocompleteState();
}

class _LocationAutocompleteState extends State<LocationAutocomplete> {
  Location? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return ReadOnlyTextFormField(
      title: widget.title,
      hint: widget.hint,
      heroTag: _heroTag,
      textFormFieldKey: Key(_selectedLocation.toString()),
      withDeleteButton: _selectedLocation != null,
      onTextTap: () => Navigator.push(
        context,
        _LocationAutocompletePage.materialPageRoute(
          title: widget.title,
          hint: widget.hint,
          villesOnly: widget.villesOnly,
          selectedLocation: _selectedLocation,
        ),
      ).then((location) => _updateLocation(location)),
      onDeleteTap: () => _updateLocation(null),
      initialValue: _selectedLocation?.displayableLabel(),
    );
  }

  void _updateLocation(Location? location) {
    setState(() => _selectedLocation = location);
    widget.onLocationSelected(location);
  }
}

class _LocationAutocompletePage extends StatelessWidget {
  final String title;
  final String hint;
  final bool villesOnly;
  final Location? selectedLocation;

  _LocationAutocompletePage({required this.title, required this.hint, required this.villesOnly, this.selectedLocation});

  static MaterialPageRoute<Location?> materialPageRoute({
    required String title,
    required String hint,
    required bool villesOnly,
    required Location? selectedLocation,
  }) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => _LocationAutocompletePage(
        title: title,
        hint: hint,
        villesOnly: villesOnly,
        selectedLocation: selectedLocation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LocationViewModel>(
      converter: (store) => LocationViewModel.create(store),
      onInitialBuild: (viewModel) => viewModel.onInputLocation(selectedLocation?.libelle, villesOnly),
      onDispose: (store) => store.dispatch(SearchLocationResetAction()),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, LocationViewModel viewModel) {
    return FullScreenTextFormFieldScaffold(
      body: Column(
        children: [
          MultilineAppBar(
            title: title,
            hint: hint,
            onCloseButtonPressed: () => Navigator.pop(context, selectedLocation),
          ),
          DebounceTextFormField(
            heroTag: _heroTag,
            initialValue: selectedLocation?.displayableLabel(),
            onFieldSubmitted: (_) => Navigator.pop(context, viewModel.locations.firstOrNull),
            onChanged: (value) => viewModel.onInputLocation(value, villesOnly),
          ),
          TextFormFieldSepLine(),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final location = viewModel.locations[index];
                return _LocationListTile(
                  location: location,
                  onLocationTap: (location) => Navigator.pop(context, location),
                );
              },
              separatorBuilder: (context, index) => TextFormFieldSepLine(),
              itemCount: viewModel.locations.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationListTile extends StatelessWidget {
  final Location location;
  final Function(Location) onLocationTap;

  const _LocationListTile({required this.location, required this.onLocationTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Margins.spacing_l),
      title: RichText(
        text: TextSpan(
          text: location.libelle,
          style: TextStyles.textBaseBold,
          children: [
            TextSpan(text: ' '),
            TextSpan(text: location.displayableCode(), style: TextStyles.textBaseRegular),
          ],
        ),
      ),
      onTap: () => onLocationTap(location),
    );
  }
}
