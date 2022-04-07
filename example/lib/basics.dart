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
      StackedRoute(
        path: '/',
        builder: (context) => const AScreen(),
        routes: [
          StackedRoute(
            path: 'b',
            builder: (context) => const BScreen(),
          ),
        ],
      ),
      StackedRoute(
        path: '/c',
        builder: (context) => const CScreen(),
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

class AScreen extends Screen {
  const AScreen({Key? key})
      : super(
          key: key,
          name: 'Screen A',
          linkTo: 'b',
        );
}

class BScreen extends Screen {
  const BScreen({Key? key})
      : super(
          key: key,
          name: 'Screen B',
          linkTo: '/c',
        );
}

class CScreen extends Screen {
  const CScreen({Key? key})
      : super(
          key: key,
          name: 'Screen C',
          linkTo: '/a',
        );
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
      appBar: AppBar(
        title: const Text('Basics'),
      ),
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
                RouteState.of(context)!.goTo(linkTo);
              },
            ),
          ],
        ),
      ),
    );
  }
}
