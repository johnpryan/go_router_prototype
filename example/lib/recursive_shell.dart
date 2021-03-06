// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router_prototype/go_router_prototype.dart';

void main() {
  runApp(ShellDemo());
}

Map<String, dynamic> routeMap = {
  'Desktop': {
    'file1.txt': {},
    'file2.txt': {},
    'file3.txt': {},
  },
  'Documents': {
    'Books': {
      'Left Hand of Darkness': {},
      'Kindred': {},
    },
    'Movies': {
      'Batman Begins': {},
      'The Dark Knight': {},
      'The Dark Knight Rises': {},
    },
    'Music': {
      'Playlists': {
        '2022': {},
        '2021': {},
        '2020': {},
        '2019': {},
      },
      'Artists': {},
      'Songs': {},
    },
    'Pictures': {},
  },
};

List<RouteBase> _buildRoutesRecursive(Map routeMap) {
  final children = <ShellRoute>[];
  for (var key in routeMap.keys) {
    final childMap = routeMap[key] as Map;
    children.add(
      ShellRoute(
        path: key,
        builder: (context, child) {
          return RouteList(
            child: child,
            childPaths: [...childMap.keys],
          );
        },
        routes: _buildRoutesRecursive(childMap),
      ),
    );
  }
  return children;
}

class ShellDemo extends StatelessWidget {
  ShellDemo({Key? key}) : super(key: key);

  final _router = GoRouter(
    routes: [
      ShellRoute(
        path: '/',
        builder: (context, child) {
          return AppScaffold(
            childPaths: [...routeMap.keys],
            child: child,
          );
        },
        routes: _buildRoutesRecursive(routeMap),
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

class AppScaffold extends StatefulWidget {
  final Widget child;
  final List<String> childPaths;

  const AppScaffold({required this.childPaths, required this.child, Key? key})
      : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          controller: _scrollController,
          child: LayoutBuilder(
            builder: (context, viewportConstraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: RouteList(
                  childPaths: widget.childPaths,
                  child: widget.child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class RouteList extends StatelessWidget {
  final Widget child;
  final List<String> childPaths;

  const RouteList({required this.child, required this.childPaths, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1, color: Colors.grey[400]!),
            ),
          ),
          constraints: const BoxConstraints.tightFor(width: 256),
          child: RouteSelector(
            childPaths: childPaths,
          ),
        ),
        child,
      ],
    );
  }
}

class RouteSelector extends StatelessWidget {
  final List<String> childPaths;

  const RouteSelector({required this.childPaths, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...childPaths.map(
          (p) => ListTile(
            onTap: () {
              RouteState.of(context).goTo(p);
            },
            selected: RouteState.of(context).activeChild?.path == p,
            title: Text(p),
          ),
        ),
      ],
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
