// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'route.dart';
import 'matching.dart';

class RouteTree {
  List<Route> routes;

  RouteTree(this.routes);

  Route? get(String path) {
    return _getRecursive([], routes, path);
  }

  /// Recursively searches for an exact match. [prefixes] is the list of
  /// parent routes that have matched so far.
  ///
  /// This searches throughout the entire tree so that absolute paths are matched
  /// regardless of whether the parent Route objects contain a match.
  Route? _getRecursive(List<Route> prefixes, List<Route> current, String path) {
    for (var route in current) {
      if (hasExactMatch(route.path, path)) {
        return route;
      }
    }
    for (var route in current) {
      if (hasMatch(route.path, path)) {
        prefixes.add(route);
        final childMatch = _getRecursive(prefixes, route.children, path);
        if (childMatch != null) return childMatch;
        // This is a relative route and no children matched, so return this
        // as the result.
        return route;
      }
    }
    return null;
  }
}
