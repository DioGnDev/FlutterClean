import 'package:number_trivia_app/features/number_trivia/domain/entity/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required int number,
    required String message,
  }) : super(number: number, message: message);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      number: (json['number'] as num).toInt(),
      message: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": message,
      "number": number,
    };
  }
}
