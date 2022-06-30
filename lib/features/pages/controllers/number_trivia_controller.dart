import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class NumberTriviaController extends GetxController {
  GetConcreteNumberTrivia getConcreteNumberTrivia;
  GetRandomNumberTrivia getRandomNumberTrivia;

  //reactive property
  var isLoading = false.obs;
  var errorMsg = "".obs;

  NumberTriviaController(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia});

  Future<void> concreteNumberTrivia() async {
    isLoading.value = true;
    final numberOrFailure =
        await getConcreteNumberTrivia.call(const Params(number: 1));

    numberOrFailure.fold((failure) {
      isLoading.value = false;
      errorMsg.value = "failure";
    }, (number) {
      isLoading.value = false;
      errorMsg.value = "";
    });
  }
}
