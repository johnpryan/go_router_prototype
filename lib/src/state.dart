// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart' hide Route;
import 'package:tree_router/src/inheritance.dart';

import 'match.dart';
import 'tree.dart';
import 'route.dart';

class GlobalRouteState extends ChangeNotifier {
  final RouteTree _routeTree;
  RouteMatch? _match;

  GlobalRouteState(List<Route> routes) : _routeTree = RouteTree(routes);

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

  void goTo(String path, {Route? parentRoute}) {
    match =
        _routeTree.get(path, parentRoute: parentRoute, previousMatch: match);
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

  static RouteState? of(BuildContext context) {
    final routeStateScope =
        context.dependOnInheritedWidgetOfExactType<RouteStateScope>();
    if (routeStateScope == null) return null;
    return routeStateScope.state;
  }
}
