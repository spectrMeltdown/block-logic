import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BLTextBox extends StatefulWidget {
  final int? maxLength;
  final int? maxLines;
  final String? helperText;
  final String? validatorText;
  final bool isAutoFocus;
  final AutovalidateMode? isAutoValidate;
  final bool? enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final String? labelText;
  final bool isObscure;
  final String? Function(String?)? validator;
  //final Widget? error;
  final String? hintText;
  final InputBorder? border;
  final TextInputType? keyboardType;
  final BoxConstraints? constraints;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  const BLTextBox({
    required this.controller,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onSaved,
    this.constraints,
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
    // this.error,
    this.hintText,
    this.border,
    this.keyboardType,
    this.maxLength,
    this.maxLines = 1,
    super.key,
  });

  @override
  State<BLTextBox> createState() => _BLInputState();
}

class _BLInputState extends State<BLTextBox> {
  late bool showPass;
  String? helperText;
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.constraints,
      child: TextFormField(
        onSaved: widget.onSaved,
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
        cursorColor: Colors.white,
        cursorErrorColor: Colors.amber,
        onFieldSubmitted: widget.onFieldSubmitted,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
            helperStyle: const TextStyle(color: Colors.white38, fontStyle: FontStyle.italic),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.white38, fontStyle: FontStyle.italic),
            labelStyle: const TextStyle(color: Colors.white38, fontStyle: FontStyle.italic),
            floatingLabelBehavior: FloatingLabelBehavior.never, // when the placeholder animates to the top portion
            helperText: helperText,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            filled: true,
            fillColor: Colors.teal.shade900.withAlpha(200),
            // error: widget.error,
            errorStyle: const TextStyle(color: Colors.amber),
            focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange, width: 2)),
            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber, width: 2)),
            border: widget.border ?? OutlineInputBorder(borderSide: BorderSide(color: BLUI().getAppColor('lightBlue'), width: 2)),
            focusedBorder: widget.border ?? OutlineInputBorder(borderSide: BorderSide(color: BLUI().getAppColor('lightBlue'), width: 2)),
            //Colors.lightBlue.shade200
            counter: const BlankWidget(), // blank counter to prevent it from displaying when provider maxLength
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
      ),
    );
  }

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
}
