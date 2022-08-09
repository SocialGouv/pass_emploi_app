import 'package:freezed_annotation/freezed_annotation.dart';

part 'affichage_state.freezed.dart';

// ignore_for_file: avoid_print

// flutter pub run build_runner build
// pour générer les fichiers, quand on modifie un type @freezed

// on peut commit les fichiers généré, donc pas pré-requis que la CI le fasse
// 1s pour run avec cette douzaine de classe à générer
// j'ai vu deux devs parler de 40s de génération, avec des projets de 50k lignes. et parler de cache de génération.
// dans la mesure où on ne modifie pas / n'ajoutes pas sans cesse des types @freezed, ça peut sembler acceptable ?
// (c'est toujours plus rapide que de le faire à la main, et moins source d'erreur)

@freezed
class Affichage with _$Affichage {
  const factory Affichage({required String title, required String text}) = _Affichage;
}

@freezed
class AffichageState with _$AffichageState {
  const factory AffichageState.notInit() = NotInit;

  const factory AffichageState.loading() = Loading;

  const factory AffichageState.success(Affichage affichage) = Content;

  const factory AffichageState.error(String message) = Error;
}

void foo() {
  final affichage = Affichage(title: "Super", text: "ça marche").copyWith(title: "Génial");
  final state = AffichageState.success(affichage);
  state.maybeWhen(
    success: (affichage) => print("OKKK $affichage"),
    orElse: () => print("else :)"),
  );
}



@freezed
class Un with _$Un {
  const factory Un.notInit() = LeUnNotInit;

  const factory Un.loading() = LeUnLoading;

  const factory Un.success(Affichage affichage) = LeUnContent;

  const factory Un.error(String message) = LeUnError;
}

@freezed
class Deux with _$Deux {
  const factory Deux.notInit() = DeuxNotInit;

  const factory Deux.loading() = DeuxLoading;

  const factory Deux.success(Affichage affichage) = DeuxContent;

  const factory Deux.error(String message) = DeuxError;
}

@freezed
class Trois with _$Trois {
  const factory Trois.notInit() = TroisNotInit;

  const factory Trois.loading() = TroisLoading;

  const factory Trois.success(Affichage affichage) = TroisContent;

  const factory Trois.error(String message) = TroisError;
}

@freezed
class Quatre with _$Quatre {
  const factory Quatre.notInit() = QuatreNotInit;

  const factory Quatre.loading() = QuatreLoading;

  const factory Quatre.success(Affichage affichage) = QuatreContent;

  const factory Quatre.error(String message) = QuatreError;
}

@freezed
class Cinq with _$Cinq {
  const factory Cinq.notInit() = CinqNotInit;

  const factory Cinq.loading() = CinqLoading;

  const factory Cinq.success(Affichage affichage) = CinqContent;

  const factory Cinq.error(String message) = CinqError;
}

@freezed
class Six with _$Six {
  const factory Six.notInit() = SixNotInit;

  const factory Six.loading() = SixLoading;

  const factory Six.success(Affichage affichage) = SixContent;

  const factory Six.error(String message) = SixError;
}

@freezed
class Sept with _$Sept {
  const factory Sept.notInit() = SeptNotInit;

  const factory Sept.loading() = SeptLoading;

  const factory Sept.success(Affichage affichage) = SeptContent;

  const factory Sept.error(String message) = SeptError;
}

@freezed
class Huit with _$Huit {
  const factory Huit.notInit() = HuitNotInit;

  const factory Huit.loading() = HuitLoading;

  const factory Huit.success(Affichage affichage) = HuitContent;

  const factory Huit.error(String message) = HuitError;
}

@freezed
class Neuf with _$Neuf {
  const factory Neuf.notInit() = NeufNotInit;

  const factory Neuf.loading() = NeufLoading;

  const factory Neuf.success(Affichage affichage) = NeufContent;

  const factory Neuf.error(String message) = NeufError;
}

@freezed
class Dix with _$Dix {
  const factory Dix.notInit() = DixNotInit;

  const factory Dix.loading() = DixLoading;

  const factory Dix.success(Affichage affichage) = DixContent;

  const factory Dix.error(String message) = DixError;
}

@freezed
class Onze with _$Onze {
  const factory Onze.notInit() = OnzeNotInit;

  const factory Onze.loading() = OnzeLoading;

  const factory Onze.success(Affichage affichage) = OnzeContent;

  const factory Onze.error(String message) = OnzeError;
}

@freezed
class Douze with _$Douze {
  const factory Douze.notInit() = DouzeNotInit;

  const factory Douze.loading() = DouzeLoading;

  const factory Douze.success(Affichage affichage) = DouzeContent;

  const factory Douze.error(String message) = DouzeError;
}

@freezed
class Treize with _$Treize {
  const factory Treize.notInit() = TreizeNotInit;

  const factory Treize.loading() = TreizeLoading;

  const factory Treize.success(Affichage affichage) = TreizeContent;

  const factory Treize.error(String message) = TreizeError;
}
