import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:example/feature_splitting/song.dart';
import 'package:flutter/material.dart';
import 'package:tree_router/tree_router.dart';

class RadioFeature extends StatelessWidget {
  static RouteBase route = NestedStackRoute(
    path: 'radio',
    builder: (context) => const RadioFeature(),
    routes: [
      StackedRoute(
        path: 'song/:songId',
        builder: (context) => const SongScreen(),
      ),
    ],
  );

  static const destination = AdaptiveScaffoldDestination(
    title: 'Radio',
    icon: Icons.radio,
  );

  const RadioFeature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Radio',
            style: Theme.of(context).textTheme.headline5,
          ),
          TextButton(
            onPressed: () {
              RouteState.of(context).goTo('song/123');
            },
            child: const Text('View song 123'),
          ),
        ],
      ),
    );
  }
}
