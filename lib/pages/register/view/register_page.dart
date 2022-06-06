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
      child: RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  RegisterView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerAppBarTitle)),
      body: BlocProvider(
        create: (context) => RegisterBloc(context.read<AuthRepository>()),
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pop(context);
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Spacer(),
                  _headerText(),
                  const Spacer(),
                  Form(
                    key: _formKey,
                    onChanged: () {},
                    child: Column(
                      children: [
                        _usernameField(),
                        _emailField(),
                        _passwordField(),
                        _confirmationField(),
                      ],
                    ),
                  ),
                  _registerButton(context),
                  _loginText(context),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _emailController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
          final regex = RegExp(pattern);

          if (value == null || !regex.hasMatch(value)) {
            return 'Please enter a valid Email';
          }
          return null;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
        ),
      ),
    );
  }

  Widget _usernameField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _usernameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              value.length < 6 ||
              value.length > 30) {
            return 'Please enter a valid Username'
                '\n- must not exist'
                '\n- must have more than 5 characters and less than 29 characters';
          }
          return null;
        },
        // @Size(min = 6, max = 30) + unique
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Username',
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          const pattern =
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
          final regex = RegExp(pattern);

          if (value == null || value.isEmpty || !regex.hasMatch(value)) {
            return 'Please enter a valid Password'
                '\n- must have more than 8 characters or more and contains both digits and letters';
          }
          return null;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
        ),
      ),
    );
  }

  Widget _confirmationField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _confirmationController,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null ||
              _passwordController.value.text !=
                  _confirmationController.value.text) {
            return 'Please confirm your password';
          }
          return null;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Confirmation',
        ),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        if (state is RegisterLoading) {
          return const CircularProgressIndicator();
        }

        return Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () {
              final username = _usernameController.value.text;
              final email = _emailController.value.text;
              final password = _passwordController.value.text;

              context.read<RegisterBloc>().add(
                    RegisterValidateFormEvent(username, email, password),
                  );
            },
            child: const Text('Register'),
          ),
        );
      },
    );
  }

  Widget _loginText(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
