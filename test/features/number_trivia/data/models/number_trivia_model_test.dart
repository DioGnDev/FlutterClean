import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entity/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, message: "Test Text");

  test(
    'should be a subclass of NumberTrivia Entity',
    () async {
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromjson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the JSON number is regarded as a double',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = tNumberTriviaModel.toJson();

        final expectedJsonMap = {
          "text": "Test Text",
          "number": 1,
        };

        expect(result, expectedJsonMap);
      },
    );
  });
}
