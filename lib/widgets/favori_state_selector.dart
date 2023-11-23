import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class FavorisStateContext<T> extends InheritedWidget {
  final FavoriIdsState<T> Function(Store<AppState> store) selectState;

  FavorisStateContext({required super.child, required this.selectState});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
