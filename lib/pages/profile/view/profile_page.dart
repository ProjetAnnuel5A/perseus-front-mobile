import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 120,
                backgroundImage: AssetImage('assets/images/runner.png'),
              ),
            ),
            Text('Connected as: ')
          ],
        ),
      ),
    );
  }
}
