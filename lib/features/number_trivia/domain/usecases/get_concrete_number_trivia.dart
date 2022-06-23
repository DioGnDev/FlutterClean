import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_app/triviakit/error/failures.dart';
import 'package:number_trivia_app/triviakit/usecases/usecase.dart';
import '../entity/number_trivia.dart';
import '../repository/number_trivia_repository.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(number: params.number);
  }
}

class Params extends Equatable {
  const Params({required this.number});

  final int number;

  @override
  List<Object?> get props => [number];
}
