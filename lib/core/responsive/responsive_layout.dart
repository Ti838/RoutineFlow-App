import 'package:flutter/material.dart';
import 'breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget compact;
  final Widget? medium;
  final Widget? expanded;

  const ResponsiveLayout({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.isExpanded(context) && expanded != null) {
      return expanded!;
    }
    if (ResponsiveBreakpoints.isMedium(context) && medium != null) {
      return medium!;
    }
    return compact;
  }
}
