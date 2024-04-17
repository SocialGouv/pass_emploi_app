import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/ui/external_links.dart';

class LocalOutilRepository {
  List<Outil> getOutils(Brand brand) {
    return switch (brand) { Brand.cej => _getOutilsCej(), Brand.brsa => _getOutilsBrsa() };
  }

  List<Outil> _getOutilsCej() {
    return [
      Outils.benevolatCej,
      Outils.diagoriente,
      Outils.aides,
      Outils.mentor,
      Outils.formation,
      Outils.evenement,
      Outils.emploiStore,
      Outils.emploiSolidaire,
      Outils.laBonneBoite,
      Outils.alternance,
    ];
  }

  List<Outil> _getOutilsBrsa() {
    return [
      Outils.benevolatBrsa,
      Outils.aides,
      Outils.emploiStore,
      Outils.emploiSolidaire,
      Outils.laBonneBoite,
    ];
  }
}

class Outils {
  static Outil diagoriente = Outil(
    title: "Diagoriente",
    description:
        "Explorez vos expériences, analysez vos compétences transversales et identifiez vos intérêts personnels afin de faciliter votre orientation.",
    actionLabel: "Créer mon compte Diagoriente",
    urlRedirect: ExternalLinks.boiteAOutilsDiagoriente,
    imagePath: "diagoriente.png",
  );
  static Outil aides = Outil(
    title: "J'accède à mes aides",
    description:
        "Trouvez en quelques clics les aides auxquelles vous avez droit : logement, santé, mobilité, emploi, culture, etc.",
    actionLabel: "Lancer ma simulation",
    urlRedirect: ExternalLinks.boiteAOutilsAides,
    imagePath: "aides.png",
  );

  static Outil mentor = Outil(
    title: "Trouver un mentor avec 1 jeune, 1 mentor",
    description:
        "Expliquez nous votre situation et vos besoins. Nous vous mettrons en relation avec une association qui vous proposera un mentor.",
    actionLabel: "Me faire accompagner",
    urlRedirect: ExternalLinks.boiteAOutilsMentor,
    imagePath: "mentor.png",
  );

  static Outil benevolatCej = Outil(
    title: "Je m’engage bénévolement",
    description:
        "Trouvez une mission de bénévolat à distance ou en présentiel, comptabilisée dans vos heures d’activités CEJ, sur JeVeuxAider.gouv.fr",
    urlRedirect: ExternalLinks.boiteAOutilsBenevolatCej,
    imagePath: "boite_outil_benevolat.webp",
  );

  static Outil benevolatBrsa = Outil(
    title: "Je m’engage bénévolement",
    description: "Trouvez une mission de bénévolat à distance ou en présentiel sur JeVeuxAider.gouv.fr",
    urlRedirect: ExternalLinks.boiteAOutilsBenevolatBrsa,
    imagePath: "boite_outil_benevolat.webp",
  );

  static Outil formation = Outil(
    title: "Trouver une formation",
    description: "Trouvez la formation qui vous intéresse pour réaliser votre projet professionnel.",
    actionLabel: "Je recherche une formation",
    urlRedirect: ExternalLinks.boiteAOutilsFormation,
    imagePath: null,
  );

  static Outil evenement = Outil(
    title: "Événements de recrutement",
    description: "Trouvez des centaines d’événements de recrutement pour tous les jeunes partout en France.",
    actionLabel: "Je recherche un événement",
    urlRedirect: ExternalLinks.boiteAOutilsEvenementRecrutement,
    imagePath: null,
  );

  static Outil emploiStore = Outil(
    title: "Emploi-Store",
    description:
        "Une plateforme pour trouver les sites et applications dédiés à la recherche d'emploi ainsi qu’à la formation et à la création d'entreprise en France et à l'international.",
    actionLabel: "Me diriger vers l’Emploi-Store",
    urlRedirect: ExternalLinks.boiteAOutilsEmploiStore,
    imagePath: null,
  );

  static Outil emploiSolidaire = Outil(
    title: "Je postule pour un job dans une entreprise solidaire",
    description: "Prenez contact avec un employeur solidaire et postulez aux offres qui correspondent à vos attentes.",
    actionLabel: "Trouver une entreprise solidaire",
    urlRedirect: ExternalLinks.boiteAOutilsEmploiSolidaire,
    imagePath: null,
  );

  static Outil laBonneBoite = Outil(
    title: "La bonne boîte",
    description:
        "Envoyez votre CV à la bonne entreprise ! Découvrez en un clic les entreprises qui recrutent dans votre métier près de chez vous.",
    actionLabel: "Trouver la bonne boîte",
    urlRedirect: ExternalLinks.boiteAOutilsLaBonneBoite,
    imagePath: null,
  );

  static Outil alternance = Outil(
    title: "Alternance avec 1 jeune, 1 solution",
    description: "Trouvez la formation et l’entreprise pour réaliser votre projet d’alternance.",
    actionLabel: "Je recherche une altenance",
    urlRedirect: ExternalLinks.boiteAOutilsAlternance,
    imagePath: null,
  );
}
