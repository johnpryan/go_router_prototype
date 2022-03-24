// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:path/path.dart' as p;
import 'package:tree_router/src/parameters.dart';

import 'match.dart';
import 'route.dart';
import 'matching.dart';

class RouteTree {
  List<Route> routes;

  RouteTree(this.routes);

  RouteMatch get(String path) {
    return _getRecursive([], routes, path);
  }

  /// Recursively searches for an exact match. [prefixes] is the list of
  /// parent Routes that have matched so far.
  ///
  /// This searches throughout the entire tree so that absolute paths are
  /// matched regardless of whether the parent Route objects contain a match.
  RouteMatch _getRecursive(
      List<Route> prefixes, List<Route> current, String path) {
    for (var route in current) {
      if (hasExactMatch(route.path, path)) {
        prefixes.add(route);
        final parameters = extractParameters(route.path, path);
        return RouteMatch(routes: prefixes, parameters: parameters);
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

      if (hasMatch(routePathWithPrefixes, path)) { prefixes.add(route);
        final childMatch = _getRecursive(prefixes, route.children, path);
        if (childMatch.routes.isNotEmpty) {
          // More of the route was matched, return that match instead
          return childMatch;
        }

        // This is a relative route and no children matched, so return this
        // as the result.
        final parameters = extractParameters(routePathWithPrefixes, path);
        return RouteMatch(routes: prefixes, parameters: parameters);
      } else {
        // Even though this route didn't match, keep searching recursively for
        // absolute paths

        prefixes.add(route);
        final childMatch = _getRecursive(prefixes, route.children, path);
        if (childMatch.routes.isNotEmpty) {
          return childMatch;
        }

        // No absolute paths were found, restore the prefixes list to its
        // previous state.
        prefixes.removeLast();
      }
    }
    return RouteMatch(routes: [], parameters: Parameters.empty());
  }
}
