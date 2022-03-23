// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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
}
