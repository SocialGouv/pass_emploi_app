import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class OffreEmploiFiltresPage extends TraceableStatefulWidget {
  OffreEmploiFiltresPage() : super(name: AnalyticsScreenNames.offreEmploiFiltres);

  static MaterialPageRoute materialPageRoute() => MaterialPageRoute(builder: (_) => OffreEmploiFiltresPage());

  @override
  State<OffreEmploiFiltresPage> createState() => _OffreEmploiFiltresPageState();
}

class _OffreEmploiFiltresPageState extends State<OffreEmploiFiltresPage> {
  var _currentSliderValue = 10.0;
  var _hasFormChanged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FlatDefaultAppBar(
        title: Text(Strings.offresEmploiFiltresTitle, style: TextStyles.textLgMedium),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _sliderValue(),
            ),
            _slider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _sliderLegende(),
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(height: 1, color: AppColors.bluePurple),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: _stretchedButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderValue() {
    return Row(
      children: [
        Text("Dans un rayon de : ", style: TextStyles.textMdRegular),
        Text("${_currentSliderValue.toInt()} km", style: TextStyles.textMdMedium),
      ],
    );
  }

  Widget _slider() {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 6.0,
        activeTrackColor: AppColors.nightBlue,
        inactiveTrackColor: AppColors.bluePurple,
        thumbColor: AppColors.nightBlue,
        activeTickMarkColor: AppColors.nightBlue,
        inactiveTickMarkColor: AppColors.bluePurple,
        //overlayShape: SliderComponentShape.noThumb,
      ),
      child: Slider(
        value: _currentSliderValue,
        min: 0,
        max: 100,
        divisions: 10,
        onChanged: (value) {
          if (value > 0)
            setState(() {
              _currentSliderValue = value;
              _hasFormChanged = true;
            });
        },
      ),
    );
  }

  Widget _sliderLegende() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("0km", style: TextStyles.textSmMedium()),
        Text("100km", style: TextStyles.textSmMedium()),
      ],
    );
  }

  Widget _stretchedButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        primaryActionButton(
          onPressed: _hasFormChanged ? () => Navigator.pop(context) : null ,
          label: "Appliquer les filtres",
        ),
      ],
    );
  }
}
