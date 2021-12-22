import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class MetierAutocomplete extends StatelessWidget {
  final Function(String selectedMetierRome) onSelectMetier;
  final _metierRepository = MetierRepository();

  MetierAutocomplete({required this.onSelectMetier}) : super();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<Metier>(
        optionsBuilder: (textEditingValue) => _metierRepository.getMetiers(textEditingValue.text),
        onSelected: (option) => onSelectMetier(option.codeRome),
        optionsViewBuilder: (context, onSelected, options) => _optionsView(constraints, options, onSelected),
        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) =>
            _fieldView(textEditingController, focusNode, onFieldSubmitted),
      ),
    );
  }

  Widget _fieldView(
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
    return TextFormField(
      scrollPadding: const EdgeInsets.only(bottom: 200.0),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      style: TextStyles.textSmMedium(color: AppColors.nightBlue),
      controller: textEditingController,
      decoration: _inputDecoration(Strings.immersionFieldHint),
      focusNode: focusNode,
      onFieldSubmitted: (String value) {
        onFieldSubmitted();
      },
      onChanged: (value) {
        if (value.isEmpty) onSelectMetier("");
      },
    );
  }

  Widget _optionsView(
    BoxConstraints constraints,
    Iterable<Metier> options,
    AutocompleteOnSelected<Metier> onSelected,
  ) {
    return Align(
        alignment: Alignment.topLeft,
        child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
          ),
          child: Container(
            width: constraints.biggest.width,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final Metier option = options.elementAt(index);

                return GestureDetector(
                  onTap: () {
                    onSelected(option);
                  },
                  child: ListTile(
                    title: Text(option.libelle, style: TextStyles.textSmRegular()),
                  ),
                );
              },
            ),
            color: Colors.white,
          ),
          color: Colors.white,
        ));
  }

  InputDecoration _inputDecoration(String textFieldString) {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18),
      labelText: textFieldString,
      labelStyle: TextStyles.textSmMedium(color: AppColors.bluePurple),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.nightBlue, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.nightBlue, width: 1.0),
      ),
    );
  }
}
