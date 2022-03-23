// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/route.dart';

import 'package:tree_router/src/tree.dart';

void main() {
  group('RouteTree', () {
    test('constructor', () {
      final routes = <Route>[];
      final tree = RouteTree(routes);
    });
  });
}
