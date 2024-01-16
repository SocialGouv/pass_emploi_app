#! /bin/bash
### USAGE
# > sh scripts/scaffold_redux.sh MaNouvelleFeature



# Script stops if any command fails
set -e
set -o pipefail



### Helpers

addLineAboveTag () {
  filename=$1
  tag=$2
  value=$3
  line="$(grep -n "$tag" $filename | head -n 1 | cut -d: -f1)"
  sedLine="${line}i"

  sed "$sedLine\\
$value
" $filename > tempfile

  cat tempfile > $filename
  rm tempfile
}

generateImport () {
  echo "import 'package:pass_emploi_app/$1';"
}



### Variables

dart_max_char_in_line=120

feature_camel_case=$1
feature_snake_case=$(echo $feature_camel_case \
     | sed 's/\(.\)\([A-Z]\)/\1_\2/g' \
     | tr '[:upper:]' '[:lower:]')
feature_first_char_lower_case="$(tr '[:upper:]' '[:lower:]' <<< ${feature_camel_case:0:1})${feature_camel_case:1}"

repositoryClass="${feature_camel_case}Repository"
repositoryDummyClass="Dummy${repositoryClass}"
repositoryMockClass="Mock${repositoryClass}"
repositoryVariable="${feature_first_char_lower_case}Repository"
repositoryImport=$(generateImport "repositories/${feature_snake_case}_repository.dart")

actionImport=$(generateImport "features/$feature_snake_case/${feature_snake_case}_actions.dart")

stateImport=$(generateImport "features/$feature_snake_case/${feature_snake_case}_state.dart")
stateVariable="${feature_first_char_lower_case}State"
stateClass="${feature_camel_case}State"

reducerImport=$(generateImport "features/$feature_snake_case/${feature_snake_case}_reducer.dart")
reducerFunction="${feature_first_char_lower_case}Reducer"

middlewareImport=$(generateImport "features/$feature_snake_case/${feature_snake_case}_middleware.dart")
middlewareClass="${feature_camel_case}Middleware"

notInitState="${feature_camel_case}NotInitializedState"



### Main

echo "Creating folder for feature_snake_case: $feature_snake_case"

mkdir -p "lib/features/$feature_snake_case"
mkdir -p "test/feature/$feature_snake_case"



