// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/src/matching.dart';

void main() {
  group('matching helpers', () {
    test('hasMatch', () {
      expect(hasMatch('/user/:id', '/user/1'), true);
      expect(hasMatch('/', '/user/1'), true);
      expect(hasMatch('/user/:id', '/user/1/order/3'), true);
      expect(hasMatch('/user', '/user/1'), true);
      expect(hasMatch('user', 'user/1'), true);
      expect(hasMatch('user/:id', 'user/1'), true);
    });

    test('hasExactMatch', () {
      expect(hasExactMatch('/user/:id', '/user/1'), true);
      expect(hasExactMatch('/', '/user/1'), false);
      expect(hasExactMatch('/user/:id', '/user/1/order/3'), false);
      expect(hasExactMatch('/user', '/user/1'), false);
      expect(hasExactMatch('user', 'user/1'), false);
      expect(hasExactMatch('user/:id', 'user/1'), true);
    });

    test('extractParameters', () {
      expect(extractParameters('/', '/'), {});
      expect(extractParameters('/user/:id', '/user/1'), {'id': '1'});
      expect(extractParameters('/user/:id', '/user'), {});
      expect(extractParameters('/user/:id', '/user/1/order/3'), {'id': '1'});
      expect(extractParameters('/user/:id/order/:orderId', '/user/1/order/3'),
          {'id': '1', 'orderId': '3'});
      expect(extractParameters('user/:id', 'user/1'), {'id': '1'});
    });
  });
}
