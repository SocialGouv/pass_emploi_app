enum Brand {
  cej,
  passEmploi;

  static late Brand brand;

  static void setBrand(Brand brand) => Brand.brand = brand;

  static bool isCej() => Brand.brand == Brand.cej;

  static bool isPassEmploi() => Brand.brand == Brand.passEmploi;

  static String getAppStoreIdiOS() {
    if (brand.isCej) {
      return '1581603519';
    } else if (brand.isPassEmploi) {
      return '6448051621';
    }
    return "";
  }
}

extension BrandExt on Brand? {
  bool get isPassEmploi => this == Brand.passEmploi;

  bool get isCej => this == Brand.cej;
}