echo "Creating repository…"
cat > "lib/repositories/${feature_snake_case}_repository.dart" <<- EOM
import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class ${repositoryClass} {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ${repositoryClass}(this._httpClient, [this._crashlytics]);

  Future<bool?> get() async {
    final url = "/jeunes/todo";
    try {
      final response = await _httpClient.get(url);
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
EOM



echo "Creating actions…"
cat > "lib/features/$feature_snake_case/${feature_snake_case}_actions.dart" <<- EOM
class ${feature_camel_case}RequestAction {}

class ${feature_camel_case}LoadingAction {}

class ${feature_camel_case}SuccessAction {
  final bool result;

  ${feature_camel_case}SuccessAction(this.result);
}

class ${feature_camel_case}FailureAction {}

class ${feature_camel_case}ResetAction {}
EOM



echo "Creating state…"
cat > "lib/features/$feature_snake_case/${feature_snake_case}_state.dart" <<- EOM
import 'package:equatable/equatable.dart';

sealed class ${feature_camel_case}State extends Equatable {
  @override
  List<Object?> get props => [];
}

class ${feature_camel_case}NotInitializedState extends ${feature_camel_case}State {}

class ${feature_camel_case}LoadingState extends ${feature_camel_case}State {}

class ${feature_camel_case}FailureState extends ${feature_camel_case}State {}

class ${feature_camel_case}SuccessState extends ${feature_camel_case}State {
  final bool result;

  ${feature_camel_case}SuccessState(this.result);

  @override
  List<Object?> get props => [result];
}
EOM



echo "Creating reducer…"
cat > "lib/features/$feature_snake_case/${feature_snake_case}_reducer.dart" <<- EOM
${actionImport}
import 'package:pass_emploi_app/features/$feature_snake_case/${feature_snake_case}_state.dart';

${feature_camel_case}State ${feature_first_char_lower_case}Reducer(${feature_camel_case}State current, dynamic action) {
  if (action is ${feature_camel_case}LoadingAction) return ${feature_camel_case}LoadingState();
  if (action is ${feature_camel_case}FailureAction) return ${feature_camel_case}FailureState();
  if (action is ${feature_camel_case}SuccessAction) return ${feature_camel_case}SuccessState(action.result);
  if (action is ${feature_camel_case}ResetAction) return ${feature_camel_case}NotInitializedState();
  return current;
}
EOM



echo "Creating middleware…"
cat > "lib/features/$feature_snake_case/${feature_snake_case}_middleware.dart" <<- EOM
${actionImport}
import 'package:pass_emploi_app/redux/app_state.dart';
${repositoryImport}
import 'package:redux/redux.dart';

class ${middlewareClass} extends MiddlewareClass<AppState> {
  final ${repositoryClass} _repository;

  ${middlewareClass}(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is ${feature_camel_case}RequestAction) {
      store.dispatch(${feature_camel_case}LoadingAction());
      final result = await _repository.get();
      if (result != null) {
        store.dispatch(${feature_camel_case}SuccessAction(result));
      } else {
        store.dispatch(${feature_camel_case}FailureAction());
      }
    }
  }
}
EOM


editing_file="lib/redux/app_reducer.dart"
echo "Editing $editing_file"

addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-REDUCER-IMPORT" "$reducerImport"

value="${stateVariable}: ${reducerFunction}(current.${stateVariable}, action),"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-REDUCER-STATE" "$value"

dart format "$editing_file" -l $dart_max_char_in_line



editing_file="lib/redux/app_state.dart"
echo "Editing $editing_file"

addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-STATE-IMPORT" "$stateImport"

value="final ${stateClass} ${stateVariable};"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-STATE-PROPERTY" "$value"

value="required this.${stateVariable},"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-STATE-CONSTRUCTOR" "$value"

value="final ${stateClass}? ${stateVariable},"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-STATE-COPYPARAM" "$value"

value="${stateVariable}: ${stateVariable} ?? this.${stateVariable},"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-STATE-COPYBODY" "$value"

value="${stateVariable}: ${notInitState}(),"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-STATE-FACTORY" "$value"

value="${stateVariable},"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-STATE-EQUATABLE" "$value"

dart format "$editing_file" -l $dart_max_char_in_line



editing_file="lib/redux/store_factory.dart"
echo "Editing $editing_file"

addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-STOREFACTORY-IMPORT-MIDDLEWARE" "$middlewareImport"

addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-STOREFACTORY-IMPORT-REPOSITORY" "$repositoryImport"

value="final ${repositoryClass} ${repositoryVariable};"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-STOREFACTORY-PROPERTY-REPOSITORY" "$value"

value="this.${repositoryVariable},"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-STOREFACTORY-CONSTRUCTOR-REPOSITORY" "$value"

value="${middlewareClass}(${repositoryVariable}).call,"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-STOREFACTORY-ADD-MIDDLEWARE" "$value"

dart format "$editing_file" -l $dart_max_char_in_line



editing_file="lib/app_initializer.dart"
echo "Editing $editing_file"

addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-INITIALIZER-REPOSITORY-IMPORT" "$repositoryImport"

value="${repositoryClass}(dioClient, crashlytics),"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-INITIALIZER-REPOSITORY-CONSTRUCTOR" "$value"

dart format "$editing_file" -l $dart_max_char_in_line



editing_file="test/utils/test_setup.dart"
echo "Editing $editing_file"

addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-TEST-SETUP-REPOSITORY-IMPORT" "$repositoryImport"

value="${repositoryClass} ${repositoryVariable} = ${repositoryDummyClass}();"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-TEST-SETUP-REPOSITORY-PROPERTY" "$value"

value="${repositoryVariable},"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-TEST-SETUP-REPOSITORY-CONSTRUCTOR" "$value"

dart format "$editing_file" -l $dart_max_char_in_line



editing_file="test/doubles/dummies.dart"
echo "Editing $editing_file"

addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-TEST-DUMMIES-REPOSITORY-IMPORT" "$repositoryImport"

value="class ${repositoryDummyClass} extends ${repositoryClass} { ${repositoryDummyClass}() : super(DioMock()); }"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-TEST-DUMMIES-REPOSITORY-DECLARATION" "$value"

dart format "$editing_file" -l $dart_max_char_in_line



editing_file="test/doubles/mocks.dart"
echo "Editing $editing_file"

addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-TEST-MOCKS-REPOSITORY-IMPORT" "$repositoryImport"

value="class ${repositoryMockClass} extends Mock implements ${repositoryClass} {}"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-TEST-MOCKS-REPOSITORY-DECLARATION" "$value"

dart format "$editing_file" -l $dart_max_char_in_line



echo "Creating repository test…"
cat > "test/repositories/${feature_snake_case}_repository_test.dart" <<- EOM
import 'package:flutter_test/flutter_test.dart';
${repositoryImport}

import '../dsl/sut_dio_repository.dart';

void main() {
  group('${repositoryClass}', () {
    final sut = DioRepositorySut<${repositoryClass}>();
    sut.givenRepository((client) => ${repositoryClass}(client));

    group('get', () {
      sut.when((repository) => repository.get());

      group('when response is valid', () {
        sut.givenResponseCode(200);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/todo",
          );
        });

        test('response should be valid', () async {
          await sut.expectTrueAsResult();
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be null', () async {
          await sut.expectNullResult();
        });
      });
    });
  });
}
EOM



echo "Creating redux test…"
cat > "test/feature/${feature_snake_case}/${feature_snake_case}_test.dart" <<- EOM
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
${actionImport}
${stateImport}

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('${feature_camel_case}', () {
    final sut = StoreSut();
    final repository = ${repositoryMockClass}();

    group("when requesting", () {
      sut.whenDispatchingAction(() => ${feature_camel_case}RequestAction());

      test('should load then succeed when request succeed', () {
        when(() => repository.get()).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.${repositoryVariable} = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        when(() => repository.get()).thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.${repositoryVariable} = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<${feature_camel_case}LoadingState>((state) => state.${stateVariable});

Matcher _shouldFail() => StateIs<${feature_camel_case}FailureState>((state) => state.${stateVariable});

Matcher _shouldSucceed() {
  return StateIs<${feature_camel_case}SuccessState>(
    (state) => state.${stateVariable},
    (state) {
      expect(state.result, true);
    },
  );
}
EOM
