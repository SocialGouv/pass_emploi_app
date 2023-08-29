import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/animated_list_loader.dart';

class RendezVousListLoader extends StatelessWidget {
  const RendezVousListLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final placeholders = _placeholders(screenWidth);
    return AnimatedListLoader(
      placeholders: placeholders,
    );
  }

  List<Widget> _placeholders(double screenWidth) => [
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(width: screenWidth * 0.4, height: 28, alignment: Alignment.center),
        SizedBox(height: Margins.spacing_s),
        AnimatedListLoader.placeholderBuilder(width: screenWidth * 0.6, height: 28, alignment: Alignment.center),
        SizedBox(height: Margins.spacing_l),
        AnimatedListLoader.placeholderBuilder(width: screenWidth, height: 35, alignment: Alignment.center),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(width: screenWidth, height: 180),
        SizedBox(height: Margins.spacing_m),
        AnimatedListLoader.placeholderBuilder(width: screenWidth, height: 35, alignment: Alignment.center),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(width: screenWidth, height: 180),
      ];
}
