// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' hide Route;
import 'package:tree_router/tree_router.dart';

void main() {
  runApp(BottomNavigationBarDemo());
}

class BottomNavigationBarDemo extends StatelessWidget {
  BottomNavigationBarDemo({Key? key}) : super(key: key);

  final _router = GoRouter(
    routes: [
      StackedRoute(
        path: '/',
        builder: (context) => const HomeScreen(),
        routes: [
          ShellRoute(
            path: 'a',
            builder: (context, child) => AScreen(child: child),
            routes: [
              NestedStackRoute(
                path: 'b',
                builder: (context) => const BScreen(),
                routes: [
                  StackedRoute(
                    path: 'c',
                    builder: (context) => const CScreen(),
                  ),
                ],
              ),
            ],
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
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          children: [
            const Text('Home'),
            TextButton(
              onPressed: () {
                RouteState.of(context).goTo('a');
              },
              child: const Text('Go to A'),
            ),
          ],
        ),
      ),
    );
  }
}

class AScreen extends StatelessWidget {
  final Widget child;

  const AScreen({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen A')),
      body: Center(
        child: Column(
          children: [
            const Text('Screen A'),
            TextButton(
              onPressed: () {
                RouteState.of(context).goTo('b');
              },
              child: const Text('Go to B'),
            ),
            Expanded(child: child),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen B'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Screen B'),
            TextButton(
              onPressed: () {
                RouteState.of(context).goTo('c');
              },
              child: const Text('Go to C'),
            ),
          ],
        ),
      ),
    );
  }
}

class CScreen extends StatelessWidget {
  const CScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen C'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Screen B'),
            TextButton(
              onPressed: () {
                RouteState.of(context).goTo('/');
              },
              child: const Text('Go to /'),
            ),
          ],
        ),
      ),
    );
  }
}
