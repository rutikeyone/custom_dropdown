import 'package:flutter/material.dart';

export 'custom_dropdown.dart';

part 'animated_section.dart';
part 'dropdown_field.dart';
part 'dropdown_overlay.dart';
part 'overlay_builder.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? selectedStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final TextStyle? listItemStyle;
  final TextStyle? selectedItemStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final Widget? fieldSuffixIcon;
  final Function(String)? onChanged;
  final ValueChanged<int>? onChangedIndex;
  final bool? excludeSelected;
  final Color? fillColor;
  final bool? canCloseOutsideBounds;
  final double? heightButton;
  final ValueChanged<bool> overlayChanged;
  final String? selectedItem;
  final Widget? selectedIcon;
  final Color? itemBackgroundColor;
  final Decoration? decoration;
  final String? notElementLabel;
  final TextStyle? noElementStyle;
  final Widget Function(Widget, ScrollController)? itemBuilder;
  final TextEditingController? controller;
  final double? maxHeight;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.overlayChanged,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemStyle,
    this.selectedItemStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.onChanged,
    this.onChangedIndex,
    this.excludeSelected = true,
    this.fillColor = Colors.white,
    this.heightButton,
    this.selectedItem,
    this.selectedIcon,
    this.itemBackgroundColor,
    this.decoration,
    this.noElementStyle,
    this.notElementLabel,
    this.itemBuilder,
    this.controller,
    this.maxHeight,
  })  : canCloseOutsideBounds = true,
        super(key: key);

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  final layerLink = LayerLink();
  late final TextEditingController controller;
  final _stickyKey = GlobalKey();

  @override
  void initState() {
    final selectedItem = widget.selectedItem;
    controller = widget.controller ?? TextEditingController(text: selectedItem);
    if (widget.controller != null && selectedItem != null) {
      widget.controller?.text = selectedItem;
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hintText = widget.hintText ?? 'Select value';

    final hintStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xFFA7A7A7),
      fontWeight: FontWeight.w400,
    ).merge(widget.hintStyle);

    final selectedStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ).merge(widget.selectedStyle);

    return _OverlayBuilder(
      overlayChanged: widget.overlayChanged,
      overlay: (size, hideCallback) {
        return _DropdownOverlay(
          noElementStyle: widget.noElementStyle,
          selectedItemStyle: widget.selectedItemStyle,
          notElementLabel: widget.notElementLabel,
          decoration: widget.decoration,
          itemBackgroundColor: widget.itemBackgroundColor,
          selectedIcon: widget.selectedIcon,
          stickyKey: _stickyKey,
          onChangedIndex: widget.onChangedIndex,
          items: widget.items,
          controller: controller,
          size: size,
          layerLink: layerLink,
          hideOverlay: hideCallback,
          headerStyle: controller.text.isNotEmpty ? selectedStyle : hintStyle,
          hintText: hintText,
          listItemStyle: widget.listItemStyle,
          excludeSelected: widget.excludeSelected,
          canCloseOutsideBounds: widget.canCloseOutsideBounds,
          itemBuilder: widget.itemBuilder,
          maxHeight: widget.maxHeight,
        );
      },
      child: (showCallback) {
        return CompositedTransformTarget(
          link: layerLink,
          child: _DropDownField(
            stickyKey: _stickyKey,
            height: widget.heightButton,
            controller: controller,
            onTap: showCallback,
            style: selectedStyle,
            borderRadius: widget.borderRadius,
            borderSide: widget.borderSide,
            errorBorderSide: widget.errorBorderSide,
            errorStyle: widget.errorStyle,
            errorText: widget.errorText,
            hintStyle: hintStyle,
            hintText: hintText,
            suffixIcon: widget.fieldSuffixIcon,
            onChanged: widget.onChanged,
            fillColor: widget.fillColor,
          ),
        );
      },
    );
  }
}
