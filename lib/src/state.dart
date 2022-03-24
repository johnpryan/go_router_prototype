import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tree_router/src/inheritance.dart';

import 'match.dart';

class RouteState extends ChangeNotifier {
  RouteMatch? _match;

  RouteState(this._match);

  set match(RouteMatch? match) {
    // Don't notify listeners if the destination is the same
    if (_match == match) return;

    _match = match;
    notifyListeners();
  }

  RouteMatch? get match => _match;

  void pop() {
    _match = match?.pop();
    notifyListeners();
  }

  static RouteState? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<RouteStateScope>();
    if (scope == null) return null;
    return scope.routeState;
  }
}
