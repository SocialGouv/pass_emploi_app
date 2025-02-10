enum Accompagnement {
  cej,
  rsaFranceTravail,
  rsaConseilsDepartementaux,
  aij,
  avenirPro;
}

extension AccompagnementExt on Accompagnement {
  static Accompagnement fromJson(String? accompagnement) {
    return switch (accompagnement) {
      "cej" => Accompagnement.cej,
      "rsaFranceTravail" => Accompagnement.rsaFranceTravail,
      "rsaConseilsDepartementaux" => Accompagnement.rsaConseilsDepartementaux,
      "aij" => Accompagnement.aij,
      "avenirPro" => Accompagnement.avenirPro,
      _ => throw Exception("Unknown accompagnement: $accompagnement"),
    };
  }
}
