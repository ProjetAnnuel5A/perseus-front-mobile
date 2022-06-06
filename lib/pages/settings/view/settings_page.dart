import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AuthBloc>(context),
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
        appBar: AppBar(title: const Text('Settings')),
        backgroundColor: ColorPerseus.lightGrey,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _categoryContainer(
                _cardContainer(Column(
                  children: [
                    _notificationsActivate(),
                    _notificationsActivate(),
                    _notificationsActivate(),
                  ],
                )),
                'Notifications',
              ),

              const Spacer(),
              _categoryContainer(
                _cardContainer(
                  _accountSignOut(context),
                ),
                'Account',
              ),
            ],
          ),
        ),
      ),
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

  Row _notificationsActivate() {
    return Row(
      children: const [
        Icon(Icons.notifications_active),
        Text('Activate notifications'),
        Spacer(),
        Switch(value: false, onChanged: null)
      ],
    );
  }

  Row _accountSignOut(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.logout),
        const Text('Sign out'),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(Logout());
          },
          child: const Center(child: Text('Disconnect')),
        ),
      ],
    );
  }
}
