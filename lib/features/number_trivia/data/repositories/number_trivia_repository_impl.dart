import 'package:number_trivia_app/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:number_trivia_app/triviakit/error/failures.dart';
import 'package:number_trivia_app/triviakit/platform/network_info.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      {int? number}) async {
    networkInfo.isConnected;
    final remoteTrivia = await remoteDataSource.getConcreteNumberTrivia(number);
    localDataSource.cacheNumberTrivia(remoteTrivia);
    return Right(remoteTrivia);
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}
