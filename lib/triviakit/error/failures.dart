import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.
  const Failure([List properties = const <dynamic>[]]) : super();
}

class ServerFailures extends Failure {
  @override
  List<Object?> get props => [];
}

class CacheFailures extends Failure {
  @override
  List<Object?> get props => [];
}
