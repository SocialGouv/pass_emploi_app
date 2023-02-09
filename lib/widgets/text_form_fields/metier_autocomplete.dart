import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/presentation/autocomplete/metier_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/debouncer.dart';

class MetierAutocomplete extends StatefulWidget {
  final String title;
  final Function(Metier? location) onMetierSelected;

  const MetierAutocomplete({
    required this.title,
    required this.onMetierSelected,
  });

  @override
  State<MetierAutocomplete> createState() => _MetierAutocompleteState();
}

class _MetierAutocompleteState extends State<MetierAutocomplete> {
  Metier? _selectedMetier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(widget.title, style: TextStyles.textBaseBold)],
        ),
        SizedBox(height: Margins.spacing_base),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Hero(
              tag: 'metier',
              child: Material(
                type: MaterialType.transparency,
                child: TextFormField(
                  key: Key(_selectedMetier.toString()),
                  style: TextStyles.textBaseBold,
                  decoration: _inputDecoration(),
                  readOnly: true,
                  initialValue: _selectedMetier?.libelle,
                  onTap: () => Navigator.push(
                    context,
                    _MetierAutocompletePage.materialPageRoute(
                      title: widget.title,
                      selectedMetier: _selectedMetier,
                    ),
                  ).then((location) => _updateMetier(location)),
                ),
              ),
            ),
            if (_selectedMetier != null)
              IconButton(
                onPressed: () => _updateMetier(null),
                tooltip: Strings.suppressionLabel,
                icon: const Icon(Icons.close),
              ),
          ],
        ),
      ],
    );
  }

  void _updateMetier(Metier? metier) {
    setState(() => _selectedMetier = metier);
    widget.onMetierSelected(metier);
  }
}

class _MetierAutocompletePage extends StatelessWidget {
  final String title;
  final Metier? selectedMetier;
  final Debouncer _debouncer = Debouncer(duration: Duration(milliseconds: 200));

  _MetierAutocompletePage({required this.title, this.selectedMetier});

  static MaterialPageRoute<Metier?> materialPageRoute({
    required String title,
    required Metier? selectedMetier,
  }) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => _MetierAutocompletePage(
        title: title,
        selectedMetier: selectedMetier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MetierViewModel>(
      converter: (store) => MetierViewModel.create(store),
      onInitialBuild: (viewModel) => viewModel.onInputMetier(selectedMetier?.libelle),
      onDispose: (store) => store.dispatch(SearchLocationResetAction()),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, MetierViewModel viewModel) {
    const backgroundColor = Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      // Required to delegate top padding to system
      appBar: AppBar(toolbarHeight: 0, scrolledUnderElevation: 0),
      body: Column(
        children: [
          _FakeAppBar(title: title, onCloseButtonPressed: () => Navigator.pop(context, selectedMetier)),
          Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Hero(
              tag: 'metier',
              child: Material(
                type: MaterialType.transparency,
                child: TextFormField(
                  style: TextStyles.textBaseBold,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => Navigator.pop(context, viewModel.metiers.firstOrNull),
                  initialValue: selectedMetier?.libelle,
                  decoration: _inputDecoration(),
                  autofocus: true,
                  onChanged: (value) => _debouncer.run(() => viewModel.onInputMetier(value)),
                ),
              ),
            ),
          ),
          Container(color: AppColors.grey100, height: 1),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final metier = viewModel.metiers[index];
                return _MetierListTile(
                  metier: metier,
                  onMetierTap: (location) => Navigator.pop(context, location),
                );
              },
              separatorBuilder: (context, index) => Container(color: AppColors.grey100, height: 1),
              itemCount: viewModel.metiers.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _FakeAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onCloseButtonPressed;

  const _FakeAppBar({required this.title, required this.onCloseButtonPressed});

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
            children: [Text(title, style: TextStyles.textBaseBold)],
          ),
        )
      ],
    );
  }
}

class _MetierListTile extends StatelessWidget {
  final Metier metier;
  final Function(Metier) onMetierTap;

  const _MetierListTile({required this.metier, required this.onMetierTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Margins.spacing_l),
      title: Text(metier.libelle, style: TextStyles.textBaseBold),
      onTap: () => onMetierTap(metier),
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
