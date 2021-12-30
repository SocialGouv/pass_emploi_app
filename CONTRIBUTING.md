# Introduction
Ce document liste les différentes pratiques de dev mises en place sur le projet, articulées autour de domaines suivants :
* Les conventions de code
* Gestion des cas non nominaux
* L'usage de Redux
* Les tests automatisés



# Sommaire
* [Les conventions de code](#les-conventions-de-code)
    * [Code style du projet](#code-style-du-projet)
    * [L'usage du français et de l'anglais](#lusage-du-français-et-de-langlais)
    * [Nommage des variables](#nommage-des-variables)
    * [Forcer le typage](#forcer-le-typage)
    * [Réduire la visibilité par défaut](#réduire-la-visibilité-par-défaut)
    * [L'immutabilité par défaut](#limmutabilité-par-défaut)
    * [Expression body vs block body](#expression-body-vs-block-body)
    * [Les arguments nommés](#les-arguments-nommés)
    * [Déclarations des resources](#déclarations-des-resources)
* [Gestion des cas non nominaux](#gestion-des-cas-non-nominaux)
    * [Utiliser les types nullables pour les cas simples](#utiliser-les-types-nullables-pour-les-cas-simples)
    * [Utiliser des objets pour les cas plus complexe](#utiliser-des-objets-pour-les-cas-plus-complexe)
    * [Ne pas propager les erreurs](#ne-pas-propager-les-erreurs)
* [L'usage de Redux](#lusage-de-redux)
    * [Pour les cas d'usage génériques, utiliser les classes dédiées](#pour-les-cas-dusage-génériques-utiliser-les-classes-dédiées)
    * [Au sein des `Widget` qui fonctionnent avec Redux](#au-sein-des-widget-qui-fonctionnent-avec-redux)
* [Les tests automatisés](#les-tests-automatisés)
    * [Les tests de la couche repository](#les-tests-de-la-couche-repository)
    * [Les tests de la couche Redux](#les-tests-de-la-couche-redux)
    * [Les tests de la couche ViewModel](#les-tests-de-la-couche-viewmodel)
    * [Les tests doubles](#les-tests-doubles)
    * [Les autres tests](#les-autres-tests)



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
`Young/Youth`, et `Offre` plutôt que `Offer`. Pour ce qui est des verbes, même associés à des termes français, name les 
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

## Les arguments nommés
Dès qu'un objet prend en paramètre plusieurs autres objets de même type, l'usage des paramètres nommés s'impose. 

## Déclarations des resources
Afin de conserver à part toutes les resources du projet (wordings, assets…) :
* Tous les strings affichés dans l'application doivent être déclarés dans le fichier `strings.dart`. Les messages de 
logging ne sont pas concernés. 
* Toutes les images affichées dans l'application doivent être déclarés dans le fichier `drawables.dart`.



# Gestion des cas non nominaux
Le langage Dart propose des exceptions, mais il n'y a pas moyen de déclarer qu'une méthode est susceptible d'en lancer 
autrement qu'en le documentant. Par contre, un retour de type `nullable` est bien pris en compte par le compilateur Dart.
Aussi, le paradigme suivant est utilisé :


## Utiliser les types nullables pour les cas simples
Quand il n'y a pas de différentiation applicative des cas non nominaux, c'est le retour `nullable` qui indique si la 
méthode a fonctionné nominalement ou pas. Si `null` est retourné, c'est qu'il y a une erreur. Il en est de même pour les 
retours de types `List` : si `null` est retourné, c'est qu'il y a une erreur. Si une liste vide est retournée, c'est que 
le cas nominal ne renvoie aucun résultat.

## Utiliser des objets pour les cas plus complexe
Quand il y a une différentiation applicative des cas non nominaux, c'est alors il est nécessaire d'utiliser une classe
de retour dédiée (façon `sealed class` Kotlin) qui porte les retours nominaux et les différents cas d'erreur.


## Ne pas propager les erreurs
Dès qu'un des objets du projet interagit avec un objet (du projet ou d'une dépendance) qui lance une exception, c'est 
à sa responsabilité de la `try-catch`, et de propager un nullable, ou une classe de retour dédiée.



# L'usage de Redux
Il n'est pas question ici de définir le mécanisme de Redux, mais plutôt de partager les pratiques qui y sont lié dans le 
projet.

## Pour les cas d'usage génériques, utiliser les classes dédiées
Avec les `actions`, les `reducers`, les `middlewares` et les `states`, Redux peut s'avérer assez verbeux. Aussi, pour les 
cas d'usage nominaux, à savoir à un repository, affichage du chargement, du succès ou d'une erreur, il est préconisé 
d'utiliser les classes génériques et les fichiers suivant :
 * `Action<REQUEST, RESULT>`
 * Le fichier `named_actions.dart`, qui définit une liste de `typedef` pour ces actions génériques, afin de ne pas avoir 
 à les écrire en entier. Il est à noter que l'IDE Android Studio ne parvient pas à automatiquement importer ces `typedef`.
 Aussi il est nécessaire d'écrire l'import `import 'package:pass_emploi_app/redux/actions/named_actions.dart';` à la main.
 * `Reducer<RESULT>`
 * `Repository<REQUEST, RESULT>`
 * `State<T>`
 
## Au sein des `Widget` qui fonctionnent avec Redux
* Afin de n'affecter l'état global de l'application que lors de l'affichage d'un écran, par convention le
`StoreConnector<AppState, ViewModel>` utilisé par le `Widget` doit être paramétré comme suit :
    * `onInit: (store) => store.dispatch(Action<REQUEST, RESULT>.request(REQUEST))` pour charger l'état à l'affichage du 
    `Widget`.
    * `onDispose: (store) => store.dispatch(Action<REQUEST, RESULT>.reset())` pour réinitialiser l'état à la suppression 
    du `Widget`.
* Pour ne pas redessiner inutilement le `Widget` à chaque changement d'état, il est nécessaire de s'assurer que :
    * Le `StoreConnector<AppState, ViewModel>` utilisé par le `Widget` doit être paramétré avec `distinct: true`.
    * Le `ViewModel` consommé par le `Widget` surcharge les méthodes `== ()` et `hashcode()`, a fortiori en étendant la 
    classe `Equatable` de la librairie `equatable` et en implémentant la méthode `List<Object?> get props`;
    
# Les tests automatisés
Afin d'assurer la stabilité et la documentation du code source, plusieurs types des tests automatisés doivent être 
systématiquement ajouté à chaque nouvelle fonctionnalité.

## Les tests de la couche repository
La couche repository est testée "en boîte noire" à la façon d'un test d'intégration. L'usage d'un `MockHttpClient` permet
de tester les repositories de la sorte. Il est possible de s'inspirer sur ce qui est notamment fait dans le fichier 
[`immersion_repository_test.dart`](test/repositories/immersion_repository_test.dart).

### Le cas nominal
Le test du cas nominal doit permettre de s'assurer que les bons paramètres sont passées, et que le parsing est bien fait.
À cet effet, un payload nominal peut être ajouté en tant que fichier `.json` au repertoire `test/assets`.

### Le cas d'un code retour HTTP invalide
Ce cas doit être testé pour s'assurer que le repository le prenne bien en compte.

### Le cas d'une exception
Ce cas doit être également testé pour s'assurer qu'aucune exception ne soit propagée.


## Les tests de la couche Redux
Afin de s'assurer que toute la boucle Redux fonctionne bien dans son ensemble (action > middleware > reducer > state), 
la couche Redux est testée "en boîte noire" à la façon d'un test d'intégration. Les tests correspondants se trouvent 
dans le répertoire `test/feature`, et permettent de s'assurer qu'une action modifie bien le state comme attendu. 
Des tests unitaires isolé de chacun des composants ne semble pour l'heure pas pertinents.

Il est à noté que ces tests qui sont de natures asynchrones peuvent échouer à cause d'un timeout qui est dépassé. Par
défaut, le timeout est de 30 secondes. Pour raccourcir cette durée, il est possible de passer cette commande en 
argument additionnel au test (en CLI ou via l'IDE) : `--timeout 0.1x`. Dès lors, le test échouera après 3 secondes au 
lieu de 30.


## Les tests de la couche ViewModel
L'essentiel du fonctionnel de l'application est porté dans la couche ViewModel. Il est dès lors attendu que 100% de la 
couche ViewModel soit testée unitairement.


## Les tests doubles
Les dernières versions des librairies de tests doubles à l'état de l'art en Dart (ex : `mockito`) fonctionne par de la 
génération de classe et offrent une developer experience bien moindre que leur pendant du monde Java. Pour l'heure, les 
tests doubles sont donc fait à la main comme suit :
* Dummy : à créer pour un objet qui renvoie toujours une valeur vide ou nulle.
* Mock : à créer pour un objet qui renvoie une valeur spécifique.
* Stub : à créer pour un objet qui renvoie une valeur spécifique en fonction de comment il est appelé.
* Spy : à créer pour un objet qui renvoie dont il est nécessaire de vérifier qu'il est bien appelé.

## Les autres tests
En dehors des cas mentionné ci-dessus, il est à l'entière liberté du contributeur de tester de manière automatisé un 
composant qui lui semble nécessaire de l'être.
 
 