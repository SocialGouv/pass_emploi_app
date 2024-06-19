enum LoginMode {
  MILO("MILO"),
  POLE_EMPLOI("POLE_EMPLOI"),
  DEMO_PE("DEMO_PE"),
  DEMO_MILO("DEMO_MILO");

  final String value;

  const LoginMode(this.value);

  static LoginMode fromString(String value) {
    return LoginMode.values.firstWhere((e) => e.value == value, orElse: () => LoginMode.POLE_EMPLOI);
  }
}

extension LoginModeExtension on LoginMode? {
  bool isDemo() => this == LoginMode.DEMO_PE || this == LoginMode.DEMO_MILO;

  bool isPe() => this == LoginMode.DEMO_PE || this == LoginMode.POLE_EMPLOI;

  bool isMiLo() => this == LoginMode.DEMO_MILO || this == LoginMode.MILO;
}
