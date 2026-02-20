import 'package:flutter/material.dart';
import 'package:recollect_utils/recollect_utils.dart';

class SuggestionFieldDemo extends StatefulWidget {
  const SuggestionFieldDemo({super.key});

  @override
  State<SuggestionFieldDemo> createState() => _SuggestionFieldDemoState();
}

class _SuggestionFieldDemoState extends State<SuggestionFieldDemo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          color: AppTheme.background(context),
          child: Center(
            child: SuggestionField(
              height: 50,
              width: 200,
              items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
              colour: Colours.black,
            ),
          ),
        ),
      ),
    );
  }
}
