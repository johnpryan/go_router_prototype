// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:path/path.dart' as p;
import 'package:tree_router/src/parameters.dart';

import 'match.dart';
import 'matching.dart';
import 'route.dart';

class RouteTree {
  List<RouteBase> routes;

  RouteTree(this.routes) {
    _validate();
  }

  RouteMatch get(String path,
      {RouteBase? parentRoute, RouteMatch? previousMatch}) {
    // If this is a relative path, search the children for a match.
    if (!path.startsWith('/')) {
      final children = parentRoute?.routes ?? [];
      for (var i = 0; i < children.length; i++) {
        final child = children[i];
        if (hasMatch(child.path, path)) {
          final ancestors =
              _getAncestors(parentRoute!, previousMatch: previousMatch);
          final matchedRoutes = [...ancestors, child];

          // Use the same parameters as the current match, but any routes that
          // are no longer matched need to have their parameters removed.
          Parameters parameters = extractParameters(child.path, path);
          if (previousMatch != null) {
            parameters =
                _removeOldParameters(previousMatch, matchedRoutes, parameters);
          }

          return _includeDefaultChild(
              RouteMatch(routes: matchedRoutes, parameters: parameters));
        }
      }
      throw ('No relative route for $path found as a child of route: $parentRoute');
    } else {
      return _getRecursive([], routes, path);
    }
  }

  RouteMatch pop(RouteMatch previousMatch) {
    final lastRoute = previousMatch.getLast();
    if (lastRoute == null) {
      throw RouteStateError(
          'Unable to call pop() because no matching routes were found');
    }

    final newRoutes = _getAncestors(lastRoute,
        inclusive: false, previousMatch: previousMatch);
    final newParams = _removeOldParameters(
        previousMatch, newRoutes, previousMatch.parameters);
    return RouteMatch(routes: newRoutes, parameters: newParams);
  }

  RouteMatch _includeDefaultChild(RouteMatch match) {
    final lastRoute = match.getLast();
    if (lastRoute == null) return match;
    final defaultChild =
        lastRoute is ShellRoute ? lastRoute.defaultRoute : null;
    if (defaultChild != null) {
      return get(defaultChild, parentRoute: lastRoute);
    }
    return match;
  }

  Parameters _removeOldParameters(
      RouteMatch oldMatch, List<RouteBase> newRoutes, Parameters newParams) {
    // Don't preserve query parameters when the route is relative.
    final newQueryParams = {...oldMatch.parameters.query, ...newParams.query};
    final newPathParams = {...oldMatch.parameters.path, ...newParams.path};
    final oldRoutesLength = oldMatch.routes.length;
    final newRoutesLength = newRoutes.length;

    if (newRoutesLength < oldRoutesLength) {
      for (var i = newRoutesLength; i < oldRoutesLength; i++) {
        final route = oldMatch.routes[i];
        final paramsToRemove = parseParameterNames(route.path);

        for (var paramToRemove in paramsToRemove) {
          if (newPathParams.containsKey(paramToRemove)) {
            newPathParams.remove(paramToRemove);
          }
        }
      }
    }
    return Parameters(newPathParams, newQueryParams);
  }

  // Checks that all route paths are correct, according to these rules:
  // - Top-level routes start with '/'
  // - Sub-routes *don't* start with '/')
  void _validate() {
    _validateRecursive(routes, true);
  }

  void _validateRecursive(List<RouteBase> routes, bool topLevel) {
    // A '/' route is required because PlatformRouteInformationProvider uses
    // WidgetsBinding.instance!.window.defaultRouteName, which will be '/' if no
    // default route was requested.
    bool foundDefaultRoute = false;
    for (var route in routes) {
      if (topLevel && route.path == '/') {
        foundDefaultRoute = true;
      }
      if (topLevel && !route.path.startsWith('/')) {
        throw RouteConfigurationError(
            'Top-level paths must start with "/"', route);
      } else if (!topLevel && route.path.startsWith('/')) {
        throw RouteConfigurationError(
            'Sub-route paths cannot start with "/"', route);
      }
      _validateRecursive(route.routes, false);
    }

    if (topLevel && !foundDefaultRoute) {
      throw RouteConfigurationError(
          'A top-level route with the path "/" is required');
    }
  }

  /// Recursively searches for a match. [prefixes] is the list of
  /// parent Routes that have matched so far.
  RouteMatch _getRecursive(
      List<RouteBase> prefixes, List<RouteBase> current, String path) {
    for (var route in current) {
      if (hasExactMatch(route.path, path)) {
        prefixes.add(route);
        final parameters = extractParameters(route.path, path);
        return _includeDefaultChild(
            RouteMatch(routes: prefixes, parameters: parameters));
      }
    }

    for (var route in current) {
      final prefixStrings = <String>[];
      for (var prefix in prefixes) {
        prefixStrings.add(prefix.path);
      }

      final routePathWithPrefixes = route.path.startsWith('/')
          ? route.path
          : p.joinAll([...prefixStrings, route.path]);

      if (hasMatch(routePathWithPrefixes, path)) {
        prefixes.add(route);
        final childMatch = _getRecursive(prefixes, route.routes, path);
        if (childMatch.routes.isNotEmpty) {
          // More of the route was matched, return that match instead
          return childMatch;
        }

        // This is a relative route and no children matched, so return this
        // as the result.
        final parameters = extractParameters(routePathWithPrefixes, path);
        return _includeDefaultChild(
            RouteMatch(routes: prefixes, parameters: parameters));
      }
    }
    return RouteMatch(routes: [], parameters: Parameters.empty());
  }

  List<RouteBase> _getAncestors(RouteBase routeToFind,
      {RouteMatch? previousMatch, bool inclusive = true}) {
    return _getAncestorsRecursive(
        routes, routeToFind, [], inclusive, previousMatch);
  }

  List<RouteBase> _getAncestorsRecursive(
      List<RouteBase> current,
      RouteBase routeToFind,
      List<RouteBase> prefixes,
      bool inclusive,
      RouteMatch? previousMatch) {
    final currentPathTemplate = p.joinAll(prefixes.map((r) => r.path));
    bool routeHasCorrectPrefix = previousMatch == null
        ? true
        : hasMatch(currentPathTemplate, previousMatch.path);
    for (var route in current) {
      if (route == routeToFind && routeHasCorrectPrefix) {
        return [
          ...prefixes,
          if (inclusive) routeToFind,
        ];
      }
      final searchedChildren = _getAncestorsRecursive(route.routes, routeToFind,
          [...prefixes, route], inclusive, previousMatch);
      if (searchedChildren.isNotEmpty) {
        return searchedChildren;
      }
    }
    return [];
  }
}

class RouteConfigurationError extends Error {
  final String message;
  final RouteBase? route;

  RouteConfigurationError(this.message, [this.route]);

  @override
  String toString() => route == null ? message : '$message: "${route!.path}"';
}

class RouteStateError extends Error {
  final String message;

  RouteStateError(this.message);

  @override
  String toString() => message;
}
