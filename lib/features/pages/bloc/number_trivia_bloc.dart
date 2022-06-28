import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entity/number_trivia.dart';
import '../../../triviakit/util/input_converter.dart';
import '../../number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import '../../number_trivia/domain/usecases/get_random_number_trivia.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<NumberTriviaEvent>(_onNumberTriviaStatusChanged);
  }

  @override
  void onChange(Change<NumberTriviaState> change) {
    super.onChange(change);
    print(change);
  }

  void _onNumberTriviaStatusChanged(
    NumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      inputEither.fold(
        (failure) async* {
          yield const Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) => throw UnimplementedError(),
      );
    }
  }
}
