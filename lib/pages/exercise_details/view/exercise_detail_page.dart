import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/model/exercise.dart';
import 'package:perseus_front_mobile/model/exercise_data.dart';
import 'package:perseus_front_mobile/pages/exercise_details/bloc/exercise_bloc.dart';
import 'package:perseus_front_mobile/repositories/exercise_data_repository.dart';

class ExerciseDetailPage extends StatelessWidget {
  const ExerciseDetailPage({Key? key, required this.exercise})
      : super(key: key);

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ExerciseBloc(context.read<ExerciseDataRepository>(), exercise),
      child: ExerciseDetailView(exercise: exercise),
    );
  }
}

class ExerciseDetailView extends StatelessWidget {
  const ExerciseDetailView({Key? key, required this.exercise})
      : super(key: key);
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        body: Column(
          children: [
            _imageContainer(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(exercise.name),
                    Expanded(
                      child: ListView.builder(
                        itemCount: exercise.exercisesData.length,
                        itemBuilder: (context, index) {
                          return repetitionsSet(
                              context, exercise.exercisesData[index], index);
                        },
                      ),
                    ),
                    _validateExercise(context)
                  ],
                ),
              ),
            ),
          ],
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
    ExerciseData exerciseData,
    int index,
  ) {
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (BuildContext context, ExerciseState state) {
        if (state is ExerciseLoaded) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text('Repetitions n°${index + 1}'),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ExerciseBloc>()
                          .add(DecrementRepetition(exercise, index));
                    },
                    child: const Text('-'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      '${state.exercise.exercisesData[index].repetition}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ExerciseBloc>()
                          .add(IncrementRepetition(exercise, index));
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

  Widget _validateExercise(BuildContext context) {
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
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: ColorPerseus.pink,
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: ColorPerseus.pink.withOpacity(0.5),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: InkWell(
              child: const Center(
                child: Text(
                  'Validate exercise',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () {
                context.read<ExerciseBloc>().add(ValidateExercisesData(
                      exercise.exercisesData,
                      exercise.exerciseDataIds,
                    ));
              },
            ),
          ),
        )
      ],
    );
  }
}
