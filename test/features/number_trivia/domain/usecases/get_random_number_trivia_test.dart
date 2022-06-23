import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_app/triviakit/usecases/usecase.dart';

class NumberTriviaRepositoryTest extends Mock
    implements NumberTriviaRepository {}

Future<void> main() async {
  late GetRandomNumberTrivia usecase;
  late NumberTriviaRepositoryTest mockRepository;

  NumberTrivia? tNumberTrivia = const NumberTrivia(number: 1, message: 'test');

  setUpAll(() {
    mockRepository = NumberTriviaRepositoryTest();
    usecase = GetRandomNumberTrivia(mockRepository);
  });

  test('should be get random number trivia', () async {
    mockRepository = NumberTriviaRepositoryTest();
    usecase = GetRandomNumberTrivia(mockRepository);

    //Stub method
    when(() => mockRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    final result = await usecase(NoParams());

    expect(result, Right(tNumberTrivia));
    verify(() => mockRepository.getRandomNumberTrivia()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
