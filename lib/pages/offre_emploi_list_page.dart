import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class OffreEmploiListPage extends StatelessWidget {
  OffreEmploiListPage._(this._items);
  final List<OffreEmploiItemViewModel> _items;

  static MaterialPageRoute materialPageRoute(List<OffreEmploiItemViewModel> items) {
    return MaterialPageRoute(
        builder: (context) => OffreEmploiListPage._(items), settings: AnalyticsRouteSettings.offreEmploiList());
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold(context);
  }

  Widget _scaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: FlatDefaultAppBar(
        title: Text(Strings.offresEmploiTitle, style: TextStyles.textLgMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.zero),
          child: Container(
            color: Colors.white,
            child: ListView.separated(
              itemBuilder: (context, index) => _buildItem(context, _items[index]),
              separatorBuilder: (context, index) => _listSeparator(),
              itemCount: _items.length,
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
          if (itemViewModel.companyName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                itemViewModel.companyName!,
                style: TextStyles.textSmRegular(color: AppColors.bluePurple),
              ),
            ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _lightBlueTag(label: itemViewModel.contractType),
              if (itemViewModel.duration != null) _lightBlueTag(label: itemViewModel.duration!),
              if (itemViewModel.location != null) _lightBlueTag(label: itemViewModel.location!, icon: SvgPicture.asset("assets/ic_place.svg")),
            ],
          )
        ],
      ),
    );
  }

  Widget _listSeparator() => Container(height: 1, color: AppColors.bluePurpleAlpha20);

  Container _lightBlueTag({required String label, SvgPicture? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: icon,
                ),
              Flexible(
                child: Text(
                  label,
                  style: TextStyles.textSmRegular(),
                ),
              ),
            ],
          )),
    );
  }
}
