L'application iOS et Android Pass Emploi

## Code style
A date, nous utilisons le code style par défaut de l'IDE Android Studio pour le langage Dart. La 
seule spécificité est de mettre le nombre de caractère par ligne à 120 : dans les préférences de 
l'IDE `Editor > Code Style > Dart > Line length`


## Renseigner l'adresse du serveur
Dans `Run` > `Edit Configurations`, rajouter la base URL du backend 
sur le net `Additional arguments` > `--flavor <staging | prod> --dart-define=SERVER_BASE_URL=<YOUR_SERVER_BASE_URL> --dart-define=FIREBASE_ENVIRONMENT_PREFIX=<staging | prod>`

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
### Prérequis
1. Se mettre à jour sur master
2. Vérifier que les tests sont au vert : `$ flutter test`
3. Mettre à jour le version name et incrementer le version code dans le fichier `pubspec.yaml` (variable `version`)
4. Commiter le changement

### Pour Android
1. Vérifier que le fichier `passemploi.jks` (fichier privé) est bien situé dans le repertoire `android/keystore` 
2. Créer un fichier `key.properties` dans le repertoire `android` à partir du même modèle que `key.properties.template`. Ce fichier ne doit JAMAIS être versionné.
3. Renseigner les valeurs demandées (valeurs présentes dans le Drive du projet) dans ce fichier.
4. Construire l'APK en release : `$ flutter build apk --flavor staging --dart-define=SERVER_BASE_URL=<YOUR_SERVER_BASE_URL> --dart-define=FIREBASE_ENVIRONMENT_PREFIX=staging`
5. Récupérer l'APK `build/app/outputs/flutter-apk/app-release.apk` 
6. Créer une version avec cet APK sur [Firebase App Distribution](https://console.firebase.google.com/u/0/project/pass-emploi-staging/appdistribution/app/android:fr.fabrique.social.gouv.passemploi.staging/releases)
7. Ajouter le groupe `Equipe projet` aux testeurs
8. Distribuer la version


### Pour iOS
1. Vérifier que votre compte Apple Dev ait bien accès au compte Apple "Fabrique numérique des ministères sociaux"
2. Ouvrir le projet dans Xcode
3. Configurer XCode, notamment sur la partie `Signing & Capabilities` [https://flutter.dev/docs/deployment/ios] en renseignant le bon provisioning profile de l'app `fr.fabrique.socialgouv.passemploi.staging`
4. Lancer le build iOS release : `flutter build ipa --flavor staging --dart-define=SERVER_BASE_URL=<YOUR_SERVER_BASE_URL> --dart-define=FIREBASE_ENVIRONMENT_PREFIX=staging`
5. Revenir dans Xcode
6. Selectionner Product > Scheme > Runner.
7. Selectionner Product > Destination > Any iOS Device.
8. Selectionner Product > Archive.
9. Une fois l'archive réalisée, cliquer sur Distribute App > Adhoc> Répréciser le provisioning.profile `fr.fabrique.socialgouv.passemploi.staging` > Export
10. Récupérer l'IPA `pass_emploi_app.ipa`
11. Créer une version avec cet IPA sur [Firebase App Distribution](https://console.firebase.google.com/project/pass-emploi-staging/appdistribution/app/ios:fr.fabrique.social.gouv.passemploi.staging/releases)
12. Ajouter le groupe `Equipe projet` aux testeurs
13. Distribuer la version

## Déployer une app en bêta test sur les stores publics
### Prérequis
1. Se mettre à jour sur master
2. Vérifier que les tests sont au vert : `$ flutter test`
3. Mettre à jour le version name et incrementer le version code dans le fichier `pubspec.yaml` (variable `version`)
4. Commiter le changement
5. Tagger la release
```shell script
$ git tag -a major.minor.patch -m "major.minor.patch"
$ git push --tags 
```


### Pour Android
1. Vérifier que le fichier `passemploi.jks` (fichier privé) est bien situé dans le repertoire `android/keystore` 
2. Créer un fichier `key.properties` dans le repertoire `android` à partir du même modèle que `key.properties.template`. Ce fichier ne doit JAMAIS être versionné.
3. Renseigner les valeurs demandées (valeurs présentes dans le Drive du projet) dans ce fichier.
4. Construire l'APK en release : `$ flutter build appbundle --dart-define=SERVER_BASE_URL=<YOUR_SERVER_BASE_URL> --dart-define=FIREBASE_ENVIRONMENT_PREFIX=prod`
5. Récupérer l'AAB  `build/app/outputs/bundle/release/app-release.aab`
6. Aller sur la console Google Play de l'application.
7. Dans le pannel de gauche, aller sur `Tests ouverts`, puis `Créer une release`
8. Uploader l'AAB. 
9. Cliquer sur `Enregister`, puis `Soumettre`, puis `Lancer le déploiement en version tests ouverts`.
10. La validation peut prendre *jusqu'à 48h*.

### Pour iOS
1. Vérifier que votre compte Apple Dev ait bien accès au compte Apple "Fabrique numérique des ministères sociaux"
2. Lancer le build iOS release : `flutter build ipa --dart-define=SERVER_BASE_URL=<YOUR_SERVER_BASE_URL> --dart-define=FIREBASE_ENVIRONMENT_PREFIX=prod`
3. Ouvrir le projet dans Xcode
4. Configurer XCode, notamment sur la partie `Signing & Capabilities` [https://flutter.dev/docs/deployment/ios] en renseignant le bon provisioning profile de l'app `fr.fabrique.socialgouv.passemploi.distribution`
5. Selectionner Product > Scheme > Runner.
6. Selectionner Product > Destination > Any iOS Device.
7. Selectionner Product > Archive.
8. Une fois l'archive réalisée, cliquer sur Distribute App > App Store Connect> Upload
9. Garder les checkbox `Strip Swift symbols` et `Upload your app symbols…` cochées, puis Next
10. Dans `Runner.app, choisir `fr.fabrique.socialgouv.passemploi.distribution`, puis Next puis Upload
11. /!\ Attention : l'étape précédente peut prendre plusieurs minutes. Mais si au bout de 10 minutes 
il ne se passe rien, c'est potentiellement dû à un mauvais réseau sur votre poste. Dans ce cas là, 
il faut annuler, et recommencer à l'étape 8. 
12. Aller sur [https://appstoreconnect.apple.com/apps](App Store Connect)
13. Dans l'onglet `Test flight` de l'app `Pass Emploi`, attendre que la version tout juste uploadée 
soit bien présente. Il ne faut pas hésiter à rafraichir la page régulièrement.
14. Par défaut, un warning apparaît `Attestation manquantes`. Indiquez que *non*, il n'y a pas 
d'algorithme de chiffrement dans l'app.
15. Dans le pannel de gauche, Test externes > Ambassadeurs, rajoutez le build tout juste uplpoadé 
(section `Build` en bas de la page).
16. La vérification peut prendre *jusqu'à 72h*.