import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
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
        _Slider(
          onValueChange: (value) => _onValueChange(value),
          currentValue: _sliderValueToDisplay(widget.initialDistanceValue),
        ),
        SliderCaption(),
      ],
    );
  }

  void _onValueChange(double value) {
    if (value > 0) {
      setState(() => _currentSliderValue = value);
      widget.onValueChange(value);
    }
  }

  double _sliderValueToDisplay(double initialDistanceValue) =>
      _currentSliderValue != null ? _currentSliderValue! : initialDistanceValue;
}

class _Slider extends StatelessWidget {
  final Function(double) onValueChange;
  final double currentValue;

  _Slider({required this.onValueChange, required this.currentValue});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: Dimens.icon_size_base),
      ),
      child: Slider(
        value: currentValue,
        min: 0,
        max: 100,
        divisions: 10,
        onChanged: (value) => onValueChange(value),
      ),
    );
  }
}
