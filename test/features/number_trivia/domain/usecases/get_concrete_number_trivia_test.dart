import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:mocktail/mocktail.dart';

class NumberTriviaRepositoryTest extends Mock
    implements NumberTriviaRepository {}

Future<void> main() async {
  late GetConcreteNumberTrivia usecase;
  late NumberTriviaRepositoryTest mockRepository;

  int? tNumber = 1;
  NumberTrivia? tNumberTrivia = const NumberTrivia(number: 1, message: 'test');

  setUpAll(() {
    mockRepository = NumberTriviaRepositoryTest();
    usecase = GetConcreteNumberTrivia(mockRepository);
  });

  test('should be get number trivia', () async {
    mockRepository = NumberTriviaRepositoryTest();
    usecase = GetConcreteNumberTrivia(mockRepository);

    //Stub method with parameters
    when(() => mockRepository.getConcreteNumberTrivia(
            number: any(named: 'number')))
        .thenAnswer((_) async => Right(tNumberTrivia));

    final result = await usecase(Params(number: tNumber));

    expect(result, Right(tNumberTrivia));
    verify(() => mockRepository.getConcreteNumberTrivia(number: tNumber))
        .called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
