import 'package:flutter/material.dart';

class DetailTravel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: titleSection,
    );
  }
}

Widget titleSection = Container(
  padding: const EdgeInsets.all(32),
  child: Row(
    children: [
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: const Text(
              'Lake',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ))
    ],
  ),
);
