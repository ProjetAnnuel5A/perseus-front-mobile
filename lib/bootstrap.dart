// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await dotenv.load();

  await runZonedGuarded(
    () async {
      await SentryFlutter.init(
        (options) {
          options.dsn =
              'https://f656efd95372491f8761f1827232fa0a@o1278976.ingest.sentry.io/6479094';
        },
      );

      await BlocOverrides.runZoned(
        () async => runApp(
          BlocProvider<AuthBloc>(
            create: (context) {
              return AuthBloc()..add(AppStarted());
            },
            child: await builder(),
          ),
        ),
        // runApp(await builder()),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) async {
      await Sentry.captureException(error, stackTrace: stackTrace);
      log(error.toString(), stackTrace: stackTrace);
    },
  );
}
