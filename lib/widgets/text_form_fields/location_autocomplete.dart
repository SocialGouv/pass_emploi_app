import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/ignore_tracking_context_provider.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/autocomplete/location_displayable_extension.dart';
import 'package:pass_emploi_app/presentation/autocomplete/location_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/debounce_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/full_screen_text_form_field_scaffold.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/multiline_app_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/read_only_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/text_form_field_sep_line.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/title_tile.dart';

const _heroTag = 'location';

class LocationAutocomplete extends StatefulWidget {
  final String title;
  final String? hint;
  final Function(Location? location) onLocationSelected;
  final bool villesOnly;
  final Location? initialValue;

  const LocationAutocomplete({
    required this.title,
    this.hint,
    required this.onLocationSelected,
    this.villesOnly = false,
    this.initialValue,
  });

  @override
  State<LocationAutocomplete> createState() => _LocationAutocompleteState();
}

class _LocationAutocompleteState extends State<LocationAutocomplete> {
  Location? _selectedLocation;

  @override
  void initState() {
    _selectedLocation = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.title,
      child: ReadOnlyTextFormField(
        title: widget.title,
        hint: widget.hint,
        heroTag: _heroTag,
        textFormFieldKey: Key(_selectedLocation.toString()),
        withDeleteButton: _selectedLocation != null,
        onTextTap: () => Navigator.push(
          IgnoreTrackingContext.of(context).nonTrackingContext,
          _LocationAutocompletePage.materialPageRoute(
            title: widget.title,
            hint: widget.hint,
            villesOnly: widget.villesOnly,
            selectedLocation: _selectedLocation,
          ),
        ).then((location) => _updateLocation(location)),
        onDeleteTap: () => _updateLocation(null),
        initialValue: _selectedLocation?.displayableLabel(),
      ),
    );
  }

  void _updateLocation(Location? location) {
    setState(() => _selectedLocation = location);
    widget.onLocationSelected(location);
  }
}

class _LocationAutocompletePage extends StatefulWidget {
  final String title;
  final String? hint;
  final bool villesOnly;
  final Location? selectedLocation;

  _LocationAutocompletePage({required this.title, required this.hint, required this.villesOnly, this.selectedLocation});

  static MaterialPageRoute<Location?> materialPageRoute({
    required String title,
    required String? hint,
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
  State<_LocationAutocompletePage> createState() => _LocationAutocompletePageState();
}

class _LocationAutocompletePageState extends State<_LocationAutocompletePage> {
  bool emptyInput = true;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LocationViewModel>(
      converter: (store) => LocationViewModel.create(store, villesOnly: widget.villesOnly),
      onInitialBuild: _onInitialBuild,
      onDispose: (store) => store.dispatch(SearchLocationResetAction()),
      builder: _builder,
      distinct: true,
    );
  }

  void _onInitialBuild(LocationViewModel viewModel) {
    if (viewModel.dernieresLocations.isNotEmpty) {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.lastRechercheLocationEventCategory,
        action: AnalyticsEventNames.lastRechercheLocationDisplayAction,
      );
    }
    viewModel.onInputLocation(widget.selectedLocation?.libelle);
  }

  Widget _builder(BuildContext context, LocationViewModel viewModel) {
    final autocompleteItems = viewModel.getAutocompleteItems(emptyInput);
    return FullScreenTextFormFieldScaffold(
      body: Column(
        children: [
          MultilineAppBar(
            title: widget.title,
            hint: widget.hint,
            onCloseButtonPressed: () => Navigator.pop(context, widget.selectedLocation),
          ),
          DebounceTextFormField(
            heroTag: _heroTag,
            initialValue: widget.selectedLocation?.displayableLabel(),
            onChanged: (text) {
              if (text.isEmpty != emptyInput) setState(() => emptyInput = text.isEmpty);
              viewModel.onInputLocation(text);
            },
          ),
          TextFormFieldSepLine(),
          Expanded(
            child: ListView.separated(
              itemCount: autocompleteItems.length,
              separatorBuilder: (context, index) => TextFormFieldSepLine(),
              itemBuilder: (context, index) {
                final item = autocompleteItems[index];
                if (item is LocationTitleItem) return TitleTile(title: item.title);
                if (item is LocationSuggestionItem) {
                  return _LocationListTile(
                    location: item.location,
                    source: item.source,
                    onLocationTap: (location) => Navigator.pop(context, location),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationListTile extends StatelessWidget {
  final Location location;
  final LocationSource source;
  final Function(Location) onLocationTap;

  const _LocationListTile({required this.location, required this.source, required this.onLocationTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Margins.spacing_l),
      title: Row(
        children: [
          if (source == LocationSource.dernieresRecherches) ...[
            Icon(AppIcons.schedule_rounded, size: Dimens.icon_size_base, color: AppColors.grey800),
            SizedBox(width: Margins.spacing_s),
          ],
          RichText(
            text: TextSpan(
              text: location.libelle,
              style: TextStyles.textBaseBold,
              children: [
                TextSpan(text: ' '),
                TextSpan(text: location.displayableCode(), style: TextStyles.textBaseRegular),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        if (source == LocationSource.dernieresRecherches) {
          PassEmploiMatomoTracker.instance.trackEvent(
            eventCategory: AnalyticsEventNames.lastRechercheLocationEventCategory,
            action: AnalyticsEventNames.lastRechercheLocationClickAction,
          );
        }
        onLocationTap(location);
      },
    );
  }
}
