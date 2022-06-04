import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/model/exercise.dart';
import 'package:perseus_front_mobile/model/set.dart';
import 'package:perseus_front_mobile/pages/set_details/bloc/set_bloc.dart';
import 'package:perseus_front_mobile/repositories/set_repository.dart';

class SetDetailPage extends StatelessWidget {
  const SetDetailPage({Key? key, required this.setId}) : super(key: key);

  final String setId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SetBloc(context.read<SetRepository>(), setId),
      child: const SetDetailView(),
    );
  }
}

class SetDetailView extends StatelessWidget {
  const SetDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        body: BlocBuilder<SetBloc, SetState>(
          builder: (context, state) {
            if (state is SetLoaded) {
              final set = state.set;

              return Column(
                children: [
                  _imageContainer(context),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(set.name),
                          Expanded(
                            child: ListView.builder(
                              itemCount: set.exercises.length,
                              itemBuilder: (context, index) {
                                return repetitionsSet(
                                  context,
                                  set,
                                  set.exercises[index],
                                  index,
                                );
                              },
                            ),
                          ),
                          _validateSet(context, set)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _imageContainer(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 0.65,
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Container(
              color: Colors.grey,
            ),
            // Image.asset(
            //   'assets/images/surentrainement.jpeg',
            //   fit: BoxFit.cover,
            //   width: double.infinity,
            // ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget repetitionsSet(
    BuildContext context,
    Set set,
    Exercise exercise,
    int index,
  ) {
    return BlocBuilder<SetBloc, SetState>(
      builder: (BuildContext context, SetState state) {
        if (state is SetLoaded) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text('Repetitions n°${index + 1}'),
                  const Spacer(),
                  ElevatedButton(
                    onPressed:
                        set.exercises[index].repetition <= 0 || set.isValided
                            ? null
                            : () {
                                context
                                    .read<SetBloc>()
                                    .add(DecrementRepetition(set, index));
                              },
                    child: const Text('-'),
                  ),
                  SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        '${state.set.exercises[index].repetition}',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: set.isValided
                        ? null
                        : () {
                            context
                                .read<SetBloc>()
                                .add(IncrementRepetition(set, index));
                          },
                    child: const Text('+'),
                  ),
                ],
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _validateSet(BuildContext context, Set set) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 48,
          height: 48,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Icon(
              Icons.add,
              color: ColorPerseus.pink,
              size: 28,
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: set.isValided
                ? null
                : () {
                    context
                        .read<SetBloc>()
                        .add(ValidateSet(set.id, set.exercises));
                  },
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
            child: const Text(
              'Validate set',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
        // child: Container(
        //   height: 48,
        //   decoration: BoxDecoration(
        //     color: ColorPerseus.pink,
        //     borderRadius: const BorderRadius.all(
        //       Radius.circular(16),
        //     ),
        //     boxShadow: <BoxShadow>[
        //       BoxShadow(
        //         color: ColorPerseus.pink.withOpacity(0.5),
        //         offset: const Offset(1.1, 1.1),
        //         blurRadius: 10,
        //       ),
        //     ],
        //   ),
        //   child: InkWell(
        //     child: const Center(
        //       child: Text(
        //         'Validate exercise',
        //         textAlign: TextAlign.left,
        //         style: TextStyle(
        //           fontWeight: FontWeight.w600,
        //           fontSize: 18,
        //           letterSpacing: 0,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //     onTap: () {
        //       context.read<ExerciseBloc>().add(
        //             ValidateExercisesData(
        //               exercise.exercisesData,
        //               exercise.exerciseDataIds,
        //             ),
        //           );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
