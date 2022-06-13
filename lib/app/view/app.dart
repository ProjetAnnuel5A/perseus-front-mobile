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
import 'package:perseus_front_mobile/common/theme/app_theme.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/common/widget/gradient_progress_indicator_widget.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/pages/home/view/home_page.dart';
import 'package:perseus_front_mobile/pages/login/view/login_page.dart';
import 'package:perseus_front_mobile/repositories/auth_repository.dart';
import 'package:perseus_front_mobile/repositories/profile_repository.dart';
import 'package:perseus_front_mobile/repositories/set_repository.dart';
import 'package:perseus_front_mobile/repositories/workout_repository.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.appRouter}) : super(key: key);

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      // Provide repositories
      providers: [
        RepositoryProvider.value(value: AuthRepository()),
        RepositoryProvider.value(value: ProfileRepository()),
        RepositoryProvider.value(value: WorkoutRepository()),
        RepositoryProvider.value(value: SetRepository()),
      ],
      child: MaterialApp(
        theme: appThemeData[AppTheme.light],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: appRouter.onGenerateRoute,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthUninitialized) {
              return Scaffold(
                body: GradientProgressIndicator(
                  gradientColors: [
                    Colors.white,
                    ColorPerseus.pink,
                  ],
                  child: const Text(
                    'Application is starting...',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              );
            } else if (state is AuthUnauthenticated) {
              return const LoginPage();
            } else if (state is AuthAuthenticated) {
              return const HomePage();
            }

            // TODO add default SplashScreen
            return const Scaffold();
          },
        ),
      ),
    );
  }
}
