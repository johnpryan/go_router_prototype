import 'package:flutter/material.dart';
import 'package:go_router_prototype/go_router_prototype.dart';
import 'package:url_launcher/link.dart';

void main() {
  runApp(LinkWidgetDemo());
}

class LinkWidgetDemo extends StatelessWidget {
  LinkWidgetDemo({Key? key}) : super(key: key);

  final _router = GoRouter(
    routes: [
      StackedRoute(
        path: '/',
        builder: (context) => const HomeScreen(),
        routes: [
          StackedRoute(
            path: 'a',
            builder: (context) => const AScreen(),
            routes: [
              StackedRoute(
                path: 'b',
                builder: (context) => const BScreen(),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('HomeScreen'),
            Link(
              uri: Uri.parse('/a'),
              builder: (context, followLink) {
                return TextButton(
                  child: const Text('Go to A'),
                  onPressed: followLink,
                );
              },
            ),
            // TextButton(onPressed: () {}, child: )
          ],
        ),
      ),
    );
  }
}

class AScreen extends StatelessWidget {
  const AScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Screen A'),
            Link(
              uri: Uri.parse('/a/b'),
              builder: (context, followLink) {
                return TextButton(
                  child: const Text('Go to B'),
                  onPressed: followLink,
                );
              },
            ),
            // TextButton(onPressed: () {}, child: )
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Screen B'),
            Link(
              uri: Uri.parse('/'),
              builder: (context, followLink) {
                return TextButton(
                  child: const Text('Go to /'),
                  onPressed: followLink,
                );
              },
            ),
            // TextButton(onPressed: () {}, child: )
          ],
        ),
      ),
    );
  }
}
