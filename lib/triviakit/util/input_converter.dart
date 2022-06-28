import 'package:dartz/dartz.dart';
import 'package:number_trivia_app/triviakit/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final result = int.parse(str);
      if (result < 0) {
        return Left(InvalidInputFailure());
      } else {
        return Right(int.parse(str));
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
