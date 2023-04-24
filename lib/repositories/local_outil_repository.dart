import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/outil.dart';

class LocalOutilRepository {
  List<Outil> getOutils(Brand brand) {
    switch (brand) {
      case Brand.cej:
        return _getOutilsCej();
      case Brand.brsa:
        return _getOutilsBrsa();
    }
  }

  List<Outil> _getOutilsCej() {
    return [
      Outils.diagoriente,
      Outils.aides,
      Outils.mentor,
      Outils.benevolat,
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
      Outils.aides,
      Outils.benevolat,
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
        "Diagoriente est une application numérique qui propose aux jeunes d'explorer leurs expériences, d'analyser leurs compétences transversales et d'identifier leurs intérêts personnels pour faciliter leur orientation.",
    actionLabel: "Créer mon compte Diagoriente",
    urlRedirect: "https://app.diagoriente.beta.gouv.fr/register",
    imagePath: "diagoriente.png",
  );
  static Outil aides = Outil(
    title: "J'accède à mes aides",
    description:
        "Trouvez en quelques clics les aides auxquelles vous avez droit : logement, santé, mobilité, emploi, culture, etc.",
    actionLabel: "Lancer ma simulation",
    urlRedirect: "https://mes-aides.1jeune1solution.beta.gouv.fr/simulation/individu/demandeur/date_naissance",
    imagePath: "aides.png",
  );

  static Outil mentor = Outil(
    title: "Trouver un mentor avec 1 jeune, 1 mentor",
    description:
        "Expliquez nous votre situation et vos besoins. Nous vous mettrons en relation avec une association qui vous proposera un mentor.",
    actionLabel: "Me faire accompagner",
    urlRedirect: "https://www.1jeune1mentor.fr/formulaire?1jeune1solution",
    imagePath: "mentor.png",
  );

  static Outil benevolat = Outil(
    title: "Je m’engage bénévolement",
    description: "Trouvez une mission de bénévolat près de chez vous ou à distance grâce à JeVeuxAider.gouv.fr",
    actionLabel: "Je recherche une mission",
    urlRedirect: "http://api.api-engagement.beta.gouv.fr/r/campaign/62bd908f38442607276c515e",
    imagePath: "boite_outil_benevolat.png",
  );

  static Outil formation = Outil(
    title: "Trouver une formation",
    description: "Trouvez la formation qui vous intéresse pour réaliser votre projet professionnel.",
    actionLabel: "Je recherche une formation",
    urlRedirect: "https://www.1jeune1solution.gouv.fr/formations",
    imagePath: null,
  );

  static Outil evenement = Outil(
    title: "Événements de recrutement",
    description: "Trouvez des centaines d’événements de recrutement pour tous les jeunes partout en France.",
    actionLabel: "Je recherche un événement",
    urlRedirect: "https://www.1jeune1solution.gouv.fr/evenements",
    imagePath: null,
  );

  static Outil emploiStore = Outil(
    title: "Emploi-Store",
    description:
        "Une plateforme pour trouver les sites et applications dédiés à la recherche d'emploi ainsi qu’à la formation et à la création d'entreprise en France et à l'international.",
    actionLabel: "Me diriger vers l’Emploi-Store",
    urlRedirect: "https://www.emploi-store.fr/portail/accueil",
    imagePath: null,
  );

  static Outil emploiSolidaire = Outil(
    title: "Je postule pour un job dans une entreprise solidaire",
    description: "Prenez contact avec un employeur solidaire et postulez aux offres qui correspondent à vos attentes.",
    actionLabel: "Trouver une entreprise solidaire",
    urlRedirect: "https://emplois.inclusion.beta.gouv.fr/",
    imagePath: null,
  );

  static Outil laBonneBoite = Outil(
    title: "La bonne boîte",
    description:
        "Envoyez votre CV à la bonne entreprise ! Découvrez en un clic les entreprises qui recrutent dans votre métier près de chez vous.",
    actionLabel: "Trouver la bonne boîte",
    urlRedirect: "https://labonneboite.pole-emploi.fr/",
    imagePath: null,
  );

  static Outil alternance = Outil(
    title: "Alternance avec 1 jeune, 1 solution",
    description: "Trouvez la formation et l’entreprise pour réaliser votre projet d’alternance.",
    actionLabel: "Je recherche une altenance",
    urlRedirect: "https://www.1jeune1solution.gouv.fr/apprentissage",
    imagePath: null,
  );
}
