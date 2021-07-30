L'application iOS et Android Pass Emploi

## Renseigner l'adresse du serveur de dev
Dans `Run` > `Edit Configurations`, rajouter l'ID du serveur Ngrok utilisé pour mettre votre backend 
sur le net `Additional arguments` > `--dart-define=NGROK_SERVER_ID=<SERVER_ID_VALUE>`


## Déployer une app sur Firebase
1. Se mettre à jour sur master
2. Mettre à jour le version name et incrementer le version code dans le fichier `pubspec.yaml` (variable `version`)
3. Commiter le changement 
4. Vérifier que les tests sont au vert : `$ flutter test`
5. Vérifier que le fichier `passemploi.jks` (fichier privé) est bien situé dans le repertoire `android/keystore` 
6. Créer un fichier `key.properties` dans le repertoire `android` à partir du même modèle que `key.properties.template`. Ce fichier ne doit JAMAIS être versionné.
7. Renseigner les valeurs demandées (valeurs présentes dans le Drive du projet) dans ce fichier.
8. Mettre en dur l'ID NGROK du serveur dans le fichier `main.dart` (ne pas commiter)
8. Construire l'APK en release : `$ flutter build apk`
9. Récupérer l'APK `build/app/outputs/flutter-apk/app-release.apk` 
8. Créer une version avec cet APK sur Firebase App Distribution : https://console.firebase.google.com/u/1/project/pass-emploi/appdistribution/app/android:fr.fabrique.social.gouv.passemploi/releases
9. Ajouter le groupe `Equipe projet` aux testeurs
10. Distribuer la version 
