enum Accompagnement {
  cej,
  rsaFranceTravail,
  rsaConseilsDepartementaux,
  aij,
  avenirPro,
  accompagnementIntensif,
  accompagnementGlobal,
  equipEmploiRecrut;
}

extension AccompagnementExt on Accompagnement {
  static Accompagnement fromRemoteConfigJson(String? accompagnement) {
    return switch (accompagnement) {
      "cej" => Accompagnement.cej,
      "rsaFranceTravail" => Accompagnement.rsaFranceTravail,
      "rsaConseilsDepartementaux" => Accompagnement.rsaConseilsDepartementaux,
      "aij" => Accompagnement.aij,
      "avenirPro" => Accompagnement.avenirPro,
      "accompagnementIntensif" => Accompagnement.accompagnementIntensif,
      "accompagnementGlobal" => Accompagnement.accompagnementGlobal,
      "equipEmploiRecrut" => Accompagnement.equipEmploiRecrut,
      _ => throw Exception("Unknown accompagnement: $accompagnement"),
    };
  }
}
