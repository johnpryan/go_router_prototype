// Copyright 2022 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:tree_router/tree_router.dart' hide Route;

void main() {
  runApp(const CupertinoTabBarDemo());
}

class _TabInfo {
  const _TabInfo(this.title, this.icon);

  final String title;
  final IconData icon;
}

final _router = TreeRouter(
  routes: [
    ShellRoute(
      path: '/',
      defaultRoute: 'home',
      builder: (context, child) => AppScaffold(
        selectedIndex: _selectedIndex(context),
        child: child,
      ),
      routes: [
        NavigatorRoute(
          path: 'home',
          builder: (context) => const HomeScreen(),
          routes: [
            StackedRoute(
              path: 'details',
              builder: (context) => const DetailsScreen(),
            ),
          ],
        ),
        NavigatorRoute(
          path: 'chat',
          builder: (context) => const ChatScreen(),
          routes: [
            StackedRoute(
              path: 'details',
              builder: (context) => const DetailsScreen(),
            ),
          ],
        ),
        NavigatorRoute(
          path: 'profile',
          builder: (context) => const ProfileScreen(),
          routes: [
            StackedRoute(
              path: 'details',
              builder: (context) => const DetailsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

int _selectedIndex(BuildContext context) {
  final route = RouteState.of(context)!;
  final activeChild = route.activeChild;
  if (activeChild != null) {
    if (activeChild.path == 'home') return 0;
    if (activeChild.path == 'chat') return 1;
    if (activeChild.path == 'profile') return 1;
  }
  return 0;
}

class CupertinoTabBarDemo extends StatelessWidget {
  const CupertinoTabBarDemo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routeInformationParser: _router.parser,
      routerDelegate: _router.delegate,
    );
  }
}

class AppScaffold extends StatelessWidget {
  final int selectedIndex;
  final Widget child;
  static const _tabScaffoldKey = ValueKey('tab_scaffold');
  static const _switcherKey = ValueKey('switcher');
  static const _tabBarKey = ValueKey('tab_bar');

  const AppScaffold({
    required this.selectedIndex,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tabInfo = [
      const _TabInfo(
        'Home',
        CupertinoIcons.home,
      ),
      const _TabInfo(
        'Chat',
        CupertinoIcons.conversation_bubble,
      ),
      const _TabInfo(
        'Profile',
        CupertinoIcons.profile_circled,
      ),
    ];

    return CupertinoTabScaffold(
      restorationId: 'cupertino_tab_scaffold',
      key: _tabScaffoldKey,
      tabBar: CupertinoTabBar(
        key: _tabBarKey,
        currentIndex: selectedIndex,
        onTap: (idx) => _onItemTapped(idx, context),
        items: [
          for (final tabInfo in _tabInfo)
            BottomNavigationBarItem(
              label: tabInfo.title,
              icon: Icon(tabInfo.icon),
            ),
        ],
      ),
      tabBuilder: (context, index) {
        return AnimatedSwitcher(
          key: _switcherKey,
          duration: const Duration(milliseconds: 600),
          child: child,
        );
      },
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        RouteState.of(context)!.goTo('home');
        break;
      case 1:
        RouteState.of(context)!.goTo('chat');
        break;
      case 2:
        RouteState.of(context)!.goTo('profile');
        break;
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      backgroundColor: CupertinoColors.systemBackground,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.home,
              semanticLabel: 'Home',
              size: 100,
            ),
            CupertinoButton(
              onPressed: () {
                RouteState.of(context)!.goTo('details');
              },
              child: const Text('Show a new screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      backgroundColor: CupertinoColors.systemBackground,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.conversation_bubble,
              semanticLabel: 'Chat',
              size: 100,
            ),
            CupertinoButton(
              onPressed: () {
                RouteState.of(context)!.goTo('details');
              },
              child: const Text('Show a new screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      backgroundColor: CupertinoColors.systemBackground,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.profile_circled,
              semanticLabel: 'Profile',
              size: 100,
            ),
            CupertinoButton(
              onPressed: () {
                RouteState.of(context)!.goTo('details');
              },
              child: const Text('Show a new screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  final String? restorationId;
  final int? id;

  const DetailsScreen({
    this.restorationId,
    this.id,
    Key? key,
  }) : super(key: key);

  static String show(NavigatorState navigator, int id) {
    return navigator.restorablePush<void>(_routeBuilder, arguments: id);
  }

  static Route<void> _routeBuilder(BuildContext context, Object? arguments) {
    final id = arguments as int?;
    return CupertinoPageRoute(
      builder: (context) => DetailsScreen(id: id, restorationId: 'details'),
    );
  }

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with RestorationMixin {
  final RestorableInt _selectedViewIndex = RestorableInt(0);

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedViewIndex, 'tab');
  }

  @override
  void dispose() {
    _selectedViewIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UnmanagedRestorationScope(
      bucket: bucket,
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(),
        child: Center(
          child: Text(
            'Item ${widget.id}',
            style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
          ),
        ),
      ),
    );
  }
}

/// Partially overlays and then blurs its child's background.
class FrostedBox extends StatelessWidget {
  const FrostedBox({
    this.child,
    Key? key,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xccf8f8f8),
        ),
        child: child,
      ),
    );
  }
}

/// A simple "close this modal" button that invokes a callback when pressed.
class CloseButton extends StatefulWidget {
  const CloseButton(this.onPressed, {Key? key}) : super(key: key);

  final VoidCallback onPressed;

  @override
  CloseButtonState createState() {
    return CloseButtonState();
  }
}

class CloseButtonState extends State<CloseButton> {
  bool tapInProgress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() => tapInProgress = true);
      },
      onTapUp: (details) {
        setState(() => tapInProgress = false);
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => tapInProgress = false);
      },
      child: ClipOval(
        child: FrostedBox(
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: ColorChangingIcon(
                CupertinoIcons.clear_thick,
                duration: const Duration(milliseconds: 300),
                color: tapInProgress
                    ? const Color(0xff101010)
                    : const Color(0xff808080),
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorChangingIcon extends ImplicitlyAnimatedWidget {
  const ColorChangingIcon(
    this.icon, {
    this.color = CupertinoColors.black,
    this.size,
    required Duration duration,
    Key? key,
  }) : super(key: key, duration: duration);

  final Color color;

  final IconData icon;

  final double? size;

  @override
  _ColorChangingIconState createState() => _ColorChangingIconState();
}

class _ColorChangingIconState
    extends AnimatedWidgetBaseState<ColorChangingIcon> {
  ColorTween? _colorTween;

  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      semanticLabel: 'Close button',
      size: widget.size,
      color: _colorTween?.evaluate(animation),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _colorTween = visitor(
      _colorTween,
      widget.color,
      (dynamic value) => ColorTween(begin: value as Color?),
    ) as ColorTween?;
  }
}
