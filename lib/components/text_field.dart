import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ship_tracker/theme/theme.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.prefix,
  });

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  String? _errorText;
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        final text = widget.controller?.text;
        if (widget.validator != null) {
          setState(() {
            _errorText = widget.validator!(text);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String? validate() {
    final text = widget.controller?.text;
    final error = widget.validator?.call(text);
    setState(() {
      _errorText = error;
    });
    return error;
  }

  @override
  Widget build(BuildContext context) {
    Widget? botonOjo; // botón para ver contraseña

    if (widget.obscureText) {
      // Si el campo es de contraseña, configuramos el botón
      botonOjo = IconButton(
        icon: Icon(
          _isObscure ? Icons.visibility : Icons.visibility_off,
          color: grisOscuro,
        ),
        onPressed: () {
          setState(() {
            _isObscure = !_isObscure;
          });
        },
      );
    } else {
      // Si no es contraseña, no ponemos nada (null)
      botonOjo = null;
    }

    return SizedBox(
      width: 300,
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: _isObscure,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          labelText: widget.labelText,
          errorText: _errorText,
          errorMaxLines: 2,
          labelStyle: TextStyle(color: grisOscuro),
          floatingLabelStyle: TextStyle(
            color: verde,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: verde, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: botonOjo, 
          prefixIcon: widget.prefix, 
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          counterText: "",
        ),
        onChanged: (_) {
          if (_errorText != null) {
            setState(() {
              _errorText = null;
            });
          }
        },
      ),
    );
  }
}