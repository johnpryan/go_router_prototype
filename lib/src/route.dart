// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:quiver/core.dart';

import 'redirect.dart';
import 'typedefs.dart';

enum RouteType {
  stacked,
  nested,
}

class Route {
  final String path;
  final TreeRouterBuilder builder;
  final List<Route> children;
  final RouteType type;
  final Redirect? redirect;

  const Route({
    required this.path,
    required this.builder,
    this.children = const [],
    this.type = RouteType.stacked,
    this.redirect,
  });

  @override
  bool operator ==(Object other) =>
      other is Route &&
      other.path == path &&
      other.builder == builder &&
      other.type == type &&
      other.children == children &&
      other.redirect == redirect;

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() => 'Route: $path';
}
