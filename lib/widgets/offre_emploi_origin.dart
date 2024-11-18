import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/image_path.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

enum OffreEmploiOriginSize { small, medium }

class OffreEmploiOrigin extends StatelessWidget {
  final String label;
  final ImagePath path;
  final OffreEmploiOriginSize size;

  const OffreEmploiOrigin({
    required this.label,
    required this.path,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ExcludeSemantics(
          child: switch (path) {
            final NetworkImagePath networkPath => _NetworkImage(networkPath.url, size),
            final AssetImagePath assetPath => _AssetsImage(assetPath.path, size),
          },
        ),
        SizedBox(width: Margins.spacing_s),
        Text(
          Strings.origin(label),
          style: TextStyles.textSMedium(),
        ),
      ],
    );
  }
}

class _AssetsImage extends StatelessWidget {
  final String path;
  final OffreEmploiOriginSize size;

  const _AssetsImage(this.path, this.size);

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
          path,
          width: size == OffreEmploiOriginSize.small ? 20 : 25,
          height: size == OffreEmploiOriginSize.small ? 20 : 25,
        ),
      ),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  final String url;
  final OffreEmploiOriginSize size;

  const _NetworkImage(this.url, this.size);

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
