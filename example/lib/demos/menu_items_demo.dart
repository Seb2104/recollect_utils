import 'package:flutter/material.dart';
import 'package:recollect_utils/recollect_utils.dart';

class MenuItemsDemo extends StatefulWidget {
  const MenuItemsDemo({super.key});

  @override
  State<MenuItemsDemo> createState() => _MenuItemsDemoState();
}

class _MenuItemsDemoState extends State<MenuItemsDemo> {
  int _selected = 1;

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
            child: MenuItems(
              items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
              width: 500,
              height: 50,
              colour: Colours.black,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              size: 16,
              onSelected: (T) {
                _selected = T;
                print(_selected);
              },
            ),
          ),
        ),
      ),
    );
  }
}
