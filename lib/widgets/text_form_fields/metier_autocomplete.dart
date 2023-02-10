import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/presentation/autocomplete/metier_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/debounce_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/full_screen_text_form_field_scaffold.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/multiline_app_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/read_only_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/text_form_field_sep_line.dart';

const _heroTag = 'metier';

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
    return ReadOnlyTextFormField(
      title: widget.title,
      heroTag: _heroTag,
      textFormFieldKey: Key(_selectedMetier.toString()),
      withDeleteButton: _selectedMetier != null,
      onTextTap: () => Navigator.push(
        context,
        _MetierAutocompletePage.materialPageRoute(
          title: widget.title,
          selectedMetier: _selectedMetier,
        ),
      ).then((metier) => _updateMetier(metier)),
      onDeleteTap: () => _updateMetier(null),
      initialValue: _selectedMetier?.libelle,
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
      onDispose: (store) => store.dispatch(SearchMetierResetAction()),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, MetierViewModel viewModel) {
    return FullScreenTextFormFieldScaffold(
      body: Column(
        children: [
          MultilineAppBar(
            title: title,
            onCloseButtonPressed: () => Navigator.pop(context, selectedMetier),
          ),
          DebounceTextFormField(
            heroTag: _heroTag,
            initialValue: selectedMetier?.libelle,
            onFieldSubmitted: (_) => Navigator.pop(context, viewModel.metiers.firstOrNull),
            onChanged: (value) => viewModel.onInputMetier(value),
          ),
          TextFormFieldSepLine(),
          Expanded(
            child: ListView.separated(
              itemCount: viewModel.metiers.length,
              separatorBuilder: (context, index) => TextFormFieldSepLine(),
              itemBuilder: (context, index) {
                return _MetierListTile(
                  metier: viewModel.metiers[index],
                  onMetierTap: (metier) => Navigator.pop(context, metier),
                );
              },
            ),
          ),
        ],
      ),
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
      title: Text(metier.libelle, style: TextStyles.textBaseRegular),
      onTap: () => onMetierTap(metier),
    );
  }
}
