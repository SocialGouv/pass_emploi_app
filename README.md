L'application iOS et Android Pass Emploi

## Pratiques de dev et conventions

Celles-ci sont spécifiées dans le fichier [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Renseigner les variables d'environnement

Créer un fichier dans le répertoire `env` intitulé `env.staging` en vous inspirant du
fichier `env.template` situé à la racine du projet. Y insérer toutes les bonnes valeurs. Elles se
trouvent dans les notes partagées Dashlane (`[APP MOBILE] .env.staging` ou `[APP MOBILE] .env.prod`)
.

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

Le projet utilise plusieurs foncionnalités de Firebase. Les secrets ne sont pas et ne doivent pas
être commités (à ce titre, ils sont présent dans le `.gitignore`. Pour autant, ils sont nécessaires
au bon fonctionnement de l'application. Ils sont téléchargeables directement depuis Firebase.

Pour rappel ces fichiers ne doivent pas être versionnés (le gitignore est déjà configuré pour).

# Pour l'environnement de staging

1. Télécharger les fichiers `google-services.json`
   et `GoogleService-Info.plist` [ici](https://console.firebase.google.com/project/pass-emploi-staging/settings/general)
   .
2. Les déplacer respectivement dans les dossiers suivants (à créer) :

- Android : `/android/app/src/staging/google-services.json`
- iOS : `/ios/firebase-config/staging/GoogleService-Info.plist`

# Pour l'environnement de prod

1. Télécharger les fichiers `google-services.json`
   et `GoogleService-Info.plist` [ici](https://console.firebase.google.com/u/1/project/pass-emploi/settings/general)
   .
2. Les déplacer respectivement dans les dossiers suivants (à créer) :

- Android : `/android/app/src/prod/google-services.json`
- iOS : `/ios/firebase-config/prod/GoogleService-Info.plist`

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
- Exécuter "flutter run" pour vérifier que le projet compile et que l'application démarre comme prévu

# Dépendances

- Lancer la commande `$flutter pub outdated`.
- A la main, mettre à jour les versions remontées dans les sorties `direct dependencies`
  et `dev_dependencies`.
- Vérifier que le projet compile bien en lançant la commande `$flutter pub get`.

## Déployer une app sur Firebase App Distribution avec les Github actions

A chaque push sur la brancheð develop, un build et un déploiement sont faits sur Firebase App
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

1. **Prérequis : avoir corrigé le bug rencontré sur les branches `master` ET `develop`**
2. Lancer le script `hotfix.sh` avec le numéro de version en paramètre :

```shell script
$ ./scripts/hotfix.sh <major.minor.patch>
```

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
