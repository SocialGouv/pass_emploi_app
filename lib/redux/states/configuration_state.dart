import 'package:pass_emploi_app/configuration/configuration.dart';

class ConfigurationState {
  /// Only visible for state reset
  ///
  /// To access build flavor you should use ConfigurationState#getFlavor
  final Configuration? configuration;

  ConfigurationState(this.configuration);

  Flavor getFlavor() {
    return configuration?.flavor ?? Flavor.PROD;
  }
}
