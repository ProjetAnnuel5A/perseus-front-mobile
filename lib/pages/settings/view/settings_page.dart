import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
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
        body: Column(
          children: const [Text('Settings')],
        ),
      ),
    );
  }
}
