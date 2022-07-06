import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:perseus_front_mobile/common/language/cubit/language_cubit.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/common/widget/gradient_progress_indicator_widget.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/pages/settings/bloc/settings_bloc.dart';
import 'package:perseus_front_mobile/repositories/profile_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SettingsBloc(
            context.read<AuthBloc>(),
            context.read<ProfileRepository>(),
          ),
        ),
        // BlocProvider.value(value: BlocProvider.of<AuthBloc>(context))
      ],
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: ColorPerseus.lightGrey,
        body: _page(context),
      ),
    );
  }

  Widget _page(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoaded) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _categoryContainer(
                  _languageSettings(context, state.langCode),
                  l10n.languages,
                ),
                const Spacer(),
                _accountContainer(
                  _accountSignOut(context),
                  _accountDeleteProfile(context),
                  l10n.account,
                ),
              ],
            ),
          );
        }

        return customLoader(context);
      },
    );
  }

  Widget _categoryContainer(Widget card, String text) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Align(alignment: Alignment.topLeft, child: Text(text)),
        ),
        _cardContainer(
          Column(children: [card]),
        )
      ],
    );
  }

  Widget _accountContainer(
    Widget disconnectCard,
    Widget deleteProfileCard,
    String text,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Align(alignment: Alignment.topLeft, child: Text(text)),
        ),
        _cardContainer(
          Column(
            children: [
              deleteProfileCard,
              const Divider(),
              disconnectCard,
            ],
          ),
        )
      ],
    );
  }

  Widget _cardContainer(Column content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
        child: content,
      ),
    );
  }

  // Row _notificationsActivate() {
  //   return Row(
  //     children: const [
  //       Icon(Icons.notifications_active),
  //       Text('Activate notifications'),
  //       Spacer(),
  //       Switch(value: false, onChanged: null)
  //     ],
  //   );
  // }

  Row _languageSettings(BuildContext context, String langCode) {
    return Row(
      children: [
        const Icon(Icons.language),
        Text(context.l10n.selectLanguage),
        const Spacer(),
        DropdownButton<String>(
          value: langCode,
          icon: const Icon(Icons.arrow_drop_down_sharp),
          onChanged: (String? value) {
            if (value != null) {
              context.read<LanguageCubit>().changeLang(value);
              context
                  .read<SettingsBloc>()
                  .add(SettingsChangeLanguageEvent(value));
            }
          },
          items: <String>['fr', 'en']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Row _accountSignOut(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.logout),
        Text(context.l10n.signOut),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(Logout());
          },
          child: Center(child: Text(context.l10n.disconnect)),
        ),
      ],
    );
  }

  Row _accountDeleteProfile(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.warning),
        Text(context.l10n.delete_account),
        const Spacer(),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ColorPerseus.pink),
          ),
          onPressed: () {
            confirmationDialog(context);
            // context.read<SettingsBloc>().add(SettingsDeleteAccount());
          },
          child: Center(child: Text(context.l10n.delete)),
        ),
      ],
    );
  }

  GradientProgressIndicator customLoader(BuildContext context) {
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

  Future<String?> confirmationDialog(
    BuildContext blocContext,
  ) {
    return showCupertinoDialog<String>(
      context: blocContext,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(context.l10n.confirmation),
          content: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Icon(Icons.warning),
              ),
              Text(
                context.l10n.warning_delete_account,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                context.l10n.no,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(context.l10n.yes),
              onPressed: () {
                Navigator.of(context).pop();
                blocContext.read<SettingsBloc>().add(SettingsDeleteAccount());
              },
            )
          ],
        );
      },
    );
  }
}
