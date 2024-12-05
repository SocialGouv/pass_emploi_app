import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/ui/external_links.dart';

class Outil extends Equatable {
  final String title;
  final String description;
  final OutilRedirectMode redirectMode;
  final String? actionLabel;
  final String? imagePath;
  final String? imageAlt;

  Outil({
    required this.title,
    required this.description,
    required this.redirectMode,
    this.actionLabel,
    this.imagePath,
    this.imageAlt,
  });

  // TODO-CJE(04/11/24): remove when feature deleted
  static Outil cje = Outil(
    title: "Ma carte “jeune engagé”",
    description:
        "Décathlon, Kiabi, Cdiscount, Cultura, retrouvez des codes de réduction à utiliser en ligne ou en magasin.",
    redirectMode: OutilInternalRedirectMode(OutilInternalLink.cje),
    imagePath: "cje/outil.webp",
  );

  static Outil diagoriente = Outil(
    title: "Diagoriente",
    description:
        "Explorez vos expériences, analysez vos compétences transversales et identifiez vos intérêts personnels afin de faciliter votre orientation.",
    actionLabel: "Créer mon compte Diagoriente",
    redirectMode: OutilExternalRedirectMode(ExternalLinks.boiteAOutilsDiagoriente),
    imagePath: "boite_a_outils/diagoriente.webp",
  );

  static Outil mesAidesFt = Outil(
    title: "Je découvre Mes aides France Travail",
    description:
        "Besoin d'une aide financière, de conseils ? Permis, voiture, vélo, logement... Consultez les aides qui existent pour vos projets. ",
    actionLabel: "En savoir plus sur Mes aides",
    redirectMode: OutilExternalRedirectMode(ExternalLinks.boiteAOutilsMesAidesFt),
    imagePath: "boite_a_outils/mes_aides_ft.webp",
  );

  static Outil mesAides1J1S = Outil(
    title: "J'accède à mes aides",
    description:
        "Trouvez en quelques clics les aides auxquelles vous avez droit : logement, santé, mobilité, emploi, culture, etc.",
    actionLabel: "Lancer ma simulation",
    redirectMode: OutilExternalRedirectMode(ExternalLinks.boiteAOutilsMesAides1J1S),
    imagePath: "boite_a_outils/mes_aides_1j1s.webp",
  );

  static Outil mentor = Outil(
    title: "Trouver un mentor avec 1 jeune, 1 mentor",
    description:
        "Expliquez nous votre situation et vos besoins. Nous vous mettrons en relation avec une association qui vous proposera un mentor.",
    actionLabel: "Me faire accompagner",
    redirectMode: OutilExternalRedirectMode(ExternalLinks.boiteAOutilsMentor),
    imagePath: "boite_a_outils/mentor.webp",
  );

  static Outil benevolatCej = Outil(
    title: "Je m’engage bénévolement",
    imageAlt: "Je veux plus de solidarité, Devez bénévole",
    description:
        "Trouvez une mission de bénévolat à distance ou en présentiel, comptabilisée dans vos heures d’activités CEJ, sur JeVeuxAider.gouv.fr",
    redirectMode: OutilInternalRedirectMode(OutilInternalLink.benevolat),
    imagePath: "boite_a_outils/benevolat.webp",
  );

  static Outil benevolatPassEmploi = Outil(
    title: "Je m’engage bénévolement",
    description: "Trouvez une mission de bénévolat à distance ou en présentiel sur JeVeuxAider.gouv.fr",
    redirectMode: OutilInternalRedirectMode(OutilInternalLink.benevolat),
    imagePath: "boite_a_outils/benevolat.webp",
  );

  static Outil laBonneAlternance = Outil(
    title: "La bonne alternance",
    description:
        "Le service qui réunit toute l’offre de formation ainsi que de nombreuses opportunités d’emploi en alternance.",
    redirectMode: OutilInternalRedirectMode(OutilInternalLink.laBonneAlternance),
    imagePath: "boite_a_outils/la_bonne_alternance.webp",
  );

  static Outil formation = Outil(
    title: "Trouver une formation",
    description: "Trouvez la formation qui vous intéresse pour réaliser votre projet professionnel.",
    actionLabel: "Je recherche une formation",
    redirectMode: OutilExternalRedirectMode(ExternalLinks.boiteAOutilsFormation),
    imagePath: null,
  );

  static Outil evenement = Outil(
    title: "Événements de recrutement",
    description: "Trouvez des centaines d’événements de recrutement pour tous les jeunes partout en France.",
    actionLabel: "Je recherche un événement",
    redirectMode: OutilExternalRedirectMode(ExternalLinks.boiteAOutilsEvenementRecrutement),
    imagePath: null,
  );

  static Outil emploiStore = Outil(
    title: "Emploi-Store",
    description:
        "Une plateforme pour trouver les sites et applications dédiés à la recherche d'emploi ainsi qu’à la formation et à la création d'entreprise en France et à l'international.",
    actionLabel: "Me diriger vers l’Emploi-Store",
    redirectMode: OutilExternalRedirectMode(ExternalLinks.boiteAOutilsEmploiStore),
    imagePath: null,
  );

  static Outil emploiSolidaire = Outil(
    title: "Je postule pour un job dans une entreprise solidaire",
    description: "Prenez contact avec un employeur solidaire et postulez aux offres qui correspondent à vos attentes.",
    actionLabel: "Trouver une entreprise solidaire",
    redirectMode: OutilExternalRedirectMode(ExternalLinks.boiteAOutilsEmploiSolidaire),
    imagePath: null,
  );

  static Outil laBonneBoite = Outil(
    title: "La bonne boîte",
    description:
        "Envoyez votre CV à la bonne entreprise ! Découvrez en un clic les entreprises qui recrutent dans votre métier près de chez vous.",
    actionLabel: "Trouver la bonne boîte",
    redirectMode: OutilExternalRedirectMode(ExternalLinks.boiteAOutilsLaBonneBoite),
    imagePath: null,
  );

  Outil withoutImage() {
    return Outil(
      title: title,
      description: description,
      actionLabel: actionLabel,
      redirectMode: redirectMode,
      imagePath: null,
    );
  }

  @override
  List<Object?> get props => [title, description, actionLabel, redirectMode, imagePath];
}

enum OutilInternalLink { benevolat, cje, laBonneAlternance }

sealed class OutilRedirectMode extends Equatable {}

class OutilExternalRedirectMode extends OutilRedirectMode {
  final String url;

  OutilExternalRedirectMode(this.url);

  @override
  List<Object?> get props => [url];
}

class OutilInternalRedirectMode extends OutilRedirectMode {
  final OutilInternalLink internalLink;

  OutilInternalRedirectMode(this.internalLink);

  @override
  List<Object?> get props => [internalLink];
}
