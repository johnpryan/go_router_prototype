// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/route.dart';

import 'package:tree_router/src/tree.dart';

void main() {
  group('RouteTree', () {
    test('Looks up routes', () {
      final routes = <Route>[
        const Route(
          builder: _emptyBuilder,
          path: '/',
        ),
        const Route(
          builder: _emptyBuilder,
          path: '/item/:id',
        ),
      ];

      final tree = RouteTree(routes);

      var lookup = tree.get('/');
      expect(lookup, routes.first);

      lookup = tree.get('/item/1');
      expect(lookup, routes[1]);
    });

    test('Looks up nested routes', () {
      final routes = [
        const Route(
          builder: _emptyBuilder,
          path: '/',
          children: [
            Route(
              builder: _emptyBuilder,
              path: 'books',
            ),
            Route(
              builder: _emptyBuilder,
              path: 'profile',
            ),
          ],
        ),
      ];

      final tree = RouteTree(routes);

      var lookup = tree.get('/');
      expect(lookup, isNotNull);

      lookup = tree.get('/books');
      expect(lookup, isNotNull);

      lookup = tree.get('/profile');
      expect(lookup, isNotNull);
    });
  });
}

Widget _emptyBuilder(context, state) => const EmptyWidget();

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Placeholder();
}
