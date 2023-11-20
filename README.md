L'application iOS et Android Pass Emploi

## Pratiques de dev et conventions

Celles-ci sont spécifiées dans le fichier [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Renseigner les variables d'environnement

Créer un fichier dans le répertoire `env` intitulé `env.staging` en vous inspirant du
fichier `env.template` situé à la racine du projet. Y insérer toutes les bonnes valeurs. Elles se
trouvent dans les notes partagées Dashlane (`[APP MOBILE] .env.staging` ou `[APP MOBILE] .env.prod`)
.

## Lancer l'application

### Dans Visual Studio Code

Le fichier `launch.json` est déjà bien configuré pour lancer l'application en mode `staging` sur les
applications BRSA et CEJ. Pour lancer l'application en mode `prod`, il faut modifier la valeur de
`--flavor` dans le fichier `launch.json` par `prod`.

### Dans Android Studio

Voici comment lancer l'application en mode `staging` sur les applications BRSA et CEJ. Pour lancer
l'application en mode `prod`, il faut modifier la valeur de `--flavor` dans le
fichier `Additional run arguments` par `cejProd` ou `brsaProd`.

#### Pour le flavor staging de l'app CEJ

1. Dans `Run` > `Edit Configurations`, rajouter une configuration Flutter appelée `CEJ staging`
2. `Dart entrypoint` > `lib/cej_main.dart`
3. `Additional run arguments` > `--flavor cejStaging`

#### Pour le flavor staging de l'app BRSA

1. Dans `Run` > `Edit Configurations`, rajouter une configuration Flutter appelée `BRSA staging`
2. `Dart entrypoint` > `lib/brsa_main.dart`
3. `Additional run arguments` > `--flavor brsaStaging`

## Renseigner les secrets Firebase

Le projet utilise plusieurs foncionnalités de Firebase. Les secrets ne sont pas et ne doivent pas
être commités à ce titre, ils sont présent dans le `.gitignore`. Pour autant, ils sont nécessaires
au bon fonctionnement de l'application. Ils sont téléchargeables directement depuis Firebase.

Pour rappel ces fichiers ne doivent pas être versionnés (le gitignore est déjà configuré pour).

# Pour l'environnement de staging

### Configuration Android

1. Télécharger le fichier `google-services.json` depuis la console Firebase de staging. Ce fichier
   est commun à CEJ et BRSA vous pouvez le télécharger depuis le panneau de configuration Android de
   l'une des deux
   applications [par exemple sur ce lien](https://console.firebase.google.com/u/0/project/pass-emploi-staging/settings/general/android:fr.fabrique.social.gouv.passemploi.rsa.staging)

2. Le déplacer dans le dossier suivant :

- Android : `/android/app/google-services.json`

### Configuration iOS

1. Contrairement à Android, il va falloir télécharger les fichiers
   spécifiques `GoogleService-Info.plist` pour chacune des applications CEJ et BRSA depuis la
   console
   Firebase. [Ce lien pour CEJ](https://console.firebase.google.com/u/0/project/pass-emploi-staging/settings/general/ios:fr.fabrique.social.gouv.passemploi.staging)
   et [ce lien pour BRSA](https://console.firebase.google.com/u/0/project/pass-emploi-staging/settings/general/ios:fr.fabrique.social.gouv.passemploi.rsa.staging)

2. Les déplacer respectivement dans les dossiers suivants (à créer):

- `/ios/firebase-config/cejStaging/GoogleService-Info.plist`
- `/ios/firebase-config/brsaStaging/GoogleService-Info.plist`

# Pour l'environnement de prod

### Configuration Android

1. Télécharger le fichier `google-services.json` depuis la console Firebase de production. Ce
   fichier est commun à CEJ et BRSA vous pouvez le télécharger depuis le panneau de configuration
   Android de l'une des deux
   applications [par exemple sur ce lien](https://console.firebase.google.com/u/0/project/pass-emploi/settings/general/android:fr.fabrique.social.gouv.passemploi.rsa)

2. Le déplacer dans le dossier suivant :

- Android : `/android/app/google-services.json`

### Configuration iOS

1. Contrairement à Android, il va falloir télécharger les fichiers
   spécifiques `GoogleService-Info.plist` pour chacune des applications CEJ et BRSA depuis la
   console
   Firebase. [Ce lien pour CEJ](https://console.firebase.google.com/u/0/project/pass-emploi/settings/general/ios:fr.fabrique.social.gouv.passemploi)
   et [ce lien pour BRSA](https://console.firebase.google.com/u/0/project/pass-emploi/settings/general/ios:fr.fabrique.social.gouv.passemploi.rsa)

2. Les déplacer respectivement dans les dossiers suivants (à créer):

- `/ios/firebase-config/cejProd/GoogleService-Info.plist`
- `/ios/firebase-config/brsaProd/GoogleService-Info.plist`

## Spécificité Firestore iOS

La dépendance basique de Firestore sur iOS augmente considérablement le temps de build de l'app iOS.
Aussi pour éviter un tel écueil, on utilise un version précompilé proposée par la communauté. Si
besoin de la mettre à jour, il faut le faire dans le fichier `ios/Podfile` :
`pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => 'X.X.X'`

## Mettre à jour le framework et les dépendances

# Flutter / Dart

Une fois la montée de version de Flutter effectuée, mettre à jour :

- le fichier `pubspec.yaml` :
  ** La variable `flutter` pour le Framework
  ** la variable `sdk` pour la version de Dart correspondante
- dans tous les fichiers liées au Github Actions dans le repertoire '.github/workflows'

# Utiliser des icônes personnalisées

- Se demander si les icônes personnaliseés peuvent être remplaceés par un icône Material similaire
- Si il n'existe pas d'équivalent, télécharger les icônes souhaitées au format SVG
- Se rendre sur FlutterIcon.com et ouvrir le fichier présent dans docs/flutterIcons/config.json
- Ajouter les fichiers SVG souhaités
- Cliquer sur "Télécharger" et extraire les fichiers
- Remplacer le fichier TTF dans fonts/AppIconsAdditional.ttf
- Remplacer le fichier Dart dans lib/ui/app_icons_additional_icons.dart
- Remplacer le fichier json dans docs/flutterIcons/config.json
- Exécuter `flutter pub get`
- Exécuter "flutter run" pour vérifier que le projet compile et que l'application démarre comme
  prévu

# Modifier l'icône de l'app

En se basant sur https://pub.dev/packages/flutter_launcher_icons

- Remplacez les images dans `assets_generation/icon/` par les nouvelles icônes d'app souhaitées.
- Exécutez dans un terminal : `sh scripts/generate_icons.sh`

# Modifier le splash screen de l'app

En se basant sur https://pub.dev/packages/flutter_native_splash

- Remplacez les images dans `assets_generation/splash_screen/` par les nouvelles illustrations de
  splash screen souhaitées.
- Exécutez dans un terminal : `sh scripts/generate_splash_screens.sh`
- [Étapes supplémentaires pour iOS]
    - Ouvrez Finder à `ios/Base.lproj/`. Vous verrez deux fichiers : `LaunchScreenBrsa.storyboard`
      et `LaunchScreenCej.storyboard`.
    - Ouvrez Xcode.
    - Dans l'explorateur de fichiers d'Xcode, ouvrez le dossier `Runner/Runner/`.
    - Glissez les fichiers générés depuis la fenêtre Finder dans l'explorateur de fichiers d'Xcode.
    - [ATTENTION] Pour voir les modifications, il faut lancer l'app, la fermer, puis la relancer
      depuis la page d'accueil du téléphone.

# Dépendances

- Lancer la commande `$flutter pub outdated`.
- A la main, mettre à jour les versions remontées dans les sorties `direct dependencies`
  et `dev_dependencies`.
- Vérifier que le projet compile bien en lançant la commande `$flutter pub get`.

## Déployer une app sur Firebase App Distribution avec les Github actions

A chaque push sur la branche main, un build et un déploiement sont faits sur Firebase App
Distribution. Lorsque des variables d'environnement sont modifiées/ajoutées, il faut les ajouter
dans les secrets github. Le fichier `ci/.env.template` permet de lister les variables nécessaires.
Pour rappel, elles sont stockées dans les notes partagées Dashlane (`[APP MOBILE] .env.staging`
ou `[APP MOBILE] .env.prod`).

#### Ajouter un appareil iOS pour les tests internes

1. Ajouter le device sur App Store Connect (Firebase nous envoit directement un mail avec l'UDID du
   smartphone quand l'utilisateur tente de télécharger l'app de test sur iOS).
2. Mettre à jour le Provisioning Profil Ad Hoc de Staging avec ce nouveau device ajouté.
3. Relancer la CI (ou attendre un prochain build) : la dernière version du Provisioning Profile est
   directement prise en compte dans le build.

#### Mettre à jour ou insérer de nouvelles variables d'environnement dans Github Action

1. Assurer vous d'avoir mis la ou les nouvelles variables d'environnement dans le fichier
   local `env/.env.staging` et `env/.env.prod` et dans Dashlane (pour la postérité).
2. Lancer le script `bash scripts/generate_env_ci.sh`
3. Récupérer les valeurs de `STAGING_RUNTIME_ENV_B64` et de `PROD_RUNTIME_ENV_B64` dans le
   fichier `ci/env.ci`.
4. Mettre à jour le secret de Github action 'STAGING_RUNTIME_ENV_B64' (Github > Settings > Secrets).

## Déployer une nouvelle version de l'app en bêta test sur les stores publics

Lancer le script `release.sh` avec le numéro de version en paramètre :

```shell script
$ ./scripts/release.sh <major.minor.patch>
```

La pipeline de production se lancera automatiquement dans la foulée. À la fin du job, le build de
l'appli se retrouve disponible :

- Instantanément en test interne sur le Play Store Android. Il faut cependant attendre un moment
  avant que les utilisateurs internes puissent le voir dans le Play Store.
- Sur Test Flight, même s'il faut environ 10 minutes pour qu'il soit automatiquement poussé au
  groupe de testeurs internes "Équipe projet".

## Déployer un hotfix de l'app en bêta test sur les stores publics

1. Faire un checkout du dernier tag envoyé en prod. 
(Note : La suite se fera sur un *detached HEAD*).

2. Corriger les problèmes, puis committer en local.

3. En restant sur le HEAD, lancer le script `hotfix.sh` avec le numéro de version en paramètre :

```shell script
$ ./scripts/hotfix.sh <major.minor.patch>
```

4. Si besoin, appliquer également la correction sur la branche main.

La pipeline de production se lancera automatiquement dans la foulée. À la fin du job, le build de
l'appli se retrouve disponible :

- Instantanément en test interne sur le Play Store Android. Il faut cependant attendre un moment
  avant que les utilisateurs internes puissent le voir dans le Play Store.
- Sur Test Flight, même s'il faut environ 10 minutes pour qu'il soit automatiquement poussé au
  groupe de testeurs internes "Équipe projet".

## Promouvoir la version pour tous les utilisateurs

### Pour Android

1. Aller sur la console Google Play de l'application.
2. Dans le pannel de gauche, aller sur `Tests internes`, puis `Promouvoir la release`.
3. La validation peut prendre _jusqu'à 48h_.

### Pour iOS

1. Aller sur [App Store Connect](https://appstoreconnect.apple.com/apps).
2. Créer une version sur l'onglet App Store à partir du build idoine.
3. La vérification peut prendre _jusqu'à 72h_.
