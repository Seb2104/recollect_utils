import 'package:flutter/material.dart';
import 'package:recollect_utils/recollect_utils.dart';

class FilteredMenuDemo extends StatefulWidget {
  const FilteredMenuDemo({super.key});

  @override
  State<FilteredMenuDemo> createState() => _FilteredMenuDemoState();
}

class _FilteredMenuDemoState extends State<FilteredMenuDemo> {
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
            child: FilteredMenu(
              items: menuItems,
              width: 500,
              setStateCallback: () => setState(() {}),
            ),
          ),
        ),
      ),
    );
  }
}

const List<String> menuValues = ['first', 'second', 'third', 'fourth', 'fifth'];
const Colour colour = Colours.white;
const List<MenuItem> menuItems = [
  MenuItem(label: 'First', value: '1'),
  MenuItem(label: 'Second', value: '2'),
  MenuItem(label: 'Third', value: '3'),
  MenuItem(label: 'Fourth', value: '4'),
  MenuItem(label: 'Fifth', value: '5'),
];
