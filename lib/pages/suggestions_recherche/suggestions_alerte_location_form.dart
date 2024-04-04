import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestion_alerte_location_form_view_model.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/apparition_animation.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/slider/distance_slider.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/location_autocomplete.dart';

class SuggestionsAlerteLocationForm extends StatefulWidget {
  final OffreType type;
  const SuggestionsAlerteLocationForm({super.key, required this.type});

  static MaterialPageRoute<(Location location, double rayon)> materialPageRoute({required OffreType type}) {
    return MaterialPageRoute(builder: (context) => SuggestionsAlerteLocationForm(type: type));
  }

  @override
  State<SuggestionsAlerteLocationForm> createState() => _SuggestionsAlerteLocationFormState();
}

class _SuggestionsAlerteLocationFormState extends State<SuggestionsAlerteLocationForm> {
  late SuggestionAlerteLocationFormViewModel viewModel;
  Location? _selectedLocation;
  double _selectedRayon = 10;

  @override
  void initState() {
    viewModel = SuggestionAlerteLocationFormViewModel.create(widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SecondaryAppBar(title: Strings.suggestionLocalisationAppBarTitle),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _SubmitButton(
          onPressed:
              _selectedLocation != null ? () => Navigator.pop(context, (_selectedLocation, _selectedRayon)) : null,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
                child: LocationAutocomplete(
                  title: Strings.locationTitle,
                  hint: viewModel.hint,
                  villesOnly: viewModel.villesOnly,
                  initialValue: _selectedLocation,
                  onLocationSelected: (location) {
                    setState(() {
                      _selectedLocation = location;
                      _selectedRayon = 10;
                    });
                  },
                ),
              ),
              SizedBox(height: Margins.spacing_l),
              if (_selectedLocation != null && _selectedLocation!.type == LocationType.COMMUNE)
                ApparitionAnimation(
                  child: DistanceSlider(
                    initialDistanceValue: _selectedRayon,
                    onValueChange: (value) => _selectedRayon = value,
                  ),
                ),
            ],
          ),
        ));
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryActionButton(
          label: Strings.suggestionLocalisationAddAlerteButton,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
