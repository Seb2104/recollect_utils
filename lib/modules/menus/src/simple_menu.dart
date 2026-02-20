part of '../menus.dart';

class SimpleMenu extends StatefulWidget {
  final double height;
  final double width;
  final List<MenuItem> items;

  @override
  State<SimpleMenu> createState() => _SimpleMenuState();

  const SimpleMenu({
    super.key,
    required this.items,
    this.height = 40,
    this.width = 200,
  });
}

class _SimpleMenuState extends State<SimpleMenu> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
