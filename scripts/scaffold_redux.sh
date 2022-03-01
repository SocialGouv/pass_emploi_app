#! /bin/bash

# Script stops if any command fails
set -e
set -o pipefail

feature_snake_case=$1
feature_camel_case=$2
feature_first_char_lower_case="$(tr '[:upper:]' '[:lower:]' <<< ${feature_camel_case:0:1})${feature_camel_case:1}"

echo "Creating scaffold for feature_snake_case: $feature_snake_case"
mkdir -p "lib/features/$feature_snake_case"

echo "Creating actions…"
cat > "lib/features/$feature_snake_case/${feature_snake_case}_actions.dart" <<- EOM
class ${feature_camel_case}RequestAction {}
class ${feature_camel_case}LoadingAction {}
class ${feature_camel_case}SuccessAction {}
class ${feature_camel_case}FailureAction {}
class ${feature_camel_case}ResetAction {}
EOM

echo "Creating state…"
cat > "lib/features/$feature_snake_case/${feature_snake_case}_state.dart" <<- EOM
abstract class ${feature_camel_case}State {}
class ${feature_camel_case}NotInitializedState extends ${feature_camel_case}State {}
class ${feature_camel_case}LoadingState extends ${feature_camel_case}State {}
class ${feature_camel_case}SuccessState extends ${feature_camel_case}State {}
class ${feature_camel_case}FailureState extends ${feature_camel_case}State {}
EOM

echo "Creating reducer…"
cat > "lib/features/$feature_snake_case/${feature_snake_case}_reducer.dart" <<- EOM
import 'package:pass_emploi_app/features/$feature_snake_case/${feature_snake_case}_actions.dart';
import 'package:pass_emploi_app/features/$feature_snake_case/${feature_snake_case}_state.dart';

${feature_camel_case}State ${feature_first_char_lower_case}Reducer(${feature_camel_case}State current, dynamic action) {
  if (action is ${feature_camel_case}LoadingAction) return ${feature_camel_case}LoadingState();
  if (action is ${feature_camel_case}FailureAction) return ${feature_camel_case}FailureState();
  if (action is ${feature_camel_case}SuccessAction) return ${feature_camel_case}SuccessState();
  if (action is ${feature_camel_case}ResetAction) return ${feature_camel_case}NotInitializedState();
  return current;
}
EOM

echo "Creating middleware…"
cat > "lib/features/$feature_snake_case/${feature_snake_case}_middleware.dart" <<- EOM
import 'package:pass_emploi_app/features/$feature_snake_case/${feature_snake_case}_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class ${feature_camel_case}Middleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is ${feature_camel_case}RequestAction) {
      store.dispatch(${feature_camel_case}LoadingAction());
      //TODO: call repository
      //store.dispatch(result != null ? ${feature_camel_case}SuccessAction(action.) : ${feature_camel_case}FailureAction());
    }
  }
}
EOM