import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/repositories/local_outil_repository.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class BoiteAOutilsPage extends StatelessWidget {
  final _outils = LocalOutilRepository.getBoiteAOutils();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBlue,
      child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, index) => SizedBox(height: 16),
          itemCount: _outils.length,
          itemBuilder: (context, index) => _item(context, _outils[index])),
    );
  }

  Widget _item(BuildContext context, Outil outil) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: InkWell(
        onTap: () {
          launch(outil.urlRedirect);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                SizedBox(height: 24),
                Text(outil.title, style: TextStyles.textMdMedium),
                SizedBox(height: 16),
                Text(outil.description, style: TextStyles.textSmRegular()),
                SizedBox(height: 16),
              ]),
            ),
            Container(height: 1, color: AppColors.bluePurpleAlpha20),
            SizedBox(height: 16),
            Center(child: Text(outil.actionLabel, style: TextStyles.textMdMedium)),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
