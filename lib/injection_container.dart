import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:number_trivia_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_app/features/pages/bloc/number_trivia_bloc.dart';
import 'package:number_trivia_app/triviakit/network/network_info_impl.dart';
import 'package:number_trivia_app/triviakit/platform/network_info.dart';
import 'package:number_trivia_app/triviakit/util/input_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //Features - Number Trivia

  //Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  //Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //Usecase
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );

  //Core
  sl.registerLazySingleton(() => InputConverter());

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
