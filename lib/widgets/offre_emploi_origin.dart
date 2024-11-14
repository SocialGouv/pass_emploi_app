import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

// TODO-GAD : temp
const _url =
    "https://cdn.prod.website-files.com/6262d0e912ed03ea98f01f38/66f425f5441e26f8f8c62dcb_66f1408f48d93c9276487790_meteojob.png";

enum OffreEmploiOriginSize { small, medium }

class OffreEmploiOrigin extends StatelessWidget {
  final String label;
  final String url;
  final OffreEmploiOriginSize size;

  const OffreEmploiOrigin({
    required this.label,
    required this.url,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ExcludeSemantics(child: _UrlLogo(_url, size)),
        SizedBox(width: Margins.spacing_s),
        ExcludeSemantics(child: _FranceTravailLogo(size)),
        SizedBox(width: Margins.spacing_s),
        Text(
          Strings.origin(label),
          style: TextStyles.textSMedium(),
        ),
      ],
    );
  }
}

class _FranceTravailLogo extends StatelessWidget {
  final OffreEmploiOriginSize size;

  const _FranceTravailLogo(this.size);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        border: Border.all(color: AppColors.grey500),
      ),
      child: Padding(
        padding: EdgeInsets.all(size == OffreEmploiOriginSize.small ? 2 : 3),
        child: Image.asset(
          Drawables.franceTravailLogo,
          width: size == OffreEmploiOriginSize.small ? 20 : 25,
          height: size == OffreEmploiOriginSize.small ? 20 : 25,
        ),
      ),
    );
  }
}

class _UrlLogo extends StatelessWidget {
  final String url;
  final OffreEmploiOriginSize size;

  const _UrlLogo(this.url, this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size == OffreEmploiOriginSize.small ? 24 : 31,
      height: size == OffreEmploiOriginSize.small ? 24 : 31,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        border: Border.all(color: AppColors.grey500),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
