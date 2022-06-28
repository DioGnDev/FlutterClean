import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/triviakit/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInteger', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        const str = '123';

        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result, const Right(123));
      },
    );

    test(
      'should return a failure when the string is not an integer',
      () {
        const str = 'abc';

        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return a failure when the number is negative',
      () {
        const str = '-123';

        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
