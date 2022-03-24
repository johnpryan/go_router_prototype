// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'route.dart';

class RouteTree {
  List<Route> routes;

  RouteTree(this.routes);

  Route? get(String path) {
    return _getRecursive(routes, path);
  }

  Route? _getRecursive(List<Route> routes, String path) {
    for (var route in routes) {
      if (route.path == path) {
        return route;
      }
    }
    return null;
  }
}