L'application iOS et Android Pass Emploi

## Pratiques de dev et conventions

Celles-ci sont spécifiées dans le fichier [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Renseigner les variables d'environnement

Créer un fichier dans le répertoire `env` intitulé `env.staging` en vous inspirant du
fichier `env.template` situé à la racine du projet. Y insérer toutes les bonnes valeurs.

## Lancer l'application depuis Android Studio

Il est nécessaire pour cela de créer 2 configurations, en fonction que vous soyez sur le flavor
`staging` ou le flavor `prod`.

### Pour le flavor staging

1. Dans `Run` > `Edit Configurations`, rajouter une configuration Flutter appelée `staging`
2. `Dart entrypoint` > `lib/main.dart`
3. `Additional run arguments` > `--flavor staging`

### Pour le flavor prod

1. Dans `Run` > `Edit Configurations`, rajouter une configuration Flutter appelée `prod`
2. `Dart entrypoint` > `lib/main.dart`
3. `Additional run arguments` > `--flavor prod`

## Renseigner les secrets Firebase

Le projet utilise plusieurs foncionnalité de firebase. Les secrets ne sont pas et ne doivent pas
être commités (à ce titre, ils sont présent dans le `.gitignore`. Pour autant, ils sont nécessaires
au bon fonctionnement de l'application. Ils sont téléchargeables directement depuis Firebase.

Pour rappel ces fichiers ne doivent pas être versionnés (le gitignore est déjà configuré pour).

# Pour l'environnement de staging

1. Télécharger les fichiers `google-services.json`
   et `GoogleService-Info.plist` [ici](https://console.firebase.google.com/project/pass-emploi-staging/settings/general)
   .
2. Les déplacer respectivement dans les dossiers suivants (à créer) :

* Android : `/android/app/src/staging/google-services.json`
* iOS : `/ios/firebase-config/staging/GoogleService-Info.plist`

# Pour l'environnement de prod

1. Télécharger les fichiers `google-services.json`
   et `GoogleService-Info.plist` [ici](https://console.firebase.google.com/u/1/project/pass-emploi/settings/general)
   .
2. Les déplacer respectivement dans les dossiers suivants (à créer) :

* Android : `/android/app/src/prod/google-services.json`
* iOS : `/ios/firebase-config/prod/GoogleService-Info.plist`

## Spécificité Firestore iOS

La dépendance basique de Firestore sur iOS augmente considérablement le temps de build de l'app iOS.
Aussi pour éviter un tel écueil, on utilise un version précompilé proposée par la communauté. Si
besoin de la mettre à jour, il faut le faire dans le fichier `ios/Podfile` :
`pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => 'X.X.X'`

## Mettre à jour le framework et les dépendances

# Flutter / Dart

Une fois la montée de version de Flutter effectuée, mettre à jour :

* le fichier `pubspec.yaml` :
  ** La variable `flutter` pour le Framework
  ** la variable `sdk` pour la version de Dart correspondante
* dans tous les fichiers liées au Github Actions dans le repertoire '.github/workflows'

# Dépendances

* Lancer la commande `$flutter pub outdated`.
* A la main, mettre à jour les versions remontées dans les sorties `direct dependencies`
  et `dev_dependencies`.
* Vérifier que le projet compile bien en lançant la commande `$flutter pub get`.

## Déployer une app sur Firebase

### Spécificités Android

1. Vérifier que le fichier `passemploi.jks` (fichier privé) est bien situé dans le
   repertoire `android/keystore`
2. Créer un fichier `key.properties` dans le repertoire `android` à partir du même modèle que
   `key.properties.template`. Ce fichier ne doit JAMAIS être versionné.
3. Renseigner les valeurs demandées (valeurs présentes dans le Drive du projet) dans ce fichier.

### Spécificités iOS

1. Vérifier que votre compte Apple Dev ait bien accès au compte Apple "Fabrique numérique des
   ministères sociaux"
2. Ouvrir le projet dans Xcode
3. Configurer XCode, notamment sur la
   partie `Signing & Capabilities` [https://flutter.dev/docs/deployment/ios] 
   en renseignant le bon provisioning profile de l'app `fr.fabrique.socialgouv.passemploi.staging`
4. Récupérer le fichier `StagingOptionsPlist.plist` dans le Drive du projet, et le placer dans le
   dossier `ios`.
5. Récupérer le fichier `DistCert_47M2TN7F3J.p12` dans le Drive du projet, et le placer dans le
   dossier `ios` en le nommant `cert.p12`.
6. Récupérer le fichier `frfabriquesocialgouvpassemploistaging.mobileprovision` dans le Drive du
   projet, et le placer dans le dossier `ci`.

### Avec les github actions

A chaque push sur la branche develop, un build et un déploiement est fait sur firebase. Lorsque des
variables d'environnement sont modifiées/ajoutées, il faut les ajouter dans les secrets github. Le
fichier `ci/.env.template` permet de lister les variables nécessaires.

#### Mettre à jour ou insérer de nouvelle variable d'environnement dans Github Action

1. Assurer vous d'avoir mis la nouvelle variable d'environnement dans le fichier
   local `env/.env.staging`.
2. Lancer le script `bash scripts/generate_env_ci.sh`
3. Récupérer la valeur de STAGING_RUNTIME_ENV_B64 dans le fichier  `ci/env.ci`.
4. Mettre à jour le secret de Github action 'STAGING_RUNTIME_ENV_B64' (Github > Settings > Secrets).

#### Mettre à jour le provisioning profile dans Github Action

1. Récupérer la dernière version du fichier `frfabriquesocialgouvpassemploistaging.mobileprovision`
   sur App Store Connect et le placer dans le répertoire `ci`.
2. Lancer le script `bash scripts/generate_env_ci.sh`
3. Récupérer la valeur de STAGING_IOS_PROVISIONING_PROFILE_B64 dans le fichier  `ci/env.ci`.
4. Mettre à jour le secret de Github action 'STAGING_IOS_PROVISIONING_PROFILE_B64' (Github >
   Settings > Secrets).

### En local

#### Lancement du script

Le script lance les tests, build les ipa et apk, et les distribue sur firebase app distribution.

NB: le déploiement nécessite [la cli firebase](https://firebase.google.com/docs/cli). Il ne devrait
pas être nécessaire d'être connecté, le script utilisant un token "ci".

1. S'assurer que le script `scripts/staging_release_when_github_is_down.sh` est bien
   executable : `chmod u+x scripts/staging_release_when_github_is_down.sh`
2. En se plaçant à la racine du projet, lancer le
   script `scripts/staging_release_when_github_is_down.sh`.

## Déployer une nouvelle version de l'app en bêta test sur les stores publics

1. Se mettre à jour sur `develop`
2. Mettre à jour le version name dans le fichier `pubspec.yaml` (variable `version`)
3. Commiter et push le changement
4. Merger `develop` sur `master` :

```shell script
$ git checkout master
$ git pull
$ git merge --no-ff develop
$ git push
```

6. Tagger la release pour générer et uploader les builds de production via la CI

```shell script
$ git tag -a <major.minor.patch> -m "major.minor.patch" # major.minor.patch étant le version name de l'étape 3
$ git push --tags 
```

7. À la fin du job, le build de l'appli se retrouve disponible :
    * Instantanément en test interne sur le Play Store Android. Il faut cependant attendre un moment
      avant que les utilisateurs internes puissent le voir dans le Play Store.
    * Sur Test Flight, même s'il faut environ 10 minutes pour qu'il soit automatiquement poussé au
      groupe de testeurs internes "Équipe projet".

## Déployer un hotfix de l'app en bêta test sur les stores publics

1. *Prérequis: avoir corrigé le bug rencontré sur la branche `develop`*
2. Créer une branche de hotfix à partir du dernier tag en production, et appliquer le(s) correctif(
   s) :

```shell script
$ git checkout <major.minor.patch> # major.minor.patch étant le tag sur lequel on veut appliquer un hotfix
$ git checkout -b hotfix/<major.minor.patch+1> # ex: passer de 3.0.0 à 3.0.1
$ git cherry-pick <hash-du-commit-correctif-sur-develop>
```

3. Mettre à jour le version name dans le fichier `pubspec.yaml` (variable `version`)
4. Commiter le changement
5. Merger la branche de hotfix sur `develop` :

```shell script
$ git checkout develop
$ git pull
$ git merge --no-ff <branche-de-hotfix>
$ git push
```

6. Merger la branche de hotfix sur `master` :

```shell script
$ git checkout master
$ git pull
$ git merge --no-ff <branche-de-hotfix>
$ git push
```

7. Supprimer la branche de hotfix en local :

```shell script
$ git branch -D <branche-de-hotfix>
```

8. Tagger la release pour générer et uploader les builds de production via la CI

```shell script
$ git tag -a major.minor.patch -m "major.minor.patch" # major.minor.patch étant le version name de l'étape 3
$ git push --tags 
```

9. À la fin du job, le build de l'appli se retrouve disponible :
    * Instantanément en test interne sur le Play Store Android. Il faut cependant attendre un moment
      avant que les utilisateurs internes puissent le voir dans le Play Store.
    * Sur Test Flight, même s'il faut environ 10 minutes pour qu'il soit automatiquement poussé au
      groupe de testeurs internes "Équipe projet".

## Promouvoir la version pour tous les utilisateurs

### Pour Android

1. Aller sur la console Google Play de l'application.
2. Dans le pannel de gauche, aller sur `Tests internes`, puis `Promouvoir la release`.
3. La validation peut prendre *jusqu'à 48h*.

### Pour iOS

1. Aller sur [App Store Connect](https://appstoreconnect.apple.com/apps).
2. Créer une version sur l'onglet App Store à partir du build idoine.
3. La vérification peut prendre *jusqu'à 72h*.