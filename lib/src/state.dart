// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart' hide Route;
import 'package:tree_router/src/inheritance.dart';

import 'match.dart';
import 'route.dart';
import 'tree.dart';

class GlobalRouteState extends ChangeNotifier {
  final RouteTree _routeTree;
  late RouteMatch _match;

  GlobalRouteState(List<Route> routes) : _routeTree = RouteTree(routes);

  set match(RouteMatch match) {
    // Don't notify listeners if the destination is the same
    if (_match == match) return;

    _match = match;
    notifyListeners();
  }

  RouteMatch get match => _match;

  void pop() {
    _match = _routeTree.pop(_match);
    notifyListeners();
  }

  void goTo(String path, {Route? parentRoute, bool isInitial = false}) {
    if (isInitial) {
      _match = _routeTree.get(path);
      notifyListeners();
    } else {
      match =
          _routeTree.get(path, parentRoute: parentRoute, previousMatch: _match);
    }
  }

  static GlobalRouteState? of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<GlobalRouteStateScope>();
    if (scope == null) return null;
    return scope.state;
  }
}

class RouteState extends ChangeNotifier {
  final Route route;
  final GlobalRouteState _globalRouteState;

  RouteState(this.route, GlobalRouteState globalState)
      : _globalRouteState = globalState;

  void goTo(String path) {
    _globalRouteState.goTo(path, parentRoute: route);
  }

  void pop() {
    _globalRouteState.pop();
  }

  Map<String, String> get queryParameters =>
      _globalRouteState.match.parameters.query;

  Map<String, String> get pathParameters =>
      _globalRouteState.match.parameters.path;

  Route? get activeChild {
    final routes = _globalRouteState.match.routes;

    final index = routes.indexOf(route);
    if (index < 0) {
      throw Exception('Route not found in global route state: $route');
    }

    final nextIndex = index + 1;
    if (nextIndex >= routes.length) {
      return null;
    }

    return routes[nextIndex];
  }

  static RouteState? of(BuildContext context) {
    final routeStateScope =
        context.dependOnInheritedWidgetOfExactType<RouteStateScope>();
    if (routeStateScope == null) return null;
    return routeStateScope.state;
  }
}

class InitialRouteNotFoundError extends Error {
  final String initialRoute;

  InitialRouteNotFoundError(this.initialRoute);

  @override
  String toString() => 'No routes found for initial route: "$initialRoute"';
}
