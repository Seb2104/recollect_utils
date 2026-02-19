part of '../../../recollect_utils.dart';

/// A flexible tab view that supports tabs on any edge — top, bottom, left,
/// or right.
///
/// [TabView] wraps Flutter's [TabController] and [TabBarView] into a single
/// widget with a clean API. Tabs can be arranged horizontally (top/bottom)
/// or vertically (left/right) with an animated selection indicator.
///
/// ## Example
///
/// ```dart
/// TabView(
///   tabPosition: Side.left,
///   tabsWidth: 180,
///   content: TabViewContent([
///     TabViewItem('Dashboard', view: DashboardPage()),
///     TabViewItem('Settings', view: SettingsPage()),
///     TabViewItem('Profile', view: ProfilePage()),
///   ]),
/// )
/// ```
///
/// ## Customisation
///
/// - Control which tab is selected on mount with [initialIndex].
/// - Disable the selection indicator by setting [indicator] to `false`.
/// - Add [leading] and [trailing] widgets around the tab strip.
/// - Adjust the animation speed with [animationDuration].
class TabView extends StatefulWidget {
  /// Which side the tabs are aligned to
  final Side tabPosition;

  /// How much horizontal space to give the tabs
  ///
  /// # ONLY WORKS IF
  /// [tabPosition] is set to [Side.left] or [Side.right]
  final double tabsWidth;

  /// How long the animation will play for
  ///
  /// Set to [Duration.zero] to remove the animation in its entirety
  final Duration animationDuration;

  /// Whether or not to show the indicator for the selected tab
  final bool indicator;

  /// Which tab is selected when first drawn
  final int initialIndex;

  /// The amount of padding the tabs get in the direction of their arrangement
  final EdgeInsets? tabPadding;

  /// Puts this widget before the tabs
  final Widget? leading;

  /// Puts this widget after the tabs
  final Widget? trailing;

  /// A variable containing all of the tabs in an organized list
  final TabViewContent content;

  const TabView({
    super.key,
    this.content = demoContent,
    this.tabPosition = Side.top,
    this.tabsWidth = 200,
    this.animationDuration = kTabScrollDuration,
    this.indicator = true,
    this.initialIndex = 0,
    this.tabPadding,
    this.leading,
    this.trailing,
  });

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    controller = TabController(
      length: widget.content.length,
      vsync: this,
      animationDuration: widget.animationDuration,
      initialIndex: widget.initialIndex.clamp(0, widget.content.length - 1),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.tabPosition) {
      case Side.bottom || Side.top:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.tabPosition == Side.top) _buildHorizontalTabs(),
            _buildPages(),
            if (widget.tabPosition == Side.bottom) _buildHorizontalTabs(),
          ],
        );
      case Side.left || Side.right:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.tabPosition == Side.left) _buildVerticalTabs(),
            _buildPages(),
            if (widget.tabPosition == Side.right) _buildVerticalTabs(),
          ],
        );
    }
  }

  Widget _buildPages() {
    return Expanded(
      child: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: widget.content.pages.toList(),
      ),
    );
  }

  Widget _buildHorizontalTabs() {
    return SingleChildScrollView(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Row(
            children: [
              if (widget.leading != null) ...[
                const SizedBox(width: 10),
                widget.leading!,
                const SizedBox(width: 10),
              ],

              ...List.generate(widget.content.length, (index) {
                return InkWell(
                  onTap: () => controller.animateTo(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: controller.index == index
                          ? AppTheme.primarySage.withValues(alpha: 0.08)
                          : Colors.transparent,

                      border: widget.indicator == true
                          ? widget.tabPosition == Side.top
                                ? Border(
                                    bottom: BorderSide(
                                      color: controller.index == index
                                          ? AppTheme.primarySage
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  )
                                : Border(
                                    top: BorderSide(
                                      color: controller.index == index
                                          ? AppTheme.primarySage
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  )
                          : null,
                    ),
                    padding:
                        widget.tabPadding ??
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Word(
                      widget.content.titles.toList()[index],
                      fontWeight: controller.index == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }),

              if (widget.trailing != null) ...[
                const SizedBox(width: 10),
                widget.trailing!,
                const SizedBox(width: 10),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildVerticalTabs() {
    return SizedBox(
      width: widget.tabsWidth,
      child: SingleChildScrollView(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.leading != null) ...[
                  const SizedBox(height: 10),
                  widget.leading!,
                  const SizedBox(height: 10),
                ],
                ...List.generate(widget.content.length, (index) {
                  return InkWell(
                    onTap: () => controller.animateTo(index),
                    child: Container(
                      width: double.infinity,
                      padding:
                          widget.tabPadding ??
                          const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: controller.index == index
                            ? AppTheme.primarySage.withValues(alpha: 0.08)
                            : Colors.transparent,
                        border: widget.indicator
                            ? widget.tabPosition == Side.right
                                  ? Border(
                                      left: BorderSide(
                                        color: controller.index == index
                                            ? AppTheme.primarySage
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                    )
                                  : Border(
                                      right: BorderSide(
                                        color: controller.index == index
                                            ? AppTheme.primarySage
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                    )
                            : null,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Word(widget.content.titles.toList()[index]),
                      ),
                    ),
                  );
                }),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 10),
                  widget.trailing!,
                  const SizedBox(width: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// The data model for a [TabView], holding the list of tabs and their
/// associated page widgets.
///
/// ```dart
/// const content = TabViewContent([
///   TabViewItem('Home', view: HomePage()),
///   TabViewItem('Search', view: SearchPage()),
/// ]);
/// ```
class TabViewContent {
  /// The ordered list of [TabViewItem]s.
  final List<TabViewItem> content;

  /// Creates a [TabViewContent] from a list of [TabViewItem]s.
  const TabViewContent(this.content);

  /// The number of tabs.
  int get length => content.length;

  /// Builds a list of [Tab] widgets from the item titles (for use with
  /// a standard [TabBar] if needed).
  List<Tab> get tabs {
    List<Tab> data = [];
    for (TabViewItem item in content) {
      data.add(Tab(text: item.title));
    }
    return data;
  }

  /// A flat list of tab title strings.
  List<String> get titles {
    List<String> data = [];
    for (TabViewItem item in content) {
      data.add(item.title);
    }
    return data;
  }

  /// A flat list of the page widgets for each tab.
  List<Widget> get pages {
    List<Widget> data = [];
    for (TabViewItem item in content) {
      data.add(item.view);
    }
    return data;
  }
}

/// A single tab entry pairing a [title] with a [view] widget.
class TabViewItem {
  /// The text label shown in the tab strip.
  final String title;

  /// The widget displayed when this tab is selected.
  final Widget view;

  /// Creates a [TabViewItem] with the given [title] and [view].
  const TabViewItem(this.title, {required this.view});
}

/// Which edge of the [TabView] the tab strip should appear on.
enum Side { top, left, bottom, right }
