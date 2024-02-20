import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';

class TopDemarcheRepository {
  List<DemarcheDuReferentiel> getTopDemarches() {
    return [
      DemarcheDuReferentiel(
        id: 'top1',
        quoi: 'Candidatures spontanées',
        pourquoi: 'Mes candidatures',
        codeQuoi: 'Q15',
        codePourquoi: 'P03',
        comments: [
          Comment(label: 'En utilisant mon réseau personnel', code: 'C15.01'),
          Comment(label: 'En contactant un employeur', code: 'C15.02'),
          Comment(label: 'En déposant une annonce pour trouver un employeur', code: 'C15.03'),
          Comment(label: 'Par un autre moyen', code: 'C15.04'),
          Comment(label: 'Sur internet', code: 'C15.05'),
        ],
        isCommentMandatory: true,
      ),
      DemarcheDuReferentiel(
        id: 'top2',
        quoi: 'Préparation des entretiens d\'embauche',
        pourquoi: 'Mes entretiens d\'embauche',
        codeQuoi: 'Q17',
        codePourquoi: 'P04',
        comments: [
          Comment(label: 'Sur internet', code: 'C17.03'),
          Comment(label: 'Par un autre moyen', code: 'C17.04'),
        ],
        isCommentMandatory: true,
      ),
      DemarcheDuReferentiel(
        id: 'top3',
        quoi: 'Réalisation d\'entretiens d\'embauche',
        pourquoi: 'Mes entretiens d\'embauche',
        codeQuoi: 'Q18',
        codePourquoi: 'P04',
        comments: [
          Comment(label: 'Sur internet', code: 'C18.01'),
          Comment(label: 'En participant à un Job dating hors France Travail', code: 'C18.02'),
          Comment(label: 'Par un autre moyen', code: 'C18.03'),
        ],
        isCommentMandatory: true,
      ),
      DemarcheDuReferentiel(
        id: 'top4',
        quoi: 'Participation à un salon ou un forum pour rechercher des offres',
        pourquoi: 'Mes candidatures',
        codeQuoi: 'Q13',
        codePourquoi: 'P03',
        comments: [
          Comment(label: 'Sur internet', code: 'C13.01'),
          Comment(label: 'En présentiel', code: 'C13.02'),
        ],
        isCommentMandatory: true,
      ),
      DemarcheDuReferentiel(
        id: 'top5',
        quoi: 'Recherche d\'offres d\'emploi ou d\'entreprises',
        pourquoi: 'Mes candidatures',
        codeQuoi: 'Q12',
        codePourquoi: 'P03',
        comments: [
          Comment(label: 'Sur internet', code: 'C12.02'),
          Comment(label: 'Avec une agence d\'intérim', code: 'C12.03'),
          Comment(label: 'Avec un cabinet de recrutement', code: 'C12.04'),
          Comment(label: 'Par un autre moyen', code: 'C12.06'),
        ],
        isCommentMandatory: true,
      ),
      DemarcheDuReferentiel(
        id: 'top6',
        quoi: 'Montage d\'un dossier d’inscription à une formation',
        pourquoi: 'Ma formation professionnelle',
        codeQuoi: 'Q07',
        codePourquoi: 'P02',
        comments: [],
        isCommentMandatory: false,
      ),
      DemarcheDuReferentiel(
        id: 'top7',
        quoi: 'Information sur un métier ou un secteur d\'activité',
        pourquoi: 'Mon (nouveau) métier',
        codeQuoi: 'Q02',
        codePourquoi: 'P01',
        comments: [
          Comment(label: 'Sur internet', code: 'C02.03'),
          Comment(label: 'Par un autre moyen', code: 'C02.04'),
        ],
        isCommentMandatory: true,
      ),
      DemarcheDuReferentiel(
        id: 'top8',
        quoi: 'Préparation de ses candidatures (CV, lettre de motivation, book)',
        pourquoi: 'Mes candidatures',
        codeQuoi: 'Q11',
        codePourquoi: 'P03',
        comments: [
          Comment(label: 'En créant ou en mettant à jour mon CV et ou ma lettre de motivation', code: 'C11.02'),
          Comment(label: 'En publiant mon profil/mon CV sur internet', code: 'C11.03'),
          Comment(label: 'Par un autre moyen', code: 'C11.05'),
          Comment(label: 'Sur internet', code: 'C11.06'),
        ],
        isCommentMandatory: true,
      ),
      DemarcheDuReferentiel(
        id: 'top9',
        quoi: 'Identification de ses points forts et de ses compétences',
        pourquoi: 'Mon (nouveau) métier',
        codeQuoi: 'Q01',
        codePourquoi: 'P01',
        comments: [
          Comment(label: 'Avec un bilan de compétences', code: 'C01.03'),
          Comment(label: 'Sur internet', code: 'C01.04'),
          Comment(label: 'Par un autre moyen', code: 'C01.05'),
        ],
        isCommentMandatory: true,
      ),
      DemarcheDuReferentiel(
        id: 'top10',
        quoi: 'Relance des recruteurs suite à ses entretiens',
        pourquoi: 'Mes entretiens d\'embauche',
        codeQuoi: 'Q20',
        codePourquoi: 'P04',
        comments: [
          Comment(label: 'Sur internet', code: 'C20.01'),
          Comment(label: 'Par un autre moyen', code: 'C20.02'),
        ],
        isCommentMandatory: true,
      ),
    ];
  }
}
