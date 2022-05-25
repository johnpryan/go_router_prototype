import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/tree_router.dart';

import 'helpers.dart';

void main() {
  group('Redirect', () {
    testWidgets('redirects to a relative path at startup',
        (WidgetTester tester) async {
      final routes = <RouteBase>[
        ShellRoute(
          path: '/',
          redirect: (match) {
            return SynchronousFuture('a');
          },
          builder: (_, child) => child,
          routes: [
            StackedRoute(
              path: 'a',
              builder: (context) {
                return const AScreen();
              },
            ),
          ],
        ),
      ];
      await tester.pumpWidget(
        TestWidget(
          routes: routes,
          initialRoute: '/',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Screen A'), findsOneWidget);
    });

    testWidgets('Redirects multiple times', (WidgetTester tester) async {
      final routes = <RouteBase>[
        ShellRoute(
          path: '/',
          redirect: (match) {
            return SynchronousFuture('a');
          },
          builder: (_, child) => child,
          routes: [
            StackedRoute(
              path: 'a',
              redirect: (match) {
                return SynchronousFuture('b');
              },
              builder: (context) {
                return const AScreen();
              },
              routes: [
                StackedRoute(
                  path: 'b',
                  builder: (context) {
                    return const BScreen();
                  },
                ),
              ],
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        TestWidget(
          routes: routes,
          initialRoute: '/',
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Screen B'), findsOneWidget);
    });

    testWidgets('Avoids infinite redirects', (WidgetTester tester) async {
      final routes = <RouteBase>[
        ShellRoute(
          path: '/',
          redirect: (match) {
            return SynchronousFuture('/a');
          },
          builder: (_, child) => child,
          routes: [
            StackedRoute(
              path: 'a',
              redirect: (match) {
                return SynchronousFuture('/b');
              },
              builder: (context) {
                return const AScreen();
              },
            ),
            StackedRoute(
              path: 'b',
              redirect: (match) {
                return SynchronousFuture('/a');
              },
              builder: (context) {
                return const BScreen();
              },
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        TestWidget(
          routes: routes,
          initialRoute: '/',
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Screen B'), findsOneWidget);
    }, skip: true);
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Home');
  }
}

class AScreen extends StatelessWidget {
  const AScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Screen A');
  }
}

class BScreen extends StatelessWidget {
  const BScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Screen B');
  }
}
