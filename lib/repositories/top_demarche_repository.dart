import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';

class TopDemarcheRepository {
  List<DemarcheDuReferentiel> getTopDemarches() {
    return [
      DemarcheDuReferentiel(
        quoi: 'quoi',
        pourquoi: 'pourquoi',
        codeQuoi: 'codeQuoi',
        codePourquoi: 'codePourquoi',
        comments: [
          Comment(label: 'label1', code: 'code1'),
          Comment(label: 'label2', code: 'code2'),
        ],
        isCommentMandatory: true,
      ),
      DemarcheDuReferentiel(
        quoi: 'quoi',
        pourquoi: 'pourquoi',
        codeQuoi: 'codeQuoi',
        codePourquoi: 'codePourquoi',
        comments: [
          Comment(label: 'label1', code: 'code1'),
          Comment(label: 'label2', code: 'code2'),
        ],
        isCommentMandatory: true,
      ),
      DemarcheDuReferentiel(
        quoi: 'quoi',
        pourquoi: 'pourquoi',
        codeQuoi: 'codeQuoi',
        codePourquoi: 'codePourquoi',
        comments: [
          Comment(label: 'label1', code: 'code1'),
          Comment(label: 'label2', code: 'code2'),
        ],
        isCommentMandatory: true,
      )
    ];
  }
}
