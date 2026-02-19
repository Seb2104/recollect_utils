part of '../../recollect_utils.dart';

/// A ready-made [TabViewContent] with five placeholder tabs.
///
/// This exists as a fallback so you can drop a [TabView] into your widget
/// tree without immediately wiring up real content. It is also useful for
/// quick prototyping or screenshot demos.
///
/// ```dart
/// TabView(content: demoContent)
/// ```
const TabViewContent demoContent = TabViewContent([
  TabViewItem('First', view: First()),
  TabViewItem('Second', view: Second()),
  TabViewItem('Third', view: Third()),
  TabViewItem('Fourth', view: Fourth()),
  TabViewItem('Fifth', view: Fifth()),
]);

/// Placeholder widget for the first demo tab. Displays "First" centered.
class First extends StatelessWidget {
  const First({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('First'));
  }
}

/// Placeholder widget for the second demo tab. Displays "Second" centered.
class Second extends StatelessWidget {
  const Second({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Second'));
  }
}

/// Placeholder widget for the third demo tab. Displays "Third" centered.
class Third extends StatelessWidget {
  const Third({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Third'));
  }
}

/// Placeholder widget for the fourth demo tab. Displays "Fourth" centered.
class Fourth extends StatelessWidget {
  const Fourth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Fourth'));
  }
}

/// Placeholder widget for the fifth demo tab. Displays "Fifth" centered.
class Fifth extends StatelessWidget {
  const Fifth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Fifth'));
  }
}
