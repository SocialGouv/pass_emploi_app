import 'package:pass_emploi_app/models/brand.dart';

class BenevolatAssets {
  BenevolatAssets._();

  static String title = "Je m’engage bénévolement ";
  static String cta = "Trouver une mission";
  static String link = "JeVeuxAider.gouv.fr";
  static String card1Title = Brand.isCej() ? "Bénévolat et Contrat Engagement Jeune" : "Bénévolat et pass emploi";
  static String card1Part1 = "Rendez-vous sur ↗";
  static String card1Part2 = Brand.isCej()
      ? " pour trouver LA mission qui fera chavirer votre cœur\u{00A0}! Les heures de bénévolat pourront être comptabilisées dans vos heures d’activité CEJ."
      : " pour trouver LA mission qui fera chavirer votre cœur\u{00A0}!";
  static String card2Title = "Qui peut faire du bénévolat\u{00A0}?";
  static String card2Part1 =
      "Les timides, les personnes à mobilité réduite, les pressés, les pessimistes, les optimistes, les infatigables… Le bénévolat est accessible à qui le souhaite. Sur ↗";
  static String card2Part2 =
      ", les missions de bénévolat sont ouvertes à toute personne âgée de plus de 16 ans et résidant en France, sans condition de nationalité.";
  static String card3Title = "Le bénévolat et plus si affinités";
  static String card3Part1 = "Contribuez à une cause qui vous touche au cœur\u{00A0}:\n"
      " · Maraude\n"
      " · Soins aux animaux\n"
      " · Ramassages de déchêts\n"
      " · Secourisme\n"
      " · Collecte de dons\n"
      "Et beaucoup d’autres\n";
  static String card3Part2 = "↗ Trouver une mission de bénévolat";
  static String verbatimPart1 =
      "“Je voulais être sûre que le social était un secteur pour moi. Cette expérience m’a permis de reprendre confiance dans mon projet.“";
  static String verbatimPart2 = Brand.isCej() ? "Élodie, jeune en CEJ et bénévole sur ↗" : "Élodie, bénévole sur ↗";

  static String imageCard1Path = "assets/benevolat/benevolat_page_card_1.webp";
  static String imageVerbatimPath = "assets/benevolat/benevolat_page_card_2.webp";
  static String imageCard3Path = "assets/benevolat/benevolat_page_card_3.webp";
  static String imageCard4Path = "assets/benevolat/benevolat_page_card_4.webp";
}
