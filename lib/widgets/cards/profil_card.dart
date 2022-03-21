import 'package:flutter/material.dart';

import '../../ui/margins.dart';
import '../../ui/shadows.dart';

class ProfilCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const ProfilCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(Margins.spacing_base),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16)), boxShadow: [
        Shadows.boxShadow,
      ]),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
