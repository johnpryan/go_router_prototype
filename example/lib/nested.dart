// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' hide Route;
import 'package:tree_router/tree_router.dart';

void main() {
  runApp(NestingDemo());
}

class NestingDemo extends StatelessWidget {
  NestingDemo({Key? key}) : super(key: key);

  final _router = TreeRouter(
    routes: [
      SwitcherRoute(
        path: '/a',
        builder: (context, child) => HomeScreen(child: child),
        children: [
          StackedRoute(
            path: '/b',
            builder: (context) => const BScreen(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _router.delegate,
      routeInformationParser: _router.parser,
      routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: const RouteInformation(location: '/a')),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Widget child;

  const HomeScreen({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              child: const Text('Go to /b'),
              onPressed: () {
                RouteState.of(context)!.goTo('/b');
              },
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class BScreen extends StatelessWidget {
  const BScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Screen B');
  }
}

