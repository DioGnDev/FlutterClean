import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  const NumberTrivia({
    required this.number,
    required this.message,
  });

  final int number;
  final String message;

  @override
  List<Object?> get props => [number, message];
}
