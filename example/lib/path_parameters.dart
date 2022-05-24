// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' ;
import 'package:tree_router/tree_router.dart';

void main() {
  runApp(PathParametersDemo());
}

class PathParametersDemo extends StatelessWidget {
  PathParametersDemo({Key? key}) : super(key: key);

  static String _userId(BuildContext context) {
    final routeState = RouteState.of(context);
    final params = routeState.pathParameters;
    if (!params.containsKey('id')) {
      throw ('Expected :id param in URL');
    }
    return params['id']!;
  }

  final _router = GoRouter(
    routes: [
      StackedRoute(
        path: '/',
        builder: (context) => const HomeScreen(),
        routes: [
          StackedRoute(
            path: 'user/:id',
            builder: (context) {
              return UserScreen(userId: _userId(context));
            },
            routes: [
              StackedRoute(
                path: 'details',
                builder: (context) {
                  return UserDetailsScreen(userId: _userId(context));
                },
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
      appBar: AppBar(
        title: const Text('Basics'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              child: const Text('User 1'),
              onPressed: () {
                RouteState.of(context).goTo('/user/1');
              },
            ),
            TextButton(
              child: const Text('User 2'),
              onPressed: () {
                RouteState.of(context).goTo('/user/2');
              },
            ),
            TextButton(
              child: const Text('User abc'),
              onPressed: () {
                RouteState.of(context).goTo('/user/abc');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserScreen extends StatelessWidget {
  final String userId;

  const UserScreen({
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User $userId'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User $userId',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              onPressed: () {
                RouteState.of(context).goTo('details');
              },
              child: const Text('View details'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  const UserDetailsScreen({
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Details for user $userId',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
