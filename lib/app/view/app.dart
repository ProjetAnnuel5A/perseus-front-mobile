import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:perseus_front_mobile/app_router.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:perseus_front_mobile/common/language/cubit/language_cubit.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiRepositoryProvider(
      // Provide repositories
      providers: [
        RepositoryProvider.value(value: AuthRepository()),
        RepositoryProvider.value(value: ProfileRepository()),
        RepositoryProvider.value(value: WorkoutRepository()),
        RepositoryProvider.value(value: SetRepository()),
      ],
      child: BlocProvider(
        create: (context) => LanguageCubit(),
        child: BlocBuilder<LanguageCubit, Locale>(
          builder: (context, lang) {
            context.read<LanguageCubit>().getStartingLanguage();

            return MaterialApp(
              theme: appThemeData[AppTheme.light],
              debugShowCheckedModeBanner: false,
              locale: lang,
              title: 'Perseus',
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('fr'),
                Locale('en'),
              ],
              onGenerateRoute: appRouter.onGenerateRoute,
              home: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthUninitialized) {
                    return Scaffold(body: customLoader(context));
                  } else if (state is AuthUnauthenticated) {
                    return const LoginPage();
                  } else if (state is AuthAuthenticated) {
                    return const HomePage();
                  }

                  return customLoader(context);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget customLoader(BuildContext context) {
    return GradientProgressIndicator(
      gradientColors: [
        Colors.white,
        ColorPerseus.pink,
      ],
      child: Text(
        '${context.l10n.loading}...',
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }
}
