// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'match.dart';

typedef StackedRouteBuilder = Widget Function(
  BuildContext context,
);

typedef ShellRouteBuilder = Widget Function(
  BuildContext context,
  Widget child,
);

typedef NavigatorRouteBuilder = Widget Function(
  BuildContext context,
);

typedef Redirect = Future<String?> Function(RouteMatch routeState);
