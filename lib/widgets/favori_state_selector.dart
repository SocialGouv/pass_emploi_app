import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class FavorisStateContext<T> extends InheritedWidget {
  final FavoriListState<T> Function(Store<AppState> store) selectState;

  FavorisStateContext({required Widget child, required this.selectState}) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
