import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/common/widget/gradient_progress_indicator_widget.dart';
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
                                final children = <Widget>[
                                  repetitionsSet(
                                    context,
                                    set,
                                    set.exercises[index],
                                    index,
                                  ),
                                ];

                                // if (index != set.exercises.length - 1) {
                                //   children.add(
                                //     waitingTime(),
                                //   );
                                // }

                                return Column(
                                  children: children,
                                );
                              },
                            ),
                          ),
                          _bottomRow(context, set)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

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
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            width: double.infinity,
            child: Image.asset(
              'assets/images/gym_people.png',
            ),
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Text('${index + 1}) ${exercise.name}'),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed:
                          set.exercises[index].repetition <= 0 || set.isValided
                              ? null
                              : () {
                                  context
                                      .read<SetBloc>()
                                      .add(DecrementRepetition(set, index));
                                },
                      child: const Icon(
                        CupertinoIcons.minus_circle_fill,
                        size: 35,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Center(
                        child: Text(
                          '${state.set.exercises[index].repetition}',
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: set.isValided
                          ? null
                          : () {
                              context
                                  .read<SetBloc>()
                                  .add(IncrementRepetition(set, index));
                            },
                      child: const Icon(
                        CupertinoIcons.plus_circle_fill,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _bottomRow(BuildContext context, Set set) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.only(right: 10),
        //   child: SizedBox(
        //     width: 48,
        //     height: 48,
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: const BorderRadius.all(
        //           Radius.circular(16),
        //         ),
        //         border: Border.all(
        //           color: Colors.grey.withOpacity(0.2),
        //         ),
        //       ),
        //       child: IconButton(
        //         icon: const Icon(
        //           Icons.edit,
        //           size: 28,
        //         ),
        //         onPressed: set.isValided ? null : () {},
        //       ),
        //     ),
        //   ),
        // ),
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
            child: IconButton(
              icon: const Icon(
                Icons.history_outlined,
                size: 28,
              ),
              onPressed: set.isValided ? null : () {
                
              },
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
      ],
    );
  }

  Widget waitingTime() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 20,
            padding: const EdgeInsets.all(5),
            child: const VerticalDivider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
        ),
        const Icon(Icons.access_time),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 20,
            padding: const EdgeInsets.all(5),
            child: const VerticalDivider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
        ),
      ],
    );
  }
}
