enum Sender {
  jeune,
  conseiller;

  bool get isJeune => this == Sender.jeune;
  bool get isConseiller => this == Sender.conseiller;
}
