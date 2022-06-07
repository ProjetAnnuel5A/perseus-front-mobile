import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/common/widget/gradient_progress_indicator_widget.dart';
import 'package:perseus_front_mobile/pages/profile/bloc/profile_bloc.dart';
import 'package:perseus_front_mobile/repositories/profile_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(context.read<ProfileRepository>()),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            final profile = state.profile;

            return Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 120,
                      backgroundImage: AssetImage('assets/images/runner.png'),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Profile informations',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                      Text('Username: ${profile.username}'),
                      Text('Email: ${profile.email}')
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            );
          }
          return customLoader();
        },
      ),
    );
  }

  GradientProgressIndicator customLoader() {
    return GradientProgressIndicator(
      gradientColors: [
        Colors.white,
        ColorPerseus.pink,
      ],
      child: const Text(
        'Loading...',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }
}
