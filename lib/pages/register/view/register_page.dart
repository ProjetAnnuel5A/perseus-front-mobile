// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
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
            } else if (state is RegisterError) {
              final snackBar = SnackBar(
                backgroundColor: ColorPerseus.blue,
                content: Text(state.message),
                action: SnackBarAction(
                  label: context.l10n.close,
                  textColor: ColorPerseus.pink,
                  onPressed: () {},
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Spacer(),
                  _headerImage(),
                  const Spacer(),
                  Form(
                    key: _formKey,
                    onChanged: () {},
                    child: Column(
                      children: [
                        _usernameField(context),
                        _emailField(context),
                        _passwordField(context),
                        _confirmationField(context),
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

  Widget _emailField(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _emailController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
          final regex = RegExp(pattern);

          if (value == null || !regex.hasMatch(value)) {
            return l10n.validEmail;
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.email,
        ),
      ),
    );
  }

  Widget _usernameField(BuildContext context) {
    final l10n = context.l10n;

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
            return l10n.validUsername;
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.username,
        ),
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    final l10n = context.l10n;

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
            return l10n.validPassword;
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.password,
        ),
      ),
    );
  }

  Widget _confirmationField(BuildContext context) {
    final l10n = context.l10n;

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
            return l10n.confirmPassword;
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.confirmation,
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
          child: CupertinoButton.filled(
            disabledColor: CupertinoColors.inactiveGray,
            onPressed: () {
              final username = _usernameController.value.text;
              final email = _emailController.value.text;
              final password = _passwordController.value.text;

              context.read<RegisterBloc>().add(
                    RegisterValidateFormEvent(username, email, password),
                  );
            },
            child: Text(context.l10n.register),
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
      child: Text(context.l10n.alreayHaveAccount),
    );
  }

  Widget _headerImage() {
    return Image.asset('assets/images/register.png');
  }
}
