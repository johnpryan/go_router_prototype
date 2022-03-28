// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:quiver/core.dart';
import 'package:tree_router/src/matching.dart';

import 'parameters.dart';
import 'route.dart';

class RouteMatch {
  static const _listEquality = ListEquality();

  final List<Route> routes;
  final Parameters parameters;

  const RouteMatch({
    required this.routes,
    required this.parameters,
  });

  Route? getLast() => routes.isEmpty ? null : routes.last;

  String get path {
    return fillParameters(p.joinAll(routes.map((r) => r.path)), parameters);
  }

  @override
  bool operator ==(Object other) {
    return other is RouteMatch &&
        _listEquality.equals(other.routes, routes) &&
        other.parameters == parameters;
  }

  @override
  int get hashCode => hash2(path, _listEquality.hash(routes));

  @override
  String toString() {
    return 'RouteMatch: $routes, $parameters';
  }
}
