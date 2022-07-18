# Tracking par composition avec le widget Tracker

* Statut : accepté
* Décideurs : Gabriel, Jordan
* Date : 2022-07-15
* PRs : [#381 Refactoring pour mise en place](https://github.com/SocialGouv/pass_emploi_app/pull/381)

## Contexte et Définition du Problème

Le tracking d'analytics se fait avec Matomo. Lorsque l'on track une page, il y a deux choses à
prendre en compte : l'affichage à son ouverture, et l'affichage lors d'un retour en arrière (back).

Pour répondre à ce besoin, les widget des pages héritent d'un Widget provenant du SDK de
Matomo (`TraceableStatelessWidget`/`TraceableStatefulWidget`) et une extension `pushAndTrackBack` a
été créée.

Une première tentative de refactoring a aussi été réalisée avec une notion de router.

## Facteurs de Décision

* Douleur : les widget doivent hériter, ça nous limite les possibilités si on souhaite hériter
  d'autres classes.
* Douleur : les widget doivent hériter d'une classe qui provient d'un SDK externe.
* Douleur : on répète l'analytics dans chaque appel de `pushAndTrackBack`.
* La tentative avec le router apporte de la complexité accidentelle.

## Solutions Étudiées

* Création d'un widget `Tracker` pour composer

Aperçu :

```
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.suppressionAccount,
      child: StoreConnector<AppState, SuppressionCompteViewModel>(
        converter: (store) => SuppressionCompteViewModel.create(store),
        builder: (context, viewModel) => _scaffold(context, viewModel),
      ),
    );
  }
```

## Résultat de la Décision

Solution retenue: "Création d'un widget `Tracker` pour composer", car elle supprime toutes les
douleurs présentes, apporte de la simplicité, et facilite le changement.

### Impacts Positifs

* Toutes les douleurs sont supprimées.
* On compose. *Composition over Inheritance*.
* On devient très flexible et on facilite le changement : on peut ajouter le `Tracker` à n'importe
  quel niveau dans l'arbre des widgets. Aucun problème, ça reste simple, peu importe si c'est une
  page classique, une page avec le StoreConnector qui s'actualise souvent, une page avec slider,
  etc.
* On découple. Changer l'outil de tracking ne prendra qu'une ligne.
