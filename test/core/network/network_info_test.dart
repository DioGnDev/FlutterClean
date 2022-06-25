import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_app/triviakit/network/network_info_impl.dart';
import 'package:number_trivia_app/triviakit/platform/network_info.dart';

class MockConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  late NetworkInfo networkInfo;
  late MockConnectionChecker mockConnectionChecker;

  setUp(() {
    mockConnectionChecker = MockConnectionChecker();
    networkInfo = NetworkInfoImpl(mockConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to DataConnectionChecker.hasConnection',
      () async {
        when(() => mockConnectionChecker.hasConnection)
            .thenAnswer((_) async => true);

        final result = await networkInfo.isConnected();

        verify(() => mockConnectionChecker.hasConnection);

        expect(result, true);
      },
    );
  });
}
