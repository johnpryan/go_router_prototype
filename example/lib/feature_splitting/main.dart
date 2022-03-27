import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:tree_router/tree_router.dart';

import 'listen_now.dart';
import 'radio.dart';

void main() {
  runApp(FeatureSplittingDemo());
}

class Feature {
  final Route route;
  final AdaptiveScaffoldDestination destination;

  Feature(this.route, this.destination);
}

final List<Feature> features = [
  Feature(ListenNowFeature.route, ListenNowFeature.destination),
  Feature(RadioFeature.route, RadioFeature.destination),
];

class FeatureSplittingDemo extends StatelessWidget {
  FeatureSplittingDemo({Key? key}) : super(key: key);

  final _router = TreeRouter(
    routes: [
      SwitcherRoute(
        path: '/',
        defaultChild: ListenNowFeature.route.path,
        builder: (context, child) => AppScaffold(child: child),
        children: [
          ...features.map((f) => f.route),
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
    return AdaptiveNavigationScaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
      selectedIndex: _selectedIndex(context),
      onDestinationSelected: (index) => _changeIndex(context, index),
      destinations: [
        ...features.map((f) => f.destination),
      ],
    );
  }

  int _selectedIndex(BuildContext context) {
    final activeChild = RouteState.of(context)!.activeChild;
    if (activeChild == null) {
      return 0;
    }
    return features.indexWhere((feature) => feature.route == activeChild);
  }

  void _changeIndex(BuildContext context, int index) {
    RouteState.of(context)!.goTo(features[index].route.path);
  }
}
