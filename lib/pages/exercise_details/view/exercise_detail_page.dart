import 'package:flutter/material.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/model/exercises.dart';

class ExerciseDetailPage extends StatelessWidget {
  const ExerciseDetailPage({Key? key, required this.exercise})
      : super(key: key);

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return ExerciseDetailView(exercise: exercise);
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
            AspectRatio(
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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(exercise.name),
                    const Spacer(),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Repetitions',
                      ),
                    ),
                    const Spacer(),
                    Row(
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
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
