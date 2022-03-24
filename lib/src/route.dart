// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:quiver/core.dart';

import 'redirect.dart';
import 'typedefs.dart';

enum RouteType {
  stacked,
  nested,
  nestedNavigator,
}

class Route {
  final String path;
  final TreeRouterBuilder? builder;
  final NestedTreeRouterBuilder? nestedBuilder;
  final List<Route> children;
  final RouteType type;
  final Redirect? redirect;

  static const _listEquality = ListEquality();

  const Route({
    required this.path,
    this.builder,
    this.nestedBuilder,
    this.children = const [],
    this.type = RouteType.stacked,
    this.redirect,
  })  :
        // Exactly one builder should be provided
        assert((builder == null) != (nestedBuilder == null)),
        // The builder should match the route type
        assert(type == RouteType.stacked && builder != null ||
            type == RouteType.nested && nestedBuilder != null ||
            type == RouteType.nestedNavigator && builder != null);

  @override
  bool operator ==(Object other) =>
      other is Route &&
      other.path == path &&
      _listEquality.equals(other.children, children);

  @override
  int get hashCode => hash2(path, _listEquality.hash(children));

  @override
  String toString() => 'Route: $path';
}
