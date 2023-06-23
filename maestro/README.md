# Utilisation

## Inline
`maestro test -e MAESTRO_LOGIN=perceval -e MAESTRO_PASSWORD=cépafo flow.yaml`

## Export
```bash
export MAESTRO_LOGIN=perceval
export MAESTRO_PASSWORD=cépafo
maestro test flow.yaml
```

# Les variables à renseigner
**!!! Doivent être préfixées par `MAESTRO_`**.
- MAESTRO_LOGIN : login du bénéficiaire pour se connecter
- MAESTRO_PASSWORD : mot de passe du bénéficiaire pour se connecter

# Documentations
- https://maestro.mobile.dev/