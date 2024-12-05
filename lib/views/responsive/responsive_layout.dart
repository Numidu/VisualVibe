import 'package:flutter/widgets.dart';
import 'package:socially/views/responsive/utilits/constant/app_constant.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileLayout;
  final Widget webLayout;
  const ResponsiveLayout(
      {super.key, required this.mobileLayout, required this.webLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenMinimum) {
          return widget.webLayout;
        } else {
          return widget.mobileLayout;
        }
      },
    );
  }
}
