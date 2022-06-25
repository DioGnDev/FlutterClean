import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:number_trivia_app/triviakit/error/exception.dart';
import 'package:number_trivia_app/triviakit/error/failures.dart';
import 'package:number_trivia_app/triviakit/platform/network_info.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  final int tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel(number: 1, message: "test trivia");
  final NumberTrivia numberTrivia = tNumberTriviaModel;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('get concrete number trivia', () {
    test('should check if the device is online', () {
      //arrange
      when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      //act
      repository.getConcreteNumberTrivia(number: tNumber);
      //assert
      verify(() => mockNetworkInfo.isConnected());
    });
  });

  group(
    'device is online',
    () {
      // This setUp applies only to the 'device is online' group
      setUp(() {
        when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
        when(() => mockLocalDataSource.cacheNumberTrivia(numberTrivia))
            .thenAnswer((_) => Future.value());
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result =
              await repository.getConcreteNumberTrivia(number: tNumber);

          // assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

          expect(result, equals(Right(numberTrivia)));
        },
      );

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrage
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(numberTrivia))
            .thenAnswer((_) async => Future.value());

        //act
        await repository.getConcreteNumberTrivia(number: tNumber);

        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(numberTrivia));
      });

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          //arrage
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenThrow(ServerException());

          //act
          final result =
              await repository.getConcreteNumberTrivia(number: tNumber);

          //assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailures())));
        },
      );
    },
  );

  group(
    'device is offline',
    () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected())
            .thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          final result =
              await repository.getConcreteNumberTrivia(number: tNumber);

          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(numberTrivia)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data is present',
        () async {
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          final result =
              await repository.getConcreteNumberTrivia(number: tNumber);

          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailures())));
        },
      );
    },
  );
}
