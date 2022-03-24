// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/route.dart';

import 'package:tree_router/src/tree.dart';

import 'helpers.dart';

void main() {
  group('RouteTree', () {
    test('Looks up routes', () {
      final routes = <Route>[
        Route(
          builder: emptyBuilder,
          path: '/',
        ),
        Route(
          builder: emptyBuilder,
          path: '/item/:id',
        ),
      ];

      final tree = RouteTree(routes);

      var lookup = tree.get('/');
      expect(lookup.routes, [routes.first]);

      lookup = tree.get('/item/1');
      expect(lookup.routes, [routes[1]]);
      expect(lookup.parameters.path, {'id': '1'});
    });

    test('Looks up nested routes', () {
      final routes = [
        Route(
          builder: emptyBuilder,
          path: '/',
          children: [
            Route(
              builder: emptyBuilder,
              path: 'books/:bookId',
            ),
            Route(
              builder: emptyBuilder,
              path: 'profile',
            ),
          ],
        ),
      ];

      final tree = RouteTree(routes);

      var lookup = tree.get('/');
      expect(lookup.routes, isNotEmpty);
      expect(lookup.routes, hasLength(1));

      lookup = tree.get('/books/234');
      expect(lookup.routes, isNotEmpty);
      expect(lookup.routes, hasLength(2));
      expect(lookup.parameters.path['bookId'], '234');

      lookup = tree.get('/profile');
      expect(lookup.routes, isNotEmpty);
      expect(lookup.routes, hasLength(2));
    });
  });
}


class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Placeholder();
}
