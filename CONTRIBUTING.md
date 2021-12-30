# Introduction
Ce document liste les différentes pratiques de dev mises en place sur le projet, articulées autour de domaines suivants :
* Les conventions de code
* Gestion des cas non nominaux
* L'usage de Redux
* Les tests automatisés
* Les conventions git


# Sommaire
* [Les conventions de code](#les-conventions-de-code)
    * [Code style du projet](#code-style-du-projet)
    * [L'usage du français et de l'anglais](#lusage-du-français-et-de-langlais)
    * [Nommage des variables](#nommage-des-variables)
    * [Forcer le typage](#forcer-le-typage)
    * [Réduire la visibilité par défaut](#réduire-la-visibilité-par-défaut)
    * [L'immutabilité par défaut](#limmutabilité-par-défaut)
    * [Expression body vs block body](#expression-body-vs-block-body)
* [Gestion des cas non nominaux](#gestion-des-cas-non-nominaux)
* L'usage de Redux
* Les tests automatisés


# Les conventions de code
Il n'est pas question ici d'être exhaustif sur le code style d'un projet Flutter / Dart. À cet effet, le [wiki de Flutter]
(https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo) propose tout un ensemble de convention bien plus 
détaillées.

## Code style du projet
À date, c'est le code style par défaut de l'IDE Android Studio pour le langage Dart qui est utilisé. La seule spécificité 
est de mettre le nombre de caractères par ligne à 120 : dans les préférences de l'IDE 
`Editor > Code Style > Dart > Line length`.

## L'usage du français et de l'anglais
Contrairement au projet backend, le choix est fait ici de n'utiliser le français que pour les termes fonctionnels, 
et ce même si la traduction du terme fonctionnel est évidente. Par exemple, il y a une classe `Jeune` et non pas 
`Young/Youth`, et `Offre` plutôt que `Offer`. Pour ce qui est des verbes, même associés à des termes français, nous les 
conservons en anglais s'ils ne sont pas fonctionnels. Ex : `isVolontaire` plutôt que `estVolontaire`.

## Nommage des variables
La logique Clean Code est appliquée ici : plus l'utilisation de la variable est éloigné de là où elle est utilisé, plus
elle est explicitement nommée. 

Ex : pour une instance de la classe `CallToAction` :
* si celle-ci est un attribut, elle est déclarée comme tel : `final CallToAction callToAction;`.
* si celle-ci est une variable, ou un paramètre de lambda, elle est déclarée comme tel : `cta`.

## Forcer le typage
Dart est un langage fortement typé qui permet facilement d'inférer les types des objets. Pour autant, par soucis de 
lisibilité et également pour d'avantage bénéficier du compilateur Dart, l'inférence de type est gérée comme suit :
* Toutes les méthodes (publiques et privées) doivent être typées.
    * S'il n'y a pas de type de retour, `void` est quand même précisé.
    * En utilisant le type le plus générique dès que possible (ex : retourner `Widget` plutôt que `Scaffold` ou 
    `List<Widget>` plutôt que `List<Text>`).
* Tous les attributs (publics et privés) doivent être typés.
* Au sein d'une méthode, le typage n'est pas nécessaire (ex : `final text = viewModel.text;`).

## Réduire la visibilité par défaut
Au sein d'un fichier ou d'une classe, tous les attributs et les `const` doivent autant que faire ce peut être déclarés 
privés (préfixés par un `_`). Seule exception à la règle pour les constructeurs avec des attributs nommés, dans quel 
cas l'usage du privé est trop verbeux. Les attributs sont alors laissés en public. 

## L'immutabilité par défaut
Autant que possible, toutes les variables sont déclarées en `final` et non pas en `var`. Dans la même logique, les 
`Widget` sont déclarés `StatelessWidget` dans la très grande majorité des cas.

## Expression body vs block body
Les `expression body` (ex : `void method() => print('');`) ne sont utilisés que quand ils tiennent sur une ligne.

## Déclarations des resources (wordings, assets…)
Afin de conserver à part toutes les resources du projet :
* Tous les strings affichés dans l'application doivent être déclarés dans le fichier `strings.dart`. Les messages de 
logging ne sont pas concernés. 
* Toutes les images affichées dans l'application doivent être déclarés dans le fichier `drawables.dart`.


# Gestion des cas non nominaux
Le langage Dart propose des exceptions, mais il n'y a pas moyen de déclarer qu'une méthode est susceptible d'en lancer 
autrement qu'en le documentant. Par contre, un retour de type `nullable` est bien pris en compte par le compilateur Dart.
Aussi, le paradigme suivant est utilisé :

* Quand il n'y a pas de différentiation applicative des cas non nominaux, c'est le retour `nullable` qui indique si la 
méthode a fonctionné nominalement ou pas. Si `null` est retourné, c'est qu'il y a une erreur. Il en est de même pour les 
retours de types `List` : si `null` est retourné, c'est qu'il y a une erreur. Si une liste vide est retournée, c'est que 
le cas nominal ne renvoie aucun résultat.

* Quand il y a une différentiation applicative des cas non nominaux, c'est alors il est nécessaire d'utiliser une classe
de retour dédiée (façon `sealed class` Kotlin) qui porte les retours nominaux et les différents cas d'erreur.

* Dès qu'un des objets du projet interagit avec un objet (du projet ou d'une dépendance) qui lance une exception, c'est 
à sa responsabilité de la `try-catch`, et de propager un nullable, ou une classe de retour dédiée.
