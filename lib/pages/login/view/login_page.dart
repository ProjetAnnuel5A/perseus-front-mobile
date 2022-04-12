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
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

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
              _usernameField(),
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

  Widget _usernameField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        initialValue: 'username',
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'username',
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        initialValue: 'azerA123+',
        obscureText: true,
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
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 197, 70, 101)),
        ),
        onPressed: () {
          context.read<LoginBloc>().add(ValidateForm());
        },
        child: const Text('Login'),
      ),
    );
  }

  Widget _registerText(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/register');
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
