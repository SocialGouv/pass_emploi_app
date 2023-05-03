import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/platform.dart';

class ForceUpdateViewModel extends Equatable {
  final String label;
  final String storeUrl;
  final bool withCallToAction;

  ForceUpdateViewModel({
    required this.label,
    required this.storeUrl,
    required this.withCallToAction,
  });

  factory ForceUpdateViewModel.create(Brand brand, Flavor flavor, Platform platform) {
    return ForceUpdateViewModel(
      label: flavor == Flavor.STAGING ? Strings.forceUpdateOnFirebaseLabel : Strings.forceUpdateOnStoreLabel,
      storeUrl: _appStoreUrl(brand, flavor, platform),
      withCallToAction: flavor == Flavor.PROD,
    );
  }

  @override
  List<Object?> get props => [label, storeUrl, withCallToAction];
}

String _appStoreUrl(Brand brand, Flavor flavor, Platform platform) {
  return flavor == Flavor.PROD ? platform.getAppStoreUrl(brand) : '';
}
