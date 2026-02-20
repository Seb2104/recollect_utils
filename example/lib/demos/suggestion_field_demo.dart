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
          color: AppTheme.darkBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SuggestionField(
                alignDropdown: AlignType.center,
                alignDropdownText: TextAlign.center,
                height: 35,
                width: 500,
                onSelected: (value) {
                  print(value);
                },
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
