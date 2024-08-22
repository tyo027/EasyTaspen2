import 'package:easy/core/common/widgets/svg_widget.dart';
import 'package:easy/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropdownItem<T> {
  final String text;
  final T value;

  DropdownItem({required this.text, required this.value});
}

class DropdownFieldWidget<T> extends StatefulWidget {
  final String placeholder;
  final List<DropdownItem<T>> items;

  final T? value;
  final bool enable;
  final ValueChanged<T?> onChange;
  final String? prefix;
  final String? subfix;

  final FormFieldValidator<T>? validator;
  final TextInputFormatter? format;

  const DropdownFieldWidget(
    this.placeholder, {
    required this.items,
    super.key,
    this.prefix,
    this.validator,
    this.value,
    this.enable = true,
    required this.onChange,
    this.subfix,
    this.format,
  });

  @override
  State<DropdownFieldWidget<T>> createState() => _DropdownFieldWidgetState<T>();
}

class _DropdownFieldWidgetState<T> extends State<DropdownFieldWidget<T>> {
  final FocusNode _focusNode = FocusNode();
  bool isPasswordHidden = true;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: widget.items
          .map((item) => DropdownMenuItem<T>(
                value: item.value,
                child: Text(
                  item.text,
                  style: const TextStyle(color: Colors.black),
                ),
              ))
          .toList(),
      isExpanded: true,
      focusNode: _focusNode,
      style: AppPallete.textStyle,
      value: widget.value,
      onChanged: widget.onChange,
      dropdownColor: Colors.white,
      elevation: 1,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.enable ? Colors.grey[50] : Colors.grey[200],
        labelText: widget.placeholder,
        labelStyle: AppPallete.textStyle.copyWith(
          color: widget.enable
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
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 30,
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
      ),
      validator: widget.validator,
    );
  }
}
