import 'package:flutter/foundation.dart';
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
      this.onTap,
      this.labelText,
      this.isObscure = false,
      this.validator,
      this.hintText,
      this.border,
      this.keyboardType,
      super.key});
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
      autofocus: widget.isAutoFocus,
      autovalidateMode: widget.isAutoValidate,
      controller: widget.controller,
      obscureText: showPass,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.lightBlue[100]),
          helperText: helperText,
          filled: true,
          fillColor: Colors.teal.shade900,
          border:
              widget.border ?? OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue.shade200, width: 2)),
          focusedBorder:
              widget.border ?? OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue.shade200, width: 2)),
          prefixIcon: widget.prefixIcon.runtimeType != Null
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: widget.prefixIcon,
                )
              : null,
          suffixIcon: widget.isObscure == false
              ? widget.suffixIcon
              : IconButton(
                  icon: showPass ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
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
