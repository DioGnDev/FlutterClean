import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia_app/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/triviakit/error/exception.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSource remoteDataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    registerFallbackValue(Uri());
    mockHttpClient = MockHttpClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    void setUpMockHttpClientSuccess200() {
      when(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(fixture('trivia.json'), 200),
      );
    }

    void setUpMockHttpClientFailure404() {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );
    }

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response(fixture('trivia.json'), 200),
        );

        remoteDataSource.getConcreteNumberTrivia(tNumber);

        verify(() => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'}));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);

        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();

        // act
        final call = remoteDataSource.getConcreteNumberTrivia;

        // assert
        expect(() => call(tNumber), throwsA(isA<ServerException>()));
      },
    );
  });
}
