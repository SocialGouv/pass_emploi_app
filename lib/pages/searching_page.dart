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

class OffreEmploiSearchingPage extends StatefulWidget {

  @override
  State<OffreEmploiSearchingPage> createState() => _OffreEmploiSearchingPageState();
}

class _OffreEmploiSearchingPageState extends State<OffreEmploiSearchingPage> {
  var _keyWord = "";
  var _department = "";

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiListPageViewModel>(
        converter: (store) => OffreEmploiListPageViewModel.create(store),
        onWillChange: (previousVm, newVm) {
          if (newVm.displayState == OffreEmploiListDisplayState.SHOW_CONTENT) {
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

  Widget _body(OffreEmploiListPageViewModel viewModel) {
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
        Autocomplete<Department>(optionsBuilder: (textEditingValue) {
            return viewModel.filterDepartments(textEditingValue.text);
        },
          onSelected: (department) {
          _department = department.number;
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode, VoidCallback onFieldSubmitted) {
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
      ],
    );
  }

  Widget _searchOffersButton(BuildContext context, OffreEmploiListPageViewModel viewModel) {
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

  void _searchingRequest(OffreEmploiListPageViewModel viewModel) {
    viewModel.searchingRequest(_keyWord, _department);
  }

  void _showOffresListPage(BuildContext context, OffreEmploiListPageViewModel viewModel) {
    Navigator.push(context, OffreEmploiListPage.materialPageRoute(viewModel.items));
  }

}