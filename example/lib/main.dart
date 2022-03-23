// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' hide Route;
import 'package:tree_router/tree_router.dart';

void main() {
  runApp(TreeRouterDemo());
}

class TreeRouterDemo extends StatelessWidget {
  TreeRouterDemo({Key? key}) : super(key: key);

  final _router = TreeRouter(
    routes: [
      Route(
        path: '/a',
        builder: (context, state) => const Screen(
          name: 'Screen A',
          linkTo: '/b',
        ),
        children: [
          Route(
            path: '/b',
            builder: (context, state) => const Screen(
              name: 'Screen B',
              linkTo: '/c',
            ),
          ),
        ],
      ),
      Route(
        path: '/c',
        builder: (context, state) => const Screen(
          name: 'Screen C',
          linkTo: '/a',
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _router.delegate,
      routeInformationParser: _router.parser,
    );
  }
}

class Screen extends StatelessWidget {
  final String name;
  final String linkTo;

  const Screen({
    required this.name,
    required this.linkTo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              child: Text('Go to $linkTo'),
              onPressed: () {
                // todo TreeRouter.of(context).goTo()
              },
            ),
          ],
        ),
      ),
    );
  }
}
