import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/campagne_question_answer.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';

import '../dsl/sut_dio_repository.dart';

void main() {
  final sut = DioRepositorySut<CampagneRepository>();
  sut.givenRepository((client) => CampagneRepository(client));

  group("postAnswers", () {
    sut.when(
      (repository) => repository.postAnswers(
        "userId",
        "campagneId",
        [CampagneQuestionAnswer(1, 2, 'pourquoi-question-1')],
      ),
    );

    group('when response is valid', () {
      sut.givenResponseCode(201);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.post,
          url: "/jeunes/userId/campagnes/campagneId/evaluer",
          jsonBody: [
            {'idQuestion': 1, 'idReponse': 2, 'pourquoi': 'pourquoi-question-1'}
          ],
        );
      });
    });
  });
}
