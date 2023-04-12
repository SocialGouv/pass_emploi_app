enum Brand {
  CEJ,
  BRSA;

  static late Brand _brand;

  static void setBrand(Brand brand) => Brand._brand = brand;
  static bool isCej() => Brand._brand == Brand.CEJ;
  static bool isBrsa() => Brand._brand == Brand.BRSA;
}
