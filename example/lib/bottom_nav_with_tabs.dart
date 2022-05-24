// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' ;
import 'package:tree_router/tree_router.dart';

void main() {
  runApp(BottomNavWithTabsDemo());
}

class BottomNavWithTabsDemo extends StatelessWidget {
  BottomNavWithTabsDemo({Key? key}) : super(key: key);

  final _router = GoRouter(
    routes: [
      ShellRoute(
        path: '/',
        defaultRoute: 'books',
        builder: (context, child) {
          return AppScaffold(child: child);
        },
        routes: [
          ShellRoute(
            path: 'books',
            defaultRoute: 'popular',
            builder: (context, child) {
              return TabScreen(
                selectedIndex: _calculateTabIndex(context),
                child: child,
              );
            },
            routes: [
              StackedRoute(
                path: 'popular',
                builder: (context) {
                  return const PopularScreen();
                },
              ),
              StackedRoute(
                path: 'all',
                builder: (context) {
                  return const AllScreen();
                },
              ),
            ],
          ),
          StackedRoute(
            path: 'settings',
            builder: (context) {
              return const SettingsScreen();
            },
          ),
        ],
      ),
    ],
  );

  static int _calculateTabIndex(BuildContext context) {
    final route = RouteState.of(context);
    final activeChild = route.activeChild;
    if (activeChild != null) {
      if (activeChild.path == 'popular') return 0;
      if (activeChild.path == 'all') return 1;
    }
    return 0;
  }

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
      appBar: AppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
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
      if (activeChild.path == 'books') return 0;
      if (activeChild.path == 'settings') return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        RouteState.of(context).goTo('books');
        break;
      case 1:
        RouteState.of(context).goTo('settings');
        break;
    }
  }
}

class TabScreen extends StatefulWidget {
  final Widget child;
  final int selectedIndex;

  const TabScreen({
    Key? key,
    required this.selectedIndex,
    required this.child,
  }) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.selectedIndex);
  }

  @override
  void didUpdateWidget(TabScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tabController.index = widget.selectedIndex;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelected(int index) {
    late final String path;
    switch (index) {
      case 0:
        path = 'popular';
        break;
      case 1:
        path = 'all';
        break;
    }
    RouteState.of(context).goTo(path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          onTap: _handleTabSelected,
          labelColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(icon: Icon(Icons.lightbulb_outline), text: 'Popular'),
            Tab(icon: Icon(Icons.list), text: 'All'),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: widget.child,
        ),
      ],
    );
  }
}

class AllScreen extends StatelessWidget {
  const AllScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
            child: Text('All', style: Theme.of(context).textTheme.headline4)),
      ],
    );
  }
}

class PopularScreen extends StatelessWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
            child:
                Text('Popular', style: Theme.of(context).textTheme.headline4)),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
            child:
                Text('Settings', style: Theme.of(context).textTheme.headline4)),
      ],
    );
  }
}
