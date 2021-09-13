L'application iOS et Android Pass Emploi

## Renseigner l'adresse du serveur
Dans `Run` > `Edit Configurations`, rajouter la base URL du backend 
sur le net `Additional arguments` > `--dart-define=SERVER_BASE_URL=<YOUR_SERVER_BASE_URL>`

## Renseigner les secrets Firebase
Le projet utilise plusieurs foncionnalité de firebase. Les secrets ne sont pas et ne doivent pas 
être commités (à ce titre, ils sont présent dans le `.gitignore`. Pour autant, ils sont nécessaires 
au bon fonctionnement de l'application. Ils sont téléchargeables directement depuis Firebase : 
[https://console.firebase.google.com/u/1/project/pass-emploi/settings/general] et doivent être 
dans les PATH suivants :
* Android : `/android/app/google-services.json`
* iOS : `/ios/Runner/GoogleService-Info.plist`


## Spécificité Firestore iOS
La dépendance basique de Firestore sur iOS augmente considérablement le temps de build de l'app iOS. 
Aussi pour éviter un tel écueil, on utilise un version précompilé proposée par la communauté. 
Si besoin de la mettre à jour, il faut le faire dans le fichier `ios/Podfile` :
`pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => 'X.X.X'` 

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
4. Construire l'APK en release : `$ flutter build apk --dart-define=SERVER_BASE_URL=<YOUR_SERVER_BASE_URL>`
5. Récupérer l'APK `build/app/outputs/flutter-apk/app-release.apk` 
6. Créer une version avec cet APK sur Firebase App Distribution : [https://console.firebase.google.com/u/1/project/pass-emploi/appdistribution/app/android:fr.fabrique.social.gouv.passemploi/releases]
7. Ajouter le groupe `Equipe projet` aux testeurs
8. Distribuer la version 


### Pour iOS
1. Vérifier que votre compte Apple Dev ait bien accès au compte Apple "Fabrique numérique des ministères sociaux"
2. COnfigurer XCode, notamment sur la partie `Signing & Capabilities` [https://flutter.dev/docs/deployment/ios] en renseingnant le bon provisioning profile de l'app `fr.fabrique.socialgouv.passemploi`
3. Lancer le build iOS release : `flutter build ipa --dart-define=SERVER_BASE_URL=<YOUR_SERVER_BASE_URL>`
4. Ouvrir le projet dans Xcode
5. Selectionner Product > Scheme > Runner.
6. Selectionner Product > Destination > Any iOS Device.
7. Selectionner Product > Archive.
8. Une fois l'archive réalisée, cliquer sur Distribute App > Adhoc> Répréciser le provisioning.profile `fr.fabrique.socialgouv.passemploi` > Export
9. Récupérer l'IPA `pass_emploi_app.ipa`
10. Créer une version avec cet IPA sur Firebase App Distribution : [https://console.firebase.google.com/u/1/project/pass-emploi/appdistribution/app/ios:fr.fabrique.social.gouv.passemploi/releases]
11. Ajouter le groupe `Equipe projet` aux testeurs
12. Distribuer la version 