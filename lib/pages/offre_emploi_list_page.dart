import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class OffreEmploiListPage extends StatelessWidget {
  const OffreEmploiListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiListPageViewModel>(
      onInit: (store) => store.dispatch(SearchOffreEmploiAction(keywords: "", department: "")),
      builder: (context, vm) => _scaffold(context, vm),
      converter: (store) => OffreEmploiListPageViewModel.create(store),
    );
  }

  Widget _scaffold(BuildContext context, OffreEmploiListPageViewModel listViewModel) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: FlatDefaultAppBar(
        title: Text(Strings.offresEmploiTitle, style: TextStyles.h3Semi),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.zero),
          child: Container(
            color: Colors.white,
            child: ListView.separated(
              itemBuilder: (context, index) => _buildItem(context, listViewModel.items[index]),
              separatorBuilder: (context, index) => _listSeparator(),
              itemCount: listViewModel.items.length,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, OffreEmploiItemViewModel itemViewModel) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            itemViewModel.title,
            style: TextStyles.textSmMedium(),
          ),
          SizedBox(height: 8),
          Text(
            itemViewModel.companyName,
            style: TextStyles.textSmRegular(color: AppColors.bluePurple),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              _tag(label: itemViewModel.contractType),
              SizedBox(width: 8),
              _tag(label: itemViewModel.location, icon: SvgPicture.asset("assets/ic_place.svg")),
            ],
          )
        ],
      ),
    );
  }

  Widget _listSeparator() => Container(height: 1, color: AppColors.bluePurpleAlpha20);

  Container _tag({required String label, SvgPicture? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: icon,
                ),
              Text(
                label,
                style: TextStyles.textSmRegular(),
              ),
            ],
          )),
    );
  }
}
