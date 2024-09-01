import 'package:easy/core/common/widgets/svg_widget.dart';
import 'package:easy/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  final String placeholder;

  final void Function(BuildContext context)? onTap;
  final TextEditingController? controller;
  final bool? isObscureText;
  final String? value;
  final bool enable;
  final ValueChanged<String>? onChange;
  final String? prefix;
  final String? subfix;
  final TextInputType? type;
  final int? lines;

  final FormFieldValidator<String>? validator;
  final TextInputFormatter? format;
  final bool? isPassword;

  const TextFieldWidget(
    this.placeholder, {
    super.key,
    this.prefix,
    this.controller,
    this.isObscureText,
    this.validator,
    this.value,
    this.enable = true,
    this.onChange,
    this.subfix,
    this.type,
    this.format,
    this.lines,
    this.isPassword,
    this.onTap,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final FocusNode _focusNode = FocusNode();
  bool isPasswordHidden = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _hideKeyboard() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.value,
      focusNode: _focusNode,
      controller: widget.controller,
      enabled: widget.enable,
      style: AppPallete.textStyle,
      onChanged: widget.onChange,
      cursorColor: AppPallete.text,
      autocorrect: false,
      cursorErrorColor: AppPallete.red,
      keyboardType: widget.type,
      onTapAlwaysCalled: widget.onTap != null,
      enableInteractiveSelection: widget.onTap == null,
      canRequestFocus: widget.onTap == null,
      contextMenuBuilder: widget.onTap == null
          ? (context, editableTextState) =>
              AdaptiveTextSelectionToolbar.editableText(
                editableTextState: editableTextState,
              )
          : (_, __) => Container(),
      onTap: widget.onTap != null
          ? () {
              widget.onTap!(context);
              _focusNode.unfocus();
            }
          : null,
      inputFormatters: [if (widget.format != null) widget.format!],
      minLines: widget.lines ?? 1,
      maxLines: widget.lines ?? 1,
      expands: false,
      onTapOutside: (event) => _hideKeyboard(),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.enable ? Colors.grey[50] : Colors.grey[200],
        alignLabelWithHint: true,
        labelText: widget.placeholder,
        labelStyle: AppPallete.textStyle.copyWith(
          color: widget.enable || widget.onTap != null
              ? AppPallete.text.withOpacity(.6)
              : AppPallete.textGray,
        ),
        floatingLabelStyle: AppPallete.textStyle.copyWith(
          color: AppPallete.text,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        prefixIcon: widget.prefix == null
            ? null
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgWidget(
                      widget.prefix!,
                      color: AppPallete.text,
                    )
                  ],
                ),
              ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 48, // Minimum width for the icon
          minHeight: (30 * (widget.lines ?? 1))
              .toDouble(), // Minimum height for the icon to fill the height),
        ),
        suffixText: widget.subfix,
        suffixStyle: AppPallete.textStyle.copyWith(
          color: AppPallete.text,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        suffixIcon: widget.isPassword == null || widget.isPassword == false
            ? null
            : IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(!isPasswordHidden
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              ),
      ),
      obscureText: widget.isObscureText ??
          (widget.isPassword ?? false) && isPasswordHidden,
      validator: widget.validator,
    );
  }
}
