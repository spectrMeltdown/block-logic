import 'package:block_logic/components/custom_widgets.dart';
import 'package:flutter/material.dart';

class BLTextBox extends StatefulWidget {
  const BLTextBox(
      {required this.controller,
      this.helperText,
      this.validatorText,
      this.isAutoFocus = false,
      this.isAutoValidate,
      this.enabled,
      this.prefixIcon,
      this.suffixIcon,
      this.suffix,
      this.onTap,
      this.labelText,
      this.isObscure = false,
      this.validator,
      // this.error,
      this.hintText,
      this.border,
      this.keyboardType,
      this.maxLength,
      this.maxLines = 1,
      super.key});
  final int? maxLength;
  final int maxLines;
  final String? helperText;
  final String? validatorText;
  final bool isAutoFocus;
  final AutovalidateMode? isAutoValidate;
  final bool? enabled;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final String? labelText;
  final bool isObscure;
  final String? Function(String?)? validator;
  //final Widget? error;
  final Widget? suffix;
  final String? hintText;
  final InputBorder? border;
  final TextInputType? keyboardType;

  @override
  State<BLTextBox> createState() => _BLInputState();
}

class _BLInputState extends State<BLTextBox> {
  late bool showPass;
  String? helperText;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    showPass = widget.isObscure;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        helperText = widget.helperText;
      } else {
        helperText = null;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      enabled: widget.enabled,
      focusNode: focusNode,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      autofocus: widget.isAutoFocus,
      autovalidateMode: widget.isAutoValidate,
      controller: widget.controller,
      obscureText: showPass,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
          labelStyle: const TextStyle(color: Colors.white38, fontStyle: FontStyle.italic),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          helperText: helperText,
          filled: true,
          fillColor: Colors.teal.shade900.withAlpha(200),
          // error: widget.error,
          errorStyle: const TextStyle(color: Colors.amber),
          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber, width: 2)),
          border:
              widget.border ?? OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue.shade200, width: 2)),
          focusedBorder:
              widget.border ?? OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue.shade200, width: 2)),
          counter: blankWidget,
          suffix: widget.suffix,
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: widget.prefixIcon,
                )
              : null,
          suffixIcon: widget.isObscure == false
              ? widget.suffixIcon
              : IconButton(
                  icon: showPass
                      ? const Icon(
                          Icons.visibility,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.visibility_off,
                          color: Colors.white,
                        ),
                  onPressed: () {
                    setState(() {
                      showPass = !showPass;
                    });
                  },
                ),
          labelText: widget.labelText),
      validator: widget.validator,
    );
  }
}
