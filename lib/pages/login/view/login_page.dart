// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/pages/login/bloc/login_bloc.dart';
import 'package:perseus_front_mobile/repositories/auth_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LoginBloc(context.read<AuthRepository>(), context.read<AuthBloc>()),
      child: LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarError(context, state.httpException),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.loginAppBarTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                _headerImage(),
                const Spacer(),
                _usernameField(context),
                _passwordField(context),
                _loginButton(context),
                _registerText(context),
                // _passwordForgotten(context),
                _legalMentionsText(context),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerImage() {
    return SizedBox(
      height: 250,
      width: 250,
      child: Image.asset('assets/images/login_lock.png'),
    );
  }

  Widget _usernameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _usernameController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: context.l10n.username,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty || value.length < 4) {
            return context.l10n.validUsernameLogin;
          }
          return null;
        },
        onChanged: (value) {
          // context.read<LoginBloc>().add(LoginUsernameChangedEvent(value));
        },
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: context.l10n.password,
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginLoading) {
          return const CircularProgressIndicator();
        }

        return Padding(
          padding: const EdgeInsets.all(8),
          child: CupertinoButton.filled(
            disabledColor: CupertinoColors.inactiveGray,
            onPressed: () {
              final username = _usernameController.value.text;
              final password = _passwordController.value.text;

              context
                  .read<LoginBloc>()
                  .add(LoginValidateFormEvent(username, password));
            },
            child: Text(context.l10n.loginAppBarTitle),
          ),
        );
      },
    );
  }

  Widget _registerText(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      child: Text(context.l10n.registerCreateAccount),
    );
  }

  // Widget _passwordForgotten(BuildContext context) {
  //   return TextButton(
  //     onPressed: () {},
  //     child: Text(context.l10n.forgotPassword),
  //   );
  // }

  Widget _legalMentionsText(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${context.l10n.legalMentions1} ',
            style: const TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: '${context.l10n.legalMentions2} ',
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(
                  Uri(
                    scheme: 'https',
                    host: 'sites.google.com',
                    path: '/view/perseus-sport/terms-conditions',
                  ),
                );
              },
          ),
          TextSpan(
            text: '${context.l10n.legalMentions3} ',
            style: const TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: context.l10n.legalMentions4,
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(
                  Uri(
                    scheme: 'https',
                    host: 'sites.google.com',
                    path: '/view/perseus-sport/privacy-policy',
                  ),
                );
              },
          ),
          const TextSpan(
            text: '.',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  SnackBar snackBarError(BuildContext context, HttpException httpException) {
    final snackBar = SnackBar(
      backgroundColor: ColorPerseus.blue,
      content: Text(translateErrorMessage(context, httpException)),
      action: SnackBarAction(
        label: context.l10n.close,
        textColor: ColorPerseus.pink,
        onPressed: () {},
      ),
    );

    return snackBar;
  }

  String translateErrorMessage(
    BuildContext context,
    HttpException httpException,
  ) {
    if (httpException is ForbiddenException) {
      return context.l10n.incorrectIdentifiers;
    } else if (httpException is NotFoundException) {
      return context.l10n.incorrectIdentifiers;
    } else if (httpException is CommunicationTimeoutException) {
      return httpException.getTranslatedMessage(context);
    } else if (httpException is InternalServerException) {
      return httpException.getTranslatedMessage(context);
    }

    return context.l10n.unknownException;
  }
}
