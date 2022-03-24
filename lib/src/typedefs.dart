// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO: Delete this library and use WidgetBuilder and TransitionBuilder
import 'package:flutter/widgets.dart';

typedef TreeRouterBuilder = Widget Function(
  BuildContext context,
);

typedef NestedTreeRouterBuilder = Widget Function(
  BuildContext context,
  Widget child,
);
