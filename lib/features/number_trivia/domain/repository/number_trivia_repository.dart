import 'package:dartz/dartz.dart';
import '../entity/number_trivia.dart';
import 'package:number_trivia_app/triviakit/error/failures.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia({int? number});
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
