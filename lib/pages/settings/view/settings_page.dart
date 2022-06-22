import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:perseus_front_mobile/common/language/cubit/language_cubit.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/common/widget/gradient_progress_indicator_widget.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/pages/settings/bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SettingsBloc(),
        ),
        BlocProvider.value(value: BlocProvider.of<AuthBloc>(context))
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
                  _cardContainer(
                    _languageSettings(context, state.langCode),
                  ),
                  l10n.languages,
                ),
                const Spacer(),
                _categoryContainer(
                  _cardContainer(
                    _accountSignOut(context),
                  ),
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
        card,
      ],
    );
  }

  Widget _cardContainer(Widget content) {
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
}
