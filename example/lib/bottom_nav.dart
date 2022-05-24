// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' ;
import 'package:tree_router/tree_router.dart';

void main() {
  runApp(BottomNavigationBarDemo());
}

class BottomNavigationBarDemo extends StatelessWidget {
  BottomNavigationBarDemo({Key? key}) : super(key: key);

  final _router = GoRouter(
    routes: [
      ShellRoute(
        path: '/',
        builder: (context, child) => AppScaffold(child: child),
        // preserveState: true,
        routes: [
          StackedRoute(
            path: 'a',
            builder: (context) => const Screen(
              title: 'Screen A',
              key: ValueKey('A'),
            ),
            routes: [
              StackedRoute(
                path: 'details',
                builder: (context) => const DetailsScreen(label: 'A'),
              ),
            ],
          ),
          NestedStackRoute(
            path: 'b',
            builder: (context) => const Screen(
              title: 'Screen B',
              key: ValueKey('B'),
            ),
            routes: [
              StackedRoute(
                path: 'details',
                builder: (context) => const DetailsScreen(label: 'B'),
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

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'A Screen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'B Screen',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final route = RouteState.of(context);
    final activeChild = route.activeChild;
    if (activeChild != null) {
      if (activeChild.path == 'a') return 0;
      if (activeChild.path == 'b') return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        RouteState.of(context).goTo('a');
        break;
      case 1:
        RouteState.of(context).goTo('b');
        break;
    }
  }
}

class Screen extends StatelessWidget {
  final String title;

  const Screen({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline4,
          ),
          TextButton(
            onPressed: () {
              RouteState.of(context).goTo('details');
            },
            child: const Text('View  details'),
          ),
        ],
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final String label;

  const DetailsScreen({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom Nav'),
      ),
      body: Center(
        child: Text(
          'Details for $label',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
