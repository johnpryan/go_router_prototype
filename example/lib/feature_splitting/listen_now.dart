import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:tree_router/tree_router.dart';

import 'song.dart';

class ListenNowFeature extends StatelessWidget {
  static RouteBase route = StackedRoute(
    path: 'listen-now',
    builder: (context) => const ListenNowFeature(),
    routes: [
      StackedRoute(
        path: 'song/:songId',
        builder: (context) => const SongScreen(),
      ),
    ],
  );

  static const destination = AdaptiveScaffoldDestination(
    title: 'Listen now',
    icon: Icons.play_arrow,
  );

  const ListenNowFeature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Listen Now',
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
