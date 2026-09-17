import 'package:flutter/material.dart';
import '../../app/constants/app_assets.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showBadge;
  final bool withBackground;

  const AppLogo({
    super.key,
    this.size = 40,
    this.showBadge = false,
    this.withBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: Image.asset(
        AppAssets.logo,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.22),
            gradient: const LinearGradient(
              colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            Icons.calendar_today_rounded,
            size: size * 0.5,
            color: Colors.white,
          ),
        ),
      ),
    );

    if (withBackground) {
      return Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.08),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size * 0.22),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: imageWidget,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: imageWidget,
    );
  }
}
