// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:quiver/core.dart';

import 'typedefs.dart';

class StackedRoute extends RouteBase {
  final StackedRouteBuilder builder;

  StackedRoute({
    required String path,
    required this.builder,
    Redirect? redirect,
    List<RouteBase> routes = const [],
  }) : super(
          path: path,
          routes: routes,
          redirect: redirect,
        );
}

class ShellRoute extends RouteBase {
  final ShellRouteBuilder builder;
  final String? defaultRoute;

  ShellRoute({
    required String path,
    required this.builder,
    this.defaultRoute,
    Redirect? redirect,
    List<RouteBase> routes = const [],
  }) : super(
          path: path,
          routes: routes,
          redirect: redirect,
        );
}

class NestedStackRoute extends RouteBase {
  final NavigatorRouteBuilder builder;

  NestedStackRoute({
    required String path,
    required this.builder,
    Redirect? redirect,
    List<RouteBase> routes = const [],
  }) : super(
          path: path,
          routes: routes,
          redirect: redirect,
        );
}

abstract class RouteBase {
  static const _listEquality = ListEquality();

  final String path;
  final List<RouteBase> routes;
  final Redirect? redirect;

  const RouteBase({
    required this.path,
    this.routes = const [],
    this.redirect,
  });

  @override
  bool operator ==(Object other) =>
      other is RouteBase &&
      other.path == path &&
      _listEquality.equals(other.routes, routes);

  @override
  int get hashCode => hash2(path, _listEquality.hash(routes));

  @override
  String toString() => 'Route: $path';
}
