#!/bin/bash
### Prérequis : renseigner toutes les variables en souhaitées
### Pour l'utiliser : ./script/send-notification.sh

API_ACCESS_KEY="Mettre ici la valeur de Clé du Serveur API Cloud Messaging disponible dans les paramètres de l'application dans Firebase"
DEVICE_TOKEN="Mettre ici le token de l'appareil dans la console au lancement de l'app"
NOTIFICATION_TITLE="Un titre de notification"
NOTIFICATION_BODY="Un body"
NOTIFICATION_DATA_TYPE="Mettre ici un des types de notifications présent dans deep_link_factory.dart"
NOTIFICATION_DATA_ID="Un ID"


echo "##### Send notification with content $NOTIFICATION_BODY"
curl -X POST --header "Authorization: key=$API_ACCESS_KEY" \
    --Header "Content-Type: application/json" \
    https://fcm.googleapis.com/fcm/send \
    -d "{\"to\":\"$DEVICE_TOKEN\",\"notification\":{\"title\":\"$NOTIFICATION_TITLE\", \"body\":\"$NOTIFICATION_BODY\"},\"data\":{\"type\":\"$NOTIFICATION_DATA_TYPE\",\"id\":\"$NOTIFICATION_DATA_ID\"},\"priority\":10}"