import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/department.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class OffreEmploiSearchPage extends StatefulWidget {

  @override
  State<OffreEmploiSearchPage> createState() => _OffreEmploiSearchPageState();
}

class _OffreEmploiSearchPageState extends State<OffreEmploiSearchPage> {
  var _keyWord = "";
  var _department = "";

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiSearchViewModel>(
        converter: (store) => OffreEmploiSearchViewModel.create(store),
        onWillChange: (previousVm, newVm) {
          if (newVm.displayState == OffreEmploiSearchDisplayState.SHOW_CONTENT) {
            _showOffresListPage(context, newVm);
          }
        },
        builder: (context, viewModel) {
          return Scaffold(
            appBar: _appBar(Strings.searchingPageTitle),
            body: Container(
                    margin: EdgeInsets.only(left: 16, right: 16),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                          Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40),),
                          SizedBox(height: 20,),
                          _body(viewModel),
                          SizedBox(height: 40,),
                          _searchOffersButton(context, viewModel),
                        ],
                    )
          )
          );
        }
    );
  }

  AppBar _appBar(String title) {
    return DefaultAppBar(
      title: Text(title, style: TextStyles.h3Semi),
    );
  }

  Widget _body(OffreEmploiSearchViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: Margins.small, bottom: Margins.small),
          child: Text(Strings.keyWordsTitle, style: TextStyles.textLgMedium),
        ),
        TextFormField(
          style: TextStyles.textSmMedium(color: AppColors.nightBlue),
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) return Strings.mandatoryAccessCodeError;
            return null;
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18),
            labelText: Strings.keyWordsTextField,
            labelStyle: TextStyles.textSmMedium(color: AppColors.bluePurple),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.nightBlue, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.nightBlue, width: 1.0),
            ),
          ),
          onChanged: (keyword) {
            _keyWord = keyword;
          },
        ),
        SizedBox(height: 24,),

        Padding(
          padding: const EdgeInsets.only(top: Margins.small, bottom: Margins.small),
          child: Text(Strings.departmentTitle, style: TextStyles.textLgMedium),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Autocomplete<Department>(
            optionsBuilder: (textEditingValue) {
              return viewModel.filterDepartments(textEditingValue.text);
            },
            onSelected: (department) {
              _department = department.number;
            },
            optionsViewBuilder:
                (BuildContext context, AutocompleteOnSelected<Department> onSelected, Iterable<Department> options) {
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
                          final Department option = options.elementAt(index);

                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                            },
                            child: ListTile(
                              title: Text(option.name, style: const TextStyle(color: AppColors.nightBlue)),
                            ),
                          );
                        },
                      ),
                      color: Colors.white,
                    ),
                    color: Colors.white,
                  ));
            },
            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                decoration:InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18),
                  labelText: Strings.departmentTextField,
                  labelStyle: TextStyles.textSmMedium(color: AppColors.bluePurple),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: AppColors.nightBlue, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: AppColors.nightBlue, width: 1.0),
                  ),
                ),
              focusNode: focusNode,
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
            );
          },

        ),
        ),
      ],
    );
  }

  Widget _searchOffersButton(BuildContext context, OffreEmploiSearchViewModel viewModel) {
    return  Material(
      child: Ink(
        decoration: BoxDecoration(color: AppColors.nightBlue, borderRadius: BorderRadius.all(Radius.circular(30))),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          onTap: () => _searchingRequest(viewModel),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(Strings.searchButton, style: TextStyles.textSmMedium(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  void _searchingRequest(OffreEmploiSearchViewModel viewModel) {
    viewModel.searchingRequest(_keyWord, _department);
  }

  void _showOffresListPage(BuildContext context, OffreEmploiSearchViewModel viewModel) {
    Navigator.push(context, OffreEmploiListPage.materialPageRoute(viewModel.items));
  }

}