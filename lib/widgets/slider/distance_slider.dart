import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/slider/slider_caption.dart';
import 'package:pass_emploi_app/widgets/slider/slider_value.dart';

class DistanceSlider extends StatefulWidget {
  final double initialDistanceValue;
  final Function(double) onValueChange;

  DistanceSlider({required this.initialDistanceValue, required this.onValueChange});

  @override
  State<DistanceSlider> createState() => _DistanceSliderState();
}

class _DistanceSliderState extends State<DistanceSlider> {
  double? _currentSliderValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderValue(value: _sliderValueToDisplay(widget.initialDistanceValue).toInt()),
        _Selector(
          onValueChange: (value) => _onValueChange(value),
          currentValue: _sliderValueToDisplay(widget.initialDistanceValue),
        ),
      ],
    );
  }

  void _onValueChange(double value) {
    if (value > 0) {
      setState(() => _currentSliderValue = value);
      widget.onValueChange(value);
      Future.delayed(Duration(milliseconds: 100),
          () => SemanticsService.announce(Strings.distanceUpdated(value.toInt()), TextDirection.ltr));
    }
  }

  double _sliderValueToDisplay(double initialDistanceValue) =>
      _currentSliderValue != null ? _currentSliderValue! : initialDistanceValue;
}

class _Selector extends StatelessWidget {
  final Function(double) onValueChange;
  final double currentValue;

  _Selector({required this.onValueChange, required this.currentValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _DistanceButton(
          label: Strings.removeDistance(10),
          icon: AppIcons.remove,
          onPressed: () => onValueChange(currentValue - 10),
        ),
        Expanded(
          child: Semantics(
            excludeSemantics: true,
            child: Column(
              children: [
                Slider(
                  value: currentValue,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  onChanged: onValueChange,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
                  child: SliderCaption(),
                ),
              ],
            ),
          ),
        ),
        _DistanceButton(
          label: Strings.addDistance(10),
          icon: AppIcons.add,
          onPressed: () => onValueChange(currentValue + 10),
        ),
      ],
    );
  }
}

class _DistanceButton extends StatelessWidget {
  const _DistanceButton({required this.label, required this.icon, required this.onPressed});

  final String label;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
