import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class MetierAutocomplete extends StatelessWidget {
  final Function(Metier? selectedMetier) onSelectMetier;
  final String? Function() getPreviouslySelectedTitle;
  final String? Function(String? input) validator;
  final GlobalKey<FormState> formKey;
  final _metierRepository = MetierRepository();

  MetierAutocomplete({
    required this.onSelectMetier,
    required this.validator,
    required this.formKey,
    required this.getPreviouslySelectedTitle,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<Metier>(
        optionsBuilder: (textEditingValue) => _metierRepository.getMetiers(textEditingValue.text),
        onSelected: (option) => onSelectMetier(option),
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
    return Focus(
      onFocusChange: (hasFocus) => _putBackLastLocationSetOnFocusLost(hasFocus, textEditingController),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: TextFormField(
          scrollPadding: const EdgeInsets.only(bottom: 200.0),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          style: TextStyles.textBaseBold,
          controller: textEditingController,
          decoration: _inputDecoration(Strings.immersionFieldHint),
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          onChanged: (value) {
            if (value.isEmpty) onSelectMetier(null);
          },
          validator: validator,
        ),
      ),
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

  void _putBackLastLocationSetOnFocusLost(bool hasFocus, TextEditingController textEditingController) {
    var title = getPreviouslySelectedTitle();
    if (!hasFocus && title != null) {
      textEditingController.text = title;
    }
  }

  InputDecoration _inputDecoration(String textFieldString) {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.grey700, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.primary, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.warning, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.warning, width: 1.0),
      ),
    );
  }
}
