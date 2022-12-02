#!/bin/bash

feature_snake_case="un_kebab"
feature_camel_case="UnKebab"
feature_first_char_lower_case="$(tr '[:upper:]' '[:lower:]' <<< ${feature_camel_case:0:1})${feature_camel_case:1}"

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

stateImport=$(generateImport "features/$feature_snake_case/${feature_snake_case}_state.dart")
stateVariable="${feature_first_char_lower_case}State"
stateClass="${feature_camel_case}State"

reducerImport=$(generateImport "features/$feature_snake_case/${feature_snake_case}_reducer.dart")
reducerFunction="${feature_first_char_lower_case}Reducer"

middlewareImport=$(generateImport "features/$feature_snake_case/${feature_snake_case}_middleware.dart")
middlewareVariable="${feature_first_char_lower_case}Middleware"
middlewareClass="${feature_camel_case}Middleware"

notInitState="${feature_camel_case}NotInitializedState"


editing_file="lib/redux/app_reducer.dart"
echo "Editing $editing_file"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-REDUCER-IMPORT" "$reducerImport"

value="${stateVariable}: ${reducerFunction}(current.${stateVariable}, action),"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-APP-REDUCER-STATE" "$value"

dart format "$editing_file" -l 120



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

dart format "$editing_file" -l 120



editing_file="lib/redux/store_factory.dart"
echo "Editing $editing_file"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-STOREFACTORY-IMPORT-MIDDLEWARE" "$middlewareImport"

value="${middlewareClass}(),"
addLineAboveTag "$editing_file" "AUTOGENERATE-REDUX-STOREFACTORY-ADD-MIDDLEWARE" "$value"

dart format "$editing_file" -l 120


# TODO :
# générer le fichier repository
# générer l'utilisation du repo dans le middleware
# générer l'utilisation du repo dans le store_factory
# générer l'utilisation du repo dans les dummies et bordel des tests
# générer des tests unitaires pour le repo
# générer des tests unitaires idiots sur la boucle redux (loading + succes, et loading + fail)
# mettre ce machin dans scaffold_redux
