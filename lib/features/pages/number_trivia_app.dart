import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia_app/features/pages/bloc/number_trivia_bloc.dart';
import 'package:number_trivia_app/injection_container.dart';
import '../pages/widgets/widgets.dart';

class NumberTriviaApp extends StatelessWidget {
  const NumberTriviaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => sl<NumberTriviaBloc>(),
        child: SingleChildScrollView(
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Top half
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return const MessageDisplay(message: 'Start searching!');
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  return TriviaDisplay(numberTrivia: state.numberTrivia);
                } else if (state is Error) {
                  return MessageDisplay(message: state.message);
                } else {
                  return Container();
                }
              },
            ),
            const SizedBox(height: 20),
            // Bottom half
            const TriviaControls(),
          ],
        ),
      ),
    );
  }
}
