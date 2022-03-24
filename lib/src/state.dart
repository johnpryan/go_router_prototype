import 'package:flutter/widgets.dart' hide Route;
import 'package:tree_router/src/inheritance.dart';

import 'match.dart';
import 'tree.dart';
import 'route.dart';

class RouteState extends ChangeNotifier {
  final RouteTree _routeTree;
  RouteMatch? _match;

  RouteState(List<Route> routes) : _routeTree = RouteTree(routes);

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

  void goTo(String path) {
    match = _routeTree.get(path);
  }

  Route? getTopRoute() => match?.getTopRoute();

  static RouteState? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<RouteStateScope>();
    if (scope == null) return null;
    return scope.routeState;
  }
}
