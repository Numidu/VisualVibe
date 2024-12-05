import 'package:flutter/material.dart';

import 'package:socially/views/responsive/utilits/constant/colors.dart';

class Custombuttom extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onpressed;
  const Custombuttom(
      {super.key,
      required this.text,
      required this.width,
      required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
          gradient: gradientcolor, borderRadius: BorderRadius.circular(8)),
      child: TextButton(
          onPressed: onpressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: mainWhiteColor),
          )),
    );
  }
}
