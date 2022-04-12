// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:perseus_front_mobile/app_router.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/pages/counter/counter.dart';
import 'package:perseus_front_mobile/pages/login/view/login_page.dart';
import 'package:perseus_front_mobile/repositories/auth_repository.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.appRouter}) : super(key: key);

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      // Provide repositories
      providers: [RepositoryProvider.value(value: AuthRepository())],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme:
              const AppBarTheme(color: Color.fromARGB(255, 45, 53, 137)),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color.fromARGB(255, 197, 70, 101),
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: appRouter.onGenerateRoute,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthUninitialized) {
              return const Scaffold(body: CircularProgressIndicator());
            } else if (state is AuthUnauthenticated) {
              return const LoginPage();
            } else if (state is AuthAuthenticated) {
              return const CounterPage();
            }

            // TODO add default SplashScreen
            return const Scaffold();
          },
        ),
      ),
    );
  }
}
