// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router_prototype/src/matching.dart';
import 'package:go_router_prototype/src/parameters.dart';

void main() {
  group('Matching helpers', () {
    test('hasMatch', () {
      expect(hasMatch('/user/:id', '/user/1'), true);
      expect(hasMatch('/', '/user/1'), true);
      expect(hasMatch('/user/:id', '/user/1/order/3'), true);
      expect(hasMatch('/user', '/user/1'), true);
      expect(hasMatch('user', 'user/1'), true);
      expect(hasMatch('user/:id', 'user/1'), true);
      expect(hasMatch('/user/:id', '/user/1/suffix'), true);
    });

    test('hasExactMatch', () {
      expect(hasExactMatch('/user/:id', '/user/1'), true);
      expect(hasExactMatch('/', '/user/1'), false);
      expect(hasExactMatch('/user/:id', '/user/1/order/3'), false);
      expect(hasExactMatch('/user', '/user/1'), false);
      expect(hasExactMatch('user', 'user/1'), false);
      expect(hasExactMatch('user/:id', 'user/1'), true);
      expect(
          hasExactMatch('Left Hand of Darkness',
              Uri.decodeComponent('Left%20Hand%20of%20Darkness')),
          true);
      expect(hasExactMatch('/', '/?q=foo'), true);
    });

    test('extractParameters', () {
      expect(extractParameters('/', '/'), Parameters({}, {}));
      expect(extractParameters('/user/:id', '/user/1'),
          Parameters({'id': '1'}, {}));
      expect(extractParameters('/user/:id', '/user'), Parameters({}, {}));
      expect(extractParameters('/user/:id', '/user/1/order/3'),
          Parameters({'id': '1'}, {}));
      expect(extractParameters('/user/:id/order/:orderId', '/user/1/order/3'),
          Parameters({'id': '1', 'orderId': '3'}, {}));
      expect(
          extractParameters('user/:id', 'user/1'), Parameters({'id': '1'}, {}));
    });

    test('fillParameters', () {
      expect(
          fillParameters('/user/:id', Parameters({'id': '1'}, {})), '/user/1');
      expect(fillParameters('/search', Parameters({}, {'q': 'dog'})),
          '/search?q=dog');
      expect(fillParameters('/foo.txt', Parameters({}, {})), '/foo.txt');
    });

    test('parseParameterNames', () {
      expect(parseParameterNames('user/:id'), ['id']);
    });
  });
}
