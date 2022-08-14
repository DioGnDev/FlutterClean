import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/triviakit/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSource dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      //arrange
      //stub share preferences
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));

      //action
      final result = await dataSource.getLastNumberTrivia();

      //assert
      verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test(
      'should throw a CacheException when there is not a cached value',
      () {
        //arrange
        //stub share preferences
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);

        //act
        final call = dataSource.getLastNumberTrivia();

        //assert
        verify(() => mockSharedPreferences.getString(any()));
        expect(() => call, throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, message: "test trivia");

    test(
      'should call SharedPreferences to cache the data',
      () async {
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());

        //arrage
        when(
          () => mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA,
            expectedJsonString,
          ),
        ).thenAnswer((_) async => true);

        //act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);

        //assert
        verify(
          () => mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA,
            expectedJsonString,
          ),
        );
      },
    );
  });
}
