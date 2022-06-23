import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:number_trivia_app/triviakit/error/failures.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia({int? number}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}
