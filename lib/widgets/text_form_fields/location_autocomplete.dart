import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/autocomplete/location_displayable_extension.dart';
import 'package:pass_emploi_app/presentation/autocomplete/location_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/debouncer.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: TextStyles.textBaseBold),
            Text(widget.hint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
          ],
        ),
        SizedBox(height: Margins.spacing_base),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Hero(
              tag: 'location',
              child: Material(
                type: MaterialType.transparency,
                child: TextFormField(
                  key: Key(_selectedLocation.toString()),
                  style: TextStyles.textBaseBold,
                  decoration: _inputDecoration(),
                  readOnly: true,
                  initialValue: _selectedLocation?.displayableLabel(),
                  onTap: () => Navigator.push(
                    context,
                    _LocationAutocompletePage.materialPageRoute(
                      title: widget.title,
                      hint: widget.hint,
                      villesOnly: widget.villesOnly,
                      selectedLocation: _selectedLocation,
                    ),
                  ).then((location) => _updateLocation(location)),
                ),
              ),
            ),
            if (_selectedLocation != null)
              IconButton(
                onPressed: () => _updateLocation(null),
                tooltip: Strings.suppressionLabel,
                icon: const Icon(Icons.close),
              ),
          ],
        ),
      ],
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
  final Debouncer _debouncer = Debouncer(duration: Duration(milliseconds: 200));

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
    const backgroundColor = Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      // Required to delegate top padding to system
      appBar: AppBar(toolbarHeight: 0, scrolledUnderElevation: 0),
      body: Column(
        children: [
          _FakeAppBar(title: title, hint: hint, onCloseButtonPressed: () => Navigator.pop(context, selectedLocation)),
          Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Hero(
              tag: 'location',
              child: Material(
                type: MaterialType.transparency,
                child: TextFormField(
                  style: TextStyles.textBaseBold,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => Navigator.pop(context, viewModel.locations.firstOrNull),
                  initialValue: selectedLocation?.displayableLabel(),
                  decoration: _inputDecoration(),
                  autofocus: true,
                  onChanged: (value) => _debouncer.run(() => viewModel.onInputLocation(value, villesOnly)),
                ),
              ),
            ),
          ),
          Container(color: AppColors.grey100, height: 1),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final location = viewModel.locations[index];
                return _LocationListTile(
                  location: location,
                  onLocationTap: (location) => Navigator.pop(context, location),
                );
              },
              separatorBuilder: (context, index) => Container(color: AppColors.grey100, height: 1),
              itemCount: viewModel.locations.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _FakeAppBar extends StatelessWidget {
  final String title;
  final String hint;
  final VoidCallback onCloseButtonPressed;

  const _FakeAppBar({required this.title, required this.hint, required this.onCloseButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: kToolbarHeight, height: kToolbarHeight),
          child: IconButton(
            onPressed: onCloseButtonPressed,
            tooltip: Strings.close,
            icon: const Icon(Icons.close),
          ),
        ),
        SizedBox(width: Margins.spacing_base),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyles.textBaseBold),
              Text(hint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
            ],
          ),
        )
      ],
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

InputDecoration _inputDecoration() {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(
      left: Margins.spacing_base,
      right: Margins.spacing_xl,
      top: Margins.spacing_base,
      bottom: Margins.spacing_base,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: AppColors.primary, width: 1.0),
    ),
  );
}
