enum Brand {
  cej,
  brsa;

  static late Brand brand;

  static void setBrand(Brand brand) => Brand.brand = brand;

  static bool isCej() => Brand.brand == Brand.cej;
  static bool isBrsa() => Brand.brand == Brand.brsa;
}

extension BrandExt on Brand? {
  bool get isBrsa => this == Brand.brsa;

  bool get isCej => this == Brand.cej;
}
