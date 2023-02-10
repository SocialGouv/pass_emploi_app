import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/debouncer.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';

//TODO-1391 Delete
class MetierAutocomplete extends StatelessWidget {
  final Function(String newMetierQuery) onInputMetier;
  final Function(Metier? selectedMetier) onSelectMetier;
  final String? Function() getPreviouslySelectedTitle;
  final List<Metier> metiers;
  final String? Function(String? input) validator;
  final GlobalKey<FormState> formKey;

  final Debouncer _debouncer = Debouncer(duration: Duration(milliseconds: 500));

  MetierAutocomplete({
    required this.onInputMetier,
    required this.metiers,
    required this.onSelectMetier,
    required this.validator,
    required this.formKey,
    required this.getPreviouslySelectedTitle,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<Metier>(
        optionsBuilder: (textEditingValue) {
          _debouncer.run(() {
            final newMetierQuery = textEditingValue.text;
            _deleteSelectedMetierOnTextDeletion(newMetierQuery);
            onInputMetier(newMetierQuery);
          });
          return _fakeListMetierRequiredByAutocompleteToCallOptionsViewBuilderMethod();
        },
        onSelected: (option) {
          Keyboard.dismiss(context);
          onSelectMetier(option);
        },
        optionsViewBuilder: (context, onSelected, options) => _optionsView(constraints, onSelected),
        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) =>
            _fieldView(textEditingController, focusNode, onFieldSubmitted),
      ),
    );
  }

  Widget _fieldView(TextEditingController textEditingController,
      FocusNode focusNode,
      VoidCallback onFieldSubmitted,) {
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
          validator: validator,
        ),
      ),
    );
  }

  Widget _optionsView(BoxConstraints constraints,
      AutocompleteOnSelected<Metier> onSelected,) {
    return Align(
        alignment: Alignment.topLeft,
        child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
          ),
          color: Colors.white,
          child: Container(
            width: constraints.biggest.width,
            color: Colors.white,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: metiers.length,
              itemBuilder: (BuildContext context, int index) {
                final Metier metier = metiers.elementAt(index);
                return GestureDetector(
                  onTap: () => onSelected(metier),
                  child: ListTile(title: Text(metier.libelle, style: TextStyles.textSRegular())),
                );
              },
            ),
          ),
        ));
  }

  void _putBackLastLocationSetOnFocusLost(bool hasFocus, TextEditingController textEditingController) {
    final title = getPreviouslySelectedTitle();
    if (!hasFocus && title != null) {
      textEditingController.text = title;
    }
  }

  void _deleteSelectedMetierOnTextDeletion(String newMetierQuery) {
    if (newMetierQuery.isEmpty) {
      onSelectMetier(null);
    }
  }

  List<Metier> _fakeListMetierRequiredByAutocompleteToCallOptionsViewBuilderMethod() =>
      [Metier(codeRome: "", libelle: "")];

  InputDecoration _inputDecoration(String textFieldString) {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        borderSide: BorderSide(color: AppColors.primary, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        borderSide: BorderSide(color: AppColors.warning, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        borderSide: BorderSide(color: AppColors.warning, width: 1.0),
      ),
    );
  }
}
