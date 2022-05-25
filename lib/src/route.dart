// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:quiver/core.dart';

import 'typedefs.dart';

/// A route that is displayed visually above the matching parent route using the
/// [Navigator].
///
/// The widget returned by [builder] is wrapped in [Page]and provided to the
/// root Navigator or the Navigator belonging to the nearest [NestedStackRoute]
/// ancestor. The page will be either a [MaterialPage] or [CupertinoPage] depending
/// on the application type.
///
/// This route has the same behavior as GoRoute in go_router >=3.0.0.
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

/// A route that displays a UI shell around the matching child route.
///
/// The widget built by the matching child route becomes to the child parameter
/// of the [builder].
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

/// A route that displays descendent [StackedRoute]s within its visual boundary.
///
/// This route places a nested [Navigator] in the widget tree, where any
/// descendent [StackedRoute]s are placed onto this
/// Navigator instead of the root Navigator, which allows you to display a UI
/// shell around a nested stack of routes if this route is a child route of
/// [ShellRoute].
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
