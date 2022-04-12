// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:perseus_front_mobile/app/app.dart';
import 'package:perseus_front_mobile/app_router.dart';
import 'package:perseus_front_mobile/pages/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(App(appRouter: AppRouter()));
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
