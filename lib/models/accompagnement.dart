enum Accompagnement {
  cej,
  rsa,
  aij;

  // TODO-AIJ: temporary (19/06/2024), until handled by pass-emploi-connect
  static Accompagnement accompagnement = Accompagnement.rsa;

  static void setAccompagnement(Accompagnement accompagnement) => Accompagnement.accompagnement = accompagnement;
}
