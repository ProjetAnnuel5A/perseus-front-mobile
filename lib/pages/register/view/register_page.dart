import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(l10n.registerAppBarTitle)),
      body: BlocProvider(
        create: (context) => RegisterBloc(context.read<AuthRepository>()),
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pop(context);
            } else if (state is RegisterError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBarError(context, state.httpException));
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _headerImage(),
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
                  const SizedBox(height: 30),
                  _registerButton(context),
                  _loginText(context),
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
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
          final regex = RegExp(pattern);

          if (value == null || !regex.hasMatch(value)) {
            return l10n.validEmail;
          }
          return null;
        },
        decoration: InputDecoration(
          errorMaxLines: 3,
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
        textInputAction: TextInputAction.next,
        autocorrect: false,
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
          errorMaxLines: 6,
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
        textInputAction: TextInputAction.next,
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
          errorMaxLines: 6,
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
          errorMaxLines: 3,
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
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(8),
          child: CupertinoButton.filled(
            disabledColor: CupertinoColors.inactiveGray,
            onPressed: () {
              final username = _usernameController.value.text;
              final email = _emailController.value.text;
              final password = _passwordController.value.text;
              final confirmation = _confirmationController.value.text;

              if (username.isNotEmpty &&
                  email.isNotEmpty &&
                  password.isNotEmpty &&
                  confirmation.isNotEmpty &&
                  password.length > 7 &&
                  password == confirmation) {
                context.read<RegisterBloc>().add(
                      RegisterValidateFormEvent(username, email, password),
                    );
              } else {
                // dialog
              }
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
    return SizedBox(
      height: 250,
      width: 250,
      child: Image.asset('assets/images/register.png'),
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
    } else if (httpException is ConflictException) {
      return context.l10n.emailOrPseudoAlreadyExist;
    } else if (httpException is CommunicationTimeoutException) {
      return httpException.getTranslatedMessage(context);
    }

    return context.l10n.unknownException;
  }
}
