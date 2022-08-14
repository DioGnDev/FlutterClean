import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_app/features/pages/bloc/number_trivia_bloc.dart';
import 'package:number_trivia_app/triviakit/error/failures.dart';
import 'package:number_trivia_app/triviakit/util/input_converter.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

class ParamFake extends Fake implements Params {}

void main() {
  late NumberTriviaBloc triviaBloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUpAll(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    triviaBloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );

    registerFallbackValue(ParamFake());
  });

  group(
    'bloc test',
    () {
      test(
        'should return initial state with empty state',
        () {
          expect(triviaBloc.state, isA<Empty>());
        },
      );
    },
  );

  group(
    'GetTriviaForConcreteNumber',
    () {
      const tNumberString = '1';
      final tNumberParsed = int.parse(tNumberString);
      const tNumberTrivia = NumberTrivia(number: 1, message: 'test trivia');

      void setUpMockInputConverterSuccess() => when(
            () => mockInputConverter.stringToUnsignedInteger(any()),
          ).thenReturn(
            Right(tNumberParsed),
          );

      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
          //Stubbing input converter
          setUpMockInputConverterSuccess();

          //act
          triviaBloc.add(
            const GetTriviaForConcreteNumber(numberString: tNumberString),
          );
          await untilCalled(
            () => mockInputConverter.stringToUnsignedInteger(any()),
          );

          //assert
          verify(
            () => mockInputConverter.stringToUnsignedInteger(tNumberString),
          );
        },
      );

      test(
        'should emit [Error] when the input is invalid',
        () async* {
          //arrage
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Left(InvalidInputFailure()));

          //assert later
          final expected = [
            Empty(),
            const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ];
          expectLater(triviaBloc, emitsInOrder(expected));

          //act
          triviaBloc.add(
            const GetTriviaForConcreteNumber(numberString: tNumberString),
          );
        },
      );

      test(
        'should get data from the concrete use case',
        () async {
          //arrage
          setUpMockInputConverterSuccess();

          when(() => mockGetConcreteNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));

          //act
          triviaBloc.add(
              const GetTriviaForConcreteNumber(numberString: tNumberString));

          await untilCalled(() => mockGetConcreteNumberTrivia(any()));

          //assert
          verify(
            () => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)),
          );
        },
      );
    },
  );

  group(
    'Bloc test package',
    () {
      const tNumberString = '1';
      final tNumberParsed = int.parse(tNumberString);
      const tNumberTrivia = NumberTrivia(number: 1, message: 'test trivia');

      blocTest<NumberTriviaBloc, NumberTriviaState>(
        'should emit [Loaded] number trivia',
        build: () {
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));

          return NumberTriviaBloc(
            getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
            getRandomNumberTrivia: mockGetRandomNumberTrivia,
            inputConverter: mockInputConverter,
          );
        },
        act: (bloc) => bloc.add(
          const GetTriviaForConcreteNumber(numberString: tNumberString),
        ),
        expect: () => [
          Loading(),
          const Loaded(numberTrivia: tNumberTrivia),
        ],
      );

      blocTest<NumberTriviaBloc, NumberTriviaState>(
        'should emit [Error] when getting data fails',
        build: () {
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia(any()))
              .thenAnswer((_) async => Left(ServerFailures()));

          return NumberTriviaBloc(
            getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
            getRandomNumberTrivia: mockGetRandomNumberTrivia,
            inputConverter: mockInputConverter,
          );
        },
        act: (bloc) => bloc.add(
          const GetTriviaForConcreteNumber(numberString: tNumberString),
        ),
        expect: () => [
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE),
        ],
      );
    },
  );
}
