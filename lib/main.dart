import 'package:flutter/material.dart';

import 'features/pages/number_trivia_app.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Number Trivia',
      home: NumberTriviaApp(),
    );
  }
}
