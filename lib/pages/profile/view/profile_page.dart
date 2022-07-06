import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/common/extensions.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/common/widget/functions.dart';
import 'package:perseus_front_mobile/common/widget/gradient_progress_indicator_widget.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/model/enum/day.dart';
import 'package:perseus_front_mobile/model/enum/level.dart';
import 'package:perseus_front_mobile/model/enum/objective.dart';
import 'package:perseus_front_mobile/model/profile.dart';
import 'package:perseus_front_mobile/pages/profile/bloc/profile_bloc.dart';
import 'package:perseus_front_mobile/repositories/profile_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(context.read<ProfileRepository>()),
      child: ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);

  var _usernameController = TextEditingController();
  var _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              final profile = state.profile;

              return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                children: [
                  _profilePicture(context),
                  _profileInformationsTitle(context),
                  Column(
                    children: <Widget>[
                      Text(l10n.mainInformations),
                      _usernameField(context, profile.username),
                      _emailField(context, profile.email),
                      const SizedBox(height: 20),
                      Text(l10n.additionalInformations),
                      _heightField(context, profile),
                      _weightField(context, profile),
                      _birthDateField(context, profile),
                      _levelField(context, profile),
                      _objectiveField(context, profile),
                      const SizedBox(height: 20),
                      Text(l10n.availabilities),
                      _availabilies(context, profile)
                    ],
                  ),
                  _validateButton(context, profile)
                ],
              );
            } else if (state is ProfileError) {
              return showError(context, state);
            }
            return customLoader(context);
          },
        ),
      ),
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

  Widget _profilePicture(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: CircleAvatar(
        radius: 120,
        backgroundColor: Colors.black,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('assets/images/woman_running.png'),
          radius: 119,
        ),
      ),
    );
  }

  Widget _profileInformationsTitle(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          context.l10n.profileInformations,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.black),
        ),
      ),
    );
  }

  Widget _emailField(BuildContext context, String email) {
    final l10n = context.l10n;
    _emailController = TextEditingController(text: email);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _emailController,
        enabled: false,
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

  Widget _usernameField(BuildContext context, String username) {
    final l10n = context.l10n;
    _usernameController = TextEditingController(text: username);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _usernameController,
        enabled: false,
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

  Widget _birthDateField(BuildContext context, Profile profile) {
    final l10n = context.l10n;
    final appLocale = Localizations.localeOf(context);
    final profileBirthDate = profile.birthDate;
    final now = DateTime.now();

    var localeType = LocaleType.en;

    if (appLocale == const Locale('fr')) {
      localeType = LocaleType.fr;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.date_range,
          ),
          Text(' ${l10n.birthday}:'),
          const Spacer(),
          OutlinedButton(
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                minTime: now.subtract(const Duration(days: 365 * 100)),
                maxTime: now,
                onConfirm: (date) {
                  context.read<ProfileBloc>().add(
                        BirthDateChanged(profile, date),
                      );
                },
                currentTime: profileBirthDate,
                locale: localeType,
              );
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            child: Text(profileBirthDate.toString().substring(0, 10)),
          ),
        ],
      ),
    );
  }

  Widget _heightField(BuildContext context, Profile profile) {
    final l10n = context.l10n;

    var height = '';

    if (profile.height != null) {
      height = profile.height.toString();
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        initialValue: height,
        onChanged: (String newValue) {
          context.read<ProfileBloc>().add(
                HeightChanged(profile, int.parse(newValue)),
              );
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: '${l10n.height}(cm)',
        ),
      ),
    );
  }

  Widget _weightField(BuildContext context, Profile profile) {
    final l10n = context.l10n;

    var weight = '';

    if (profile.weight != null) {
      weight = profile.weight.toString();
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        initialValue: weight,
        onChanged: (String newValue) {
          context.read<ProfileBloc>().add(
                WeightChanged(profile, double.parse(newValue)),
              );
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: '${l10n.weight}(kg)',
        ),
      ),
    );
  }

  Widget _levelField(BuildContext context, Profile profile) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: DropdownButtonFormField<Level>(
        value: profile.level,
        onChanged: (Level? newValue) {
          if (newValue != null) {
            context.read<ProfileBloc>().add(LevelChanged(profile, newValue));
          }
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.level,
        ),
        items: Level.values.map((Level level) {
          return DropdownMenuItem<Level>(
            value: level,
            child: Text(translateLevel(context, level)),
          );
        }).toList(),
      ),
    );
  }

  Widget _objectiveField(BuildContext context, Profile profile) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: DropdownButtonFormField<Objective>(
        value: profile.objective,
        onChanged: (Objective? newValue) {
          if (newValue != null) {
            context
                .read<ProfileBloc>()
                .add(ObjectiveChanged(profile, newValue));
          }
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.objective,
        ),
        items: Objective.values.map((Objective objective) {
          return DropdownMenuItem<Objective>(
            value: objective,
            child: Text(translateObjective(context, objective)),
          );
        }).toList(),
      ),
    );
  }

  Widget _availabilies(BuildContext context, Profile profile) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: Day.values.length,
        itemBuilder: (context, index) {
          final day = Day.values[index];
          final dayString = translateDay(context, day);
          var isChecked = false;

          if (profile.availability.contains(day.toShortString())) {
            isChecked = true;
          }

          return Row(
            children: [
              Text(dayString),
              const Spacer(),
              Checkbox(
                value: isChecked,
                activeColor: ColorPerseus.blue,
                onChanged: (bool? newValue) {
                  final availability = profile.availability;

                  if (newValue != null) {
                    if (newValue == true) {
                      availability.add(day.toShortString());
                    } else {
                      availability.remove(day.toShortString());
                    }
                  }
                  context
                      .read<ProfileBloc>()
                      .add(AvailabilityChanged(profile, availability));
                },
              )
            ],
          );
        },
      ),
    );
  }

  Widget _validateButton(BuildContext context, Profile profile) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: CupertinoButton.filled(
              disabledColor: CupertinoColors.inactiveGray,
              onPressed: () {
                context.read<ProfileBloc>().add(
                      ProfileUpdate(profile),
                    );
              },
              child: Text(context.l10n.update),
            ),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Widget showError(BuildContext context, ProfileError state) {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarError(context, state.httpException),
      );
    });
    return Center(
      child: Column(
        children: [
          const Spacer(),
          _errorImage(),
          const Spacer(),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(ColorPerseus.pink),
              padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
              textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 20),
              ),
            ),
            onPressed: () {
              context.read<ProfileBloc>().add(ProfileStarted());
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.reload),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.refresh,
                  size: 30,
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _errorImage() {
    return SizedBox(
      child: Image.asset('assets/images/exception.png'),
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
    if (httpException is InternalServerException) {
      return httpException.getTranslatedMessage(context);
    } else if (httpException is CommunicationTimeoutException) {
      return httpException.getTranslatedMessage(context);
    }

    return context.l10n.unknownException;
  }
}
