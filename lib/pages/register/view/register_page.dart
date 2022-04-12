// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/pages/register/bloc/register_bloc.dart';
import 'package:perseus_front_mobile/repositories/auth_repository.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(context.read<AuthRepository>()),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerAppBarTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              _headerText(),
              const Spacer(),
              _usernameField(),
              _emailField(),
              _passwordField(),
              _registerButton(context),
              _loginText(context),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        initialValue: 'username@mail.com',
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'email',
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

  Widget _registerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 197, 70, 101)),
        ),
        onPressed: () {
          context.read<RegisterBloc>().add(ValidateForm());
        },
        child: const Text('Register'),
      ),
    );
  }

  Widget _loginText(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: const Text('Do you already have an account ?'),
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
}
