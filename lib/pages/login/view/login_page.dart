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
            children: [
              _usernameField(),
              _passwordField(),
              _loginButton(context)
            ],
          ),
        ),
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
      child: TextButton(
        child: const Text('Validate'),
        onPressed: () {
          context.read<LoginBloc>().add(ValidateForm());
        },
      ),
    );
  }
}
