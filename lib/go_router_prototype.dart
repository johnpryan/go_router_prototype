// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library tree_router;

import 'package:flutter/foundation.dart';

import 'src/delegate.dart';
import 'src/parser.dart';
import 'src/route.dart';

export 'src/route.dart';
export 'src/state.dart';
export 'src/typedefs.dart';

class GoRouter {
  final GoRouterDelegate delegate;
  final GoRouteInformationParser parser;

  GoRouter({
    required List<RouteBase> routes,
    Listenable? refreshListenable,
  })  : delegate =
            GoRouterDelegate(routes, refreshListenable: refreshListenable),
        parser = GoRouteInformationParser();
}
