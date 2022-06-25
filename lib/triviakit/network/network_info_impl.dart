import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:number_trivia_app/triviakit/platform/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> isConnected() async {
    return await connectionChecker.hasConnection;
  }
}
