L'application iOS et Android Pass Emploi

## Renseigner l'adresse du serveur de dev
Dans `Run` > `Edit Configurations`, rajouter l'ID du serveur Ngrok utilisé pour mettre votre backend 
sur le net `Additional arguments` > `--dart-define=NGROK_SERVER_ID=<ID du serveur NGROK>`


## Déployer une app sur Firebase
### Prérequis
1. Se mettre à jour sur master
2. Mettre à jour le version name et incrementer le version code dans le fichier `pubspec.yaml` (variable `version`)
3. Commiter le changement 
4. Vérifier que les tests sont au vert : `$ flutter test`

### Pour Android
1. Vérifier que le fichier `passemploi.jks` (fichier privé) est bien situé dans le repertoire `android/keystore` 
2. Créer un fichier `key.properties` dans le repertoire `android` à partir du même modèle que `key.properties.template`. Ce fichier ne doit JAMAIS être versionné.
3. Renseigner les valeurs demandées (valeurs présentes dans le Drive du projet) dans ce fichier.
4. Construire l'APK en release : `$ flutter build apk --dart-define=NGROK_SERVER_ID=<ID du serveur NGROK>`
5. Récupérer l'APK `build/app/outputs/flutter-apk/app-release.apk` 
6. Créer une version avec cet APK sur Firebase App Distribution : https://console.firebase.google.com/u/1/project/pass-emploi/appdistribution/app/android:fr.fabrique.social.gouv.passemploi/releases
7. Ajouter le groupe `Equipe projet` aux testeurs
8. Distribuer la version 


### Pour iOS
1. Vérifier que votre compte Apple Dev ait bien accès au compte Apple "Fabrique numérique des ministères sociaux"
2. COnfigurer XCode, notamment sur la partie `Signing & Capabilities` [https://flutter.dev/docs/deployment/ios]
3. Lancer le build iOS release : flutter build ipa --dart-define=NGROK_SERVER_ID=<ID du serveur NGROK>`
4. Ouvrir le projet dans Xcode
5. Selectionner Product > Scheme > Runner.
6. Selectionner Product > Destination > Any iOS Device.
7. Selectionner Product > Archive.
8. Une fois l'archive réalisée, cliquer sur "Distribute App"
9. Developpement