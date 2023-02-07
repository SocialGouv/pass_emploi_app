import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CriteresRechercheBandeau extends StatelessWidget {
  final int criteresActifsCount;

  const CriteresRechercheBandeau({required this.criteresActifsCount});

  @override
  Widget build(BuildContext context) {
    return Text(
      Intl.plural(
        criteresActifsCount,
        zero: Strings.rechercheCriteresActifsSingular(criteresActifsCount),
        one: Strings.rechercheCriteresActifsSingular(criteresActifsCount),
        other: Strings.rechercheCriteresActifsPlural(criteresActifsCount),
      ),
      style: TextStyles.textBaseMediumBold(color: null),
    );
  }
}
