import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/instance_manager.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_app/features/pages/controllers/number_trivia_controller.dart';
import 'package:number_trivia_app/triviakit/error/failures.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class ParamFake extends Fake implements Params {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late NumberTriviaController triviaController;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    triviaController = NumberTriviaController(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia);

    registerFallbackValue(ParamFake());
  });

  group(
    'GetX test concrete number',
    () {
      const tNumber = 1;
      const tNumberTrivia = NumberTrivia(number: 1, message: 'test');

      test(
        'should call get concrete number',
        () {
          const tNumber = 1;
          const tNumberTrivia = NumberTrivia(number: 1, message: 'test');

          //arrange
          when(
            () => mockGetConcreteNumberTrivia(any()),
          ).thenAnswer(
            (_) async => const Right(tNumberTrivia),
          );

          //act
          triviaController.concreteNumberTrivia();

          //assert
          verify(
            () =>
                mockGetConcreteNumberTrivia.call(const Params(number: tNumber)),
          ).called(1);
        },
      );

      test(
        'should get concrete number trivia',
        () async {
          Get.put(triviaController);

          //arrange
          when(
            () => mockGetConcreteNumberTrivia(any()),
          ).thenAnswer(
            (_) async => Left(ServerFailures()),
          );

          final isLoading = triviaController.isLoading;
          final errMsg = triviaController.errorMsg;

          //act
          await triviaController.concreteNumberTrivia();

          //assert
          expect(isLoading.value, false);
          expect(errMsg.value, "failure");
        },
      );
    },
  );
}
