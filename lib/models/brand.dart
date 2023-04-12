enum Brand {
  CEJ,
  BRSA;

  static late Brand brand;

  static void setBrand(Brand brand) => Brand.brand = brand;

  static bool isCej() => Brand.brand == Brand.CEJ;
  static bool isBrsa() => Brand.brand == Brand.BRSA;
}
