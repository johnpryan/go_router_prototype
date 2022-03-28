// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide Route;
import 'package:tree_router/src/inheritance.dart';

import 'match.dart';
import 'route.dart';
import 'tree.dart';

class GlobalRouteState extends ChangeNotifier {
  final RouteTree _routeTree;
  late RouteMatch _match;

  GlobalRouteState(List<Route> routes) : _routeTree = RouteTree(routes) {
    _match = _routeTree.get('/');
  }

  Future setMatch(RouteMatch match) async {
    match = await _handleRedirects(match);
    _match = match;
    notifyListeners();
  }

  RouteMatch get match => _match;

  void pop() {
    _match = _routeTree.pop(_match);
    notifyListeners();
  }

  Future goTo(String path, {Route? parentRoute, bool isInitial = false}) async {
    if (isInitial) {
      await setMatch(_routeTree.get(path));
    } else {
      await setMatch(_routeTree.get(path,
          parentRoute: parentRoute, previousMatch: _match));
    }
  }

  Future<RouteMatch> _handleRedirects(RouteMatch match) async {
    return _handleRedirectsRecursive(match);
  }

  Future<RouteMatch> _handleRedirectsRecursive(RouteMatch match,
      {int endIndex = 0}) async {
    if (endIndex < 0) endIndex = 0;
    for (var i = match.routes.length - 1; i >= endIndex; i--) {
      final route = match.routes[i];
      final redirect = route.redirect;
      if (redirect != null) {
        final newPath = await redirect(match);
        if (newPath != null) {
          final newMatch = _routeTree.get(
            newPath,
            parentRoute: route,
            previousMatch: match,
          );
          // If the previous match is a prefix of the new match, stop searching
          // for redirects at the point where the two routes are the same.
          //
          // For example, if the previous match was '/a/b', and the new match is
          // /a/b/c, we can skip searching '/a/b' for redirects, since those
          // will be handled by previous invocations of this method on the call
          // stack.
          if (match.isPrefixOf(newMatch)) {
            final endIndex = match.getMatchingPrefixIndex(newMatch);
            return _handleRedirectsRecursive(newMatch,
                endIndex: endIndex);
          }
          return _handleRedirectsRecursive(newMatch);
        }
      }
    }
    return SynchronousFuture(match);
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
