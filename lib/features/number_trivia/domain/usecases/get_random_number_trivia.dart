import 'package:dartz/dartz.dart';
import 'package:number_trivia_app/triviakit/error/failures.dart';
import 'package:number_trivia_app/triviakit/usecases/usecase.dart';
import '../entity/number_trivia.dart';
import '../repository/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
