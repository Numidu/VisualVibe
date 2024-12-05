import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socially/views/responsive/utilits/constant/colors.dart';

class Custominput extends StatelessWidget {
  final TextEditingController controller;
  final String labeltext;
  final IconData icon;
  final bool obscuretext;
  final String? Function(String?)? validator;

  const Custominput(
      {super.key,
      required this.controller,
      required this.labeltext,
      required this.icon,
      required this.obscuretext,
      this.validator});

  @override
  Widget build(BuildContext context) {
    final boderStyle = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
        borderRadius: BorderRadius.circular(8));
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: boderStyle,
          focusedBorder: boderStyle,
          enabledBorder: boderStyle,
          labelText: labeltext,
          labelStyle: TextStyle(color: mainWhiteColor),
          filled: true,
          prefixIcon: Icon(
            icon,
            color: mainWhiteColor,
            size: 20,
          )),
      obscureText: obscuretext,
      validator: validator ,
    );
  }
}
