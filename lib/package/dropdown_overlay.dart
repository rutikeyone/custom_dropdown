part of 'custom_dropdown.dart';

const _overlayOuterPadding = EdgeInsets.only(bottom: 12, left: 12, right: 12);
const _overlayShadowOffset = Offset(0, 6);
const _listItemPadding = EdgeInsets.symmetric(vertical: 12, horizontal: 16);

abstract class NamedValue {
  String getName();
}

class _DropdownOverlay extends StatefulWidget {
  final TextEditingController controller;
  final NamedValue? selectedItem;
  final List<NamedValue> items;
  final Size size;
  final LayerLink layerLink;
  final VoidCallback hideOverlay;
  final String hintText;
  final TextStyle? headerStyle;
  final TextStyle? listItemStyle;
  final bool? excludeSelected;
  final bool? canCloseOutsideBounds;
  final ValueChanged<int>? onChangedIndex;
  final GlobalKey stickyKey;
  final Widget? selectedIcon;
  final Color? itemBackgroundColor;
  final Decoration? decoration;
  final TextStyle? noElementStyle;
  final String? notElementLabel;
  final TextStyle? selectedItemStyle;
  final Widget Function(Widget, ScrollController)? itemBuilder;
  final ScrollbarThemeData? scrollBarTheme;
  final int? dropdownOverlayHeight;

  const _DropdownOverlay({
    Key? key,
    required this.controller,
    required this.selectedItem,
    required this.items,
    required this.size,
    required this.layerLink,
    required this.hideOverlay,
    required this.hintText,
    required this.stickyKey,
    this.headerStyle,
    this.listItemStyle,
    this.excludeSelected,
    this.canCloseOutsideBounds,
    this.onChangedIndex,
    this.selectedIcon,
    this.itemBackgroundColor,
    this.decoration,
    this.noElementStyle,
    this.notElementLabel,
    this.selectedItemStyle,
    this.itemBuilder,
    this.scrollBarTheme,
    this.dropdownOverlayHeight,
  }) : super(key: key);

  @override
  _DropdownOverlayState createState() => _DropdownOverlayState();
}

