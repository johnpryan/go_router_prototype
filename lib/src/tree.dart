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

  // Recursively searches for an exact match. [prefix] is a list of the
  // route path templates that have been matched for any parent Route objects.
  // This allows both relative and absolute paths to be defined.
  Route? _getRecursive(List<String> prefix, List<Route> routes, String path) {
    for (var route in routes) {
      if (hasExactMatch(route.path, path)) {
        return route;
      }
    }
    return null;
  }
}
