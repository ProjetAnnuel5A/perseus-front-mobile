// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/pages/login/bloc/login_bloc.dart';
import 'package:perseus_front_mobile/repositories/auth_repository.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginAppBarTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _headerText(),
              const Spacer(),
              _usernameField(context),
              _passwordField(),
              _loginButton(context),
              _registerText(context),
              _passwordForgotten(context),
              _legalMentionsText(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerText() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Get started in a couple of minutes !',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget _usernameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _usernameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Username',
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty || value.length < 4) {
            return 'Please enter a valid Username'
                '\n- must have more than 4 characters';
          }
          return null;
        },
        onChanged: (value) {
          context.read<LoginBloc>().add(LoginUsernameChangedEvent(value));
        },
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        obscureText: true,
        controller: _passwordController,
        enableSuggestions: false,
        autocorrect: false,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          final username = _usernameController.value.text;
          final password = _passwordController.value.text;

          context
              .read<LoginBloc>()
              .add(LoginValidateFormEvent(username, password));
        },
        child: const Text('Login'),
      ),
    );
  }

  Widget _registerText(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      child: const Text('Register and create an account'),
    );
  }

  Widget _passwordForgotten(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text('Forgot your password ?'),
    );
  }

  Widget _legalMentionsText() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'By continuing, you agree to the Terms, Conditions and Privacy Policy.',
      ),
    );
  }
}
