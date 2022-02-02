L'application iOS et Android Pass Emploi

## Pratiques de dev et conventions
Celles-ci sont spécifiées dans le fichier [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Renseigner les variables d'environnement
Créer un repertoire `env` à la racine du projet.
Créer deux fichiers dans ce répertoire intitulés `env.staging` et `env.prod` en vous inspirant du 
fichier `env.template` situé à la racine du projet. Y insérer toutes les bonnes valeurs.

## Lancer l'application depuis Android Studio
Il est nécessaire pour cela de créer 2 configurations, en fonction que vous soyez sur le flavor 
`staging` ou le flavor `prod`.
### Pour le flavor staging 
1. Dans `Run` > `Edit Configurations`, rajouter une configuration Flutter appelée `staging`
2. `Dart entrypoint` > `lib/main.dart`
3. `Additional arguments` > `--flavor staging`
### Pour le flavor prod
1. Dans `Run` > `Edit Configurations`, rajouter une configuration Flutter appelée `prod`
2. `Dart entrypoint` > `lib/main.dart`
3. `Additional arguments` > `--flavor prod`

## Renseigner les secrets Firebase
Le projet utilise plusieurs foncionnalité de firebase. Les secrets ne sont pas et ne doivent pas 
être commités (à ce titre, ils sont présent dans le `.gitignore`. Pour autant, ils sont nécessaires 
au bon fonctionnement de l'application. Ils sont téléchargeables directement depuis Firebase.

Pour rappel ces fichiers ne doivent pas être versionnés (le gitignore est déjà configuré pour).

#Pour l'environnement de staging 
1. Télécharger les fichiers `google-services.json` et `GoogleService-Info.plist` [ici](https://console.firebase.google.com/project/pass-emploi-staging/settings/general).
2. Les déplacer respectivement dans les dossiers suivants (à créer) :
* Android : `/android/app/src/staging/google-services.json`
* iOS : `/ios/firebase-config/staging/GoogleService-Info.plist`

#Pour l'environnement de prod
1. Télécharger les fichiers `google-services.json` et `GoogleService-Info.plist` [ici](https://console.firebase.google.com/u/1/project/pass-emploi/settings/general).
2. Les déplacer respectivement dans les dossiers suivants (à créer) :
* Android : `/android/app/src/prod/google-services.json`
* iOS : `/ios/firebase-config/prod/GoogleService-Info.plist`

## Spécificité Firestore iOS
La dépendance basique de Firestore sur iOS augmente considérablement le temps de build de l'app iOS. 
Aussi pour éviter un tel écueil, on utilise un version précompilé proposée par la communauté. 
Si besoin de la mettre à jour, il faut le faire dans le fichier `ios/Podfile` :
`pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => 'X.X.X'` 

## Déployer une app sur Firebase
### Spécificités Android
1. Vérifier que le fichier `passemploi.jks` (fichier privé) est bien situé dans le repertoire `android/keystore` 
2. Créer un fichier `key.properties` dans le repertoire `android` à partir du même modèle que 
`key.properties.template`. Ce fichier ne doit JAMAIS être versionné.
3. Renseigner les valeurs demandées (valeurs présentes dans le Drive du projet) dans ce fichier.

### Spécificités iOS
1. Vérifier que votre compte Apple Dev ait bien accès au compte Apple "Fabrique numérique des ministères sociaux"
2. Ouvrir le projet dans Xcode
3. Configurer XCode, notamment sur la partie `Signing & Capabilities` [https://flutter.dev/docs/deployment/ios] 
en renseignant le bon provisioning profile de l'app `fr.fabrique.socialgouv.passemploi.staging`
4. Récupérer le fichier `StagingOptionsPlist.plist` dans le Drive du projet, et le placer dans le dossier `ios`.
5. Récupérer le fichier `DistCert_47M2TN7F3J.p12` dans le Drive du projet, et le placer dans le dossier `ios` en le nommant `cert.p12`.
6. Récupérer le fichier `frfabriquesocialgouvpassemploistaging.mobileprovision` dans le Drive du projet, et le placer dans le dossier `ci`.

### Avec les github actions
A chaque push sur la branche develop, un build et un déploiement est fait sur firebase.
Lorsque des variables d'environnement sont modifiées/ajoutées, il faut les ajouter dans les secrets github.
Le fichier `ci/.env.template` permet de lister les variables nécessaires.
 
#### Mettre à jour ou insérer de nouvelle variable d'environnement dans Github Action
1. Assurer vous d'avoir mis la nouvelle variable d'environnement dans le fichier local `env/.env.staging`.
2. Lancer le script `bash scripts/generate_env_ci.sh`
3. Récupérer la valeur de STAGING_RUNTIME_ENV_B64 dans le fichier  `ci/env.ci`.
4. Mettre à jour le secret de Github action 'STAGING_RUNTIME_ENV_B64' (Github > Settings > Secrets).
 
#### Mettre à jour le provisioning profile dans Github Action
1. Récupérer la dernière version du fichier `frfabriquesocialgouvpassemploistaging.mobileprovision` sur App Store Connect et le placer dans le répertoire `ci`.
2. Lancer le script `bash scripts/generate_env_ci.sh`
3. Récupérer la valeur de STAGING_IOS_PROVISIONING_PROFILE_B64 dans le fichier  `ci/env.ci`.
4. Mettre à jour le secret de Github action 'STAGING_IOS_PROVISIONING_PROFILE_B64' (Github > Settings > Secrets).

### En local
#### Lancement du script
Le script lance les tests, build les ipa et apk, et les distribue sur firebase app distribution. 

NB: le déploiement nécessite [la cli firebase](https://firebase.google.com/docs/cli). Il ne devrait 
pas être nécessaire d'être connecté, le script utilisant un token "ci".

1. S'assurer que le script `scripts/staging_release_when_github_is_down.sh` est bien
   executable : `chmod u+x scripts/staging_release_when_github_is_down.sh`
2. En se plaçant à la racine du projet, lancer le script `scripts/staging_release_when_github_is_down.sh`.

## Déployer une app en bêta test sur les stores publics
### Prérequis
1. Se mettre à jour sur develop
2. Vérifier que les tests sont au vert : `$ flutter test`
3. Mettre à jour le version name dans le fichier `pubspec.yaml` (variable `version`)
4. Commiter et push le changement
5. Merger develop sur master :
```shell script
$ git checkout master
$ git pull
$ git merge --no-ff develop
$ git push
```
6. Tagger la release
```shell script
$ git tag -a major.minor.patch -m "major.minor.patch" #major.minor.patch étant le version name de l'étape 3
$ git push --tags 
```

### Pour Android
1. Vérifier que le fichier `passemploi.jks` (fichier privé) est bien situé dans le repertoire `android/keystore` 
2. Créer un fichier `key.properties` dans le repertoire `android` à partir du même modèle que `key.properties.template`. Ce fichier ne doit JAMAIS être versionné.
3. Renseigner les valeurs demandées (valeurs présentes dans le Drive du projet) dans ce fichier.
4. Construire l'APK en release : `$ flutter build appbundle --build-number=XXX --flavor prod` #XXX étant un numéro de version strictement supérieur à la version précédente
5. Récupérer l'AAB  `build/app/outputs/bundle/prodRelease/app-prod-release.aab`
6. Aller sur la console Google Play de l'application.
7. Dans le pannel de gauche, aller sur `Tests ouverts`, puis `Créer une release`
8. Uploader l'AAB. 
9. Cliquer sur `Enregister`, puis `Soumettre`, puis `Lancer le déploiement en version tests ouverts`.
10. La validation peut prendre *jusqu'à 48h*.

### Pour iOS
1. Vérifier que votre compte Apple Dev ait bien accès au compte Apple "Fabrique numérique des ministères sociaux"
2. Ouvrir le projet dans Xcode
3. Configurer XCode, notamment sur la partie `Signing & Capabilities` [https://flutter.dev/docs/deployment/ios] en renseignant le bon provisioning profile de l'app `fr.fabrique.socialgouv.passemploi.distribution`
4. Selectionner Product > Scheme > prod.
5. Selectionner Product > Destination > Any iOS Device.
6. Lancer le build iOS release : `flutter build ipa --build-number=XXX --flavor prod` #XXX étant un numéro de version strictement supérieur à la version précédente
7. Ouvrir le projet dans Xcode
8. Selectionner Product > Archive.
9. Une fois l'archive réalisée, cliquer sur Distribute App > App Store Connect> Upload
10. Garder les checkbox `Strip Swift symbols` et `Upload your app symbols…` et `Manage version` cochées, puis Next
11. Dans `Runner.app, choisir `fr.fabrique.socialgouv.passemploi.distribution`, puis Next puis Upload
12. /!\ Attention : l'étape précédente peut prendre plusieurs minutes. Mais si au bout de 10 minutes 
il ne se passe rien, c'est potentiellement dû à un mauvais réseau sur votre poste. Dans ce cas là, 
il faut annuler, et recommencer à l'étape 9. 
13. Aller sur [https://appstoreconnect.apple.com/apps](App Store Connect)
14. Dans l'onglet `Test flight` de l'app `Pass Emploi`, attendre que la version tout juste uploadée 
soit bien présente. Il ne faut pas hésiter à rafraichir la page régulièrement.
15. Par défaut, un warning apparaît `Attestation manquantes`. Indiquez que *non*, il n'y a pas 
d'algorithme de chiffrement dans l'app.
16. Dans le pannel de gauche, Test externes > Ambassadeurs, rajoutez le build tout juste uplpoadé 
(section `Build` en bas de la page).
17. La vérification peut prendre *jusqu'à 72h*.