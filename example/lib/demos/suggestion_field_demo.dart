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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SuggestionField(
                colour: AppTheme.surface(context).colour,
                height: 50,
                width: 100,
                items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                onSelected: (value) {
                  print(value);
                },
              ),
              SizedBox(height: 40),
              SuggestionField(
                height: 35,
                width: 500,
                onSelected: (value) {
                  print(value);
                },
                // colour: AppTheme.surface(context).colour,
                colour: Colours.white,
                items: [
                  8,
                  9,
                  10,
                  11,
                  12,
                  14,
                  16,
                  18,
                  20,
                  22,
                  24,
                  26,
                  28,
                  36,
                  48,
                  72,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
