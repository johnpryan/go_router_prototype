import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:tree_router/tree_router.dart';

import 'helpers.dart';

void main() {
  group('Redirect', () {
    testWidgets('redirects to a relative path at startup',
        (WidgetTester tester) async {
      final routes = <Route>[
        SwitcherRoute(
          path: '/',
          builder: (_, child) => child,
          redirect: (match) {
            return SynchronousFuture('a');
          },
          children: [
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
