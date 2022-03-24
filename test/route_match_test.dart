// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/match.dart';
import 'package:tree_router/src/parameters.dart';
import 'package:tree_router/src/route.dart';

import 'helpers.dart';

void main() {
  group('RouteMatch', () {
    test('currentRoutePath combines the paths for the matched routes', () {
      final match = RouteMatch(
        routes: [
          Route(path: '/', builder: emptyBuilder),
          Route(path: 'a', builder: emptyBuilder),
          Route(path: 'b', builder: emptyBuilder),
        ],
        parameters: Parameters({}, {}),
      );

      expect(match.currentRoutePath, '/a/b');
    });
    test('currentRoutePath includes parameters', () {
      final match = RouteMatch(
        routes: [
          Route(path: '/', builder: emptyBuilder),
          Route(path: 'user/:id', builder: emptyBuilder),
        ],
        parameters: Parameters({'id': '123'}, {}),
      );

      expect(match.currentRoutePath, '/user/123');
    });
  });
}