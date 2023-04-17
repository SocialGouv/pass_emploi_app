enum Brand {
  CEJ,
  BRSA;

  static late Brand brand;

  static void setBrand(Brand brand) => Brand.brand = brand;

  static bool isCej() => Brand.brand == Brand.CEJ;
  static bool isBrsa() => Brand.brand == Brand.BRSA;
}

extension BrandExt on Brand? {
  bool get isBrsa => this == Brand.BRSA;

  bool get isCej => this == Brand.CEJ;
}