class _DropdownOverlayState extends State<_DropdownOverlay> {
  bool displayOverly = true;
  bool displayOverlayBottom = true;
  late String headerText;
  late List<NamedValue> items;
  late List<NamedValue> filteredItems;
  final key1 = GlobalKey(), key2 = GlobalKey();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final render1 = key1.currentContext?.findRenderObject() as RenderBox;
      final render2 = key2.currentContext?.findRenderObject() as RenderBox;
      final screenHeight = MediaQuery.of(context).size.height;
      double y = render1.localToGlobal(Offset.zero).dy;
      if (screenHeight - y < render2.size.height) {
        displayOverlayBottom = false;
        setState(() {});
      }
    });

    headerText =
        widget.selectedItem != null ? widget.selectedItem!.getName() : widget.controller.text;
    if (widget.excludeSelected! && widget.items.length > 1 && widget.selectedItem != null) {
      items = widget.items.where((item) => item != widget.selectedItem).toList();
    } else {
      items = widget.items;
    }
    filteredItems = items;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final double topPadding;
    final keyContext = widget.stickyKey.currentContext;
    if (keyContext != null) {
      final renderBox = keyContext.findRenderObject() as RenderBox;
      topPadding = renderBox.size.height + 6;
    }
    final borderRadius = BorderRadius.circular(12);
    final overlayOffset = Offset(-12, topPadding);
    const listPadding = EdgeInsets.zero;

    final itemList = _ItemsList(
      selectedItem: widget.selectedItem,
      selectedItemStyle: widget.selectedItemStyle,
      itemBackgroundColor: widget.itemBackgroundColor,
      selectedIcon: widget.selectedIcon,
      scrollController: scrollController,
      excludeSelected: widget.items.length > 1 ? widget.excludeSelected! : false,
      items: items,
      padding: listPadding,
      headerText: headerText,
      itemTextStyle: widget.listItemStyle,
      onItemSelect: (value) {
        if (widget.selectedItem != items[value]) {
          widget.controller.text = items[value].getName();
          if (widget.onChangedIndex != null) {
            widget.onChangedIndex!(value);
          }
        }
        setState(() => displayOverly = false);
      },
    );

    final Widget list = () {
      if (items.isNotEmpty) {
        if (widget.itemBuilder != null) {
          return widget.itemBuilder!(itemList, scrollController);
        } else {
          return itemList;
        }
      } else {
        return SizedBox(
          height: 48,
          child: Center(
            child: Text(
              widget.notElementLabel ?? 'There is no data for selection',
              style: widget.noElementStyle ?? const TextStyle(fontSize: 16),
            ),
          ),
        );
      }
    }.call();

    final dropdownOverlayHeight = widget.dropdownOverlayHeight;
    final double? height = dropdownOverlayHeight?.toDouble() ?? (items.length > 2 ? 96 : null);

    final child = Stack(
      children: [
        Positioned(
          width: widget.size.width + 24,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            followerAnchor: displayOverlayBottom ? Alignment.topLeft : Alignment.bottomLeft,
            showWhenUnlinked: false,
            offset: overlayOffset,
            child: Container(
              key: key1,
              padding: _overlayOuterPadding,
              child: DecoratedBox(
                decoration: widget.decoration ??
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24.0,
                          color: Colors.black.withOpacity(.08),
                          offset: _overlayShadowOffset,
                        ),
                      ],
                    ),
                child: Material(
                  color: Colors.transparent,
                  child: AnimatedSection(
                    animationDismissed: widget.hideOverlay,
                    expand: displayOverly,
                    axisAlignment: displayOverlayBottom ? 1.0 : -1.0,
                    child: SizedBox(
                      key: key2,
                      height: height,
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (notification) {
                            notification.disallowIndicator();
                            return true;
                          },
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              scrollbarTheme: widget.scrollBarTheme ??
                                  ScrollbarThemeData(
                                    thumbVisibility: MaterialStateProperty.all(
                                      true,
                                    ),
                                    thickness: MaterialStateProperty.all(5),
                                    radius: const Radius.circular(4),
                                    thumbColor: MaterialStateProperty.all(
                                      Colors.grey[300],
                                    ),
                                  ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [items.length > 2 ? Expanded(child: list) : list],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => setState(() => displayOverly = false),
      child: widget.canCloseOutsideBounds!
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: child,
            )
          : child,
    );
  }
}

class _ItemsList extends StatelessWidget {
  final ScrollController scrollController;
  final List<NamedValue> items;
  final NamedValue? selectedItem;
  final bool excludeSelected;
  final String headerText;
  final ValueSetter<int> onItemSelect;
  final EdgeInsets padding;
  final TextStyle? itemTextStyle;
  final Widget? selectedIcon;
  final Color? itemBackgroundColor;
  final TextStyle? selectedItemStyle;

  const _ItemsList({
    Key? key,
    required this.selectedItem,
    required this.scrollController,
    required this.items,
    required this.excludeSelected,
    required this.headerText,
    required this.onItemSelect,
    required this.padding,
    this.itemTextStyle,
    this.selectedIcon,
    this.itemBackgroundColor,
    this.selectedItemStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listItemStyle = const TextStyle(
      fontSize: 16,
    ).merge(itemTextStyle);

    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        padding: padding,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final selected = !excludeSelected &&
              (selectedItem != null
                  ? selectedItem == items[index]
                  : headerText == items[index].getName());
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.grey[200],
              onTap: () => onItemSelect(index),
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(minHeight: 48),
                    color: itemBackgroundColor ?? Colors.transparent,
                    padding: _listItemPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            items[index].getName(),
                            style: selected ? selectedItemStyle : listItemStyle,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        selected
                            ? selectedIcon ?? const SizedBox.shrink()
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(left: 16), child: Divider(height: 1, thickness: 1)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
