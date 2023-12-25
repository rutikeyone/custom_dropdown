part of 'custom_dropdown.dart';

const _textFieldIcon = Icon(
  Icons.keyboard_arrow_down_rounded,
  color: Colors.black,
  size: 24,
);

class _DropDownField<T> extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final String? errorText;
  final TextStyle? errorStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final Widget? suffixIcon;
  final Color? fillColor;
  final double? height;
  final GlobalKey stickyKey;

  const _DropDownField({
    Key? key,
    required this.controller,
    required this.onTap,
    required this.stickyKey,
    this.suffixIcon,
    this.hintText,
    this.hintStyle,
    this.style,
    this.errorText,
    this.errorStyle,
    this.borderSide,
    this.errorBorderSide,
    this.borderRadius,
    this.fillColor,
    this.height,
  }) : super(key: key);

  @override
  State<_DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<_DropDownField> {
  @override
  Widget build(BuildContext context) {
    final hintText = widget.hintText;

    final contentPadding = EdgeInsets.symmetric(
        horizontal: 16, vertical: widget.height != null ? widget.height! / 2 - 9.5 : 0);
    const noTextStyle = TextStyle(height: 0);
    const borderSide = BorderSide(color: Colors.transparent);
    const errorBorderSide = BorderSide(color: Colors.redAccent, width: 1);

    final border = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.borderSide ?? borderSide,
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.errorBorderSide ?? errorBorderSide,
    );

    return TextFormField(
      key: widget.stickyKey,
      controller: widget.controller,
      validator: (val) {
        if (val?.isEmpty ?? false) return widget.errorText ?? '';
        return null;
      },
      readOnly: true,
      onTap: widget.onTap,
      style: widget.style,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: contentPadding,
        suffixIcon: widget.suffixIcon ?? _textFieldIcon,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        fillColor: widget.fillColor,
        filled: true,
        errorStyle: widget.errorText != null ? widget.errorStyle : noTextStyle,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }
}
