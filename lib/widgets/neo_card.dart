import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NeoCard extends StatelessWidget {
  const NeoCard({
    super.key,
    required this.child,
    this.color = MzajColors.white,
    this.padding,
    this.margin,
    this.onTap,
    this.radius = NeoStyle.radius,
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: NeoStyle.card(color: color, radius: radius),
      child: child,
    );

    if (onTap == null) return card;

    return GestureDetector(onTap: onTap, child: card);
  }
}

class NeoButton extends StatelessWidget {
  const NeoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = MzajColors.navy,
    this.textColor = MzajColors.white,
    this.icon,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: NeoStyle.pill(
            color: onPressed == null ? color.withValues(alpha: 0.4) : color,
          ),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                label.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: textColor,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class NeoIconButton extends StatelessWidget {
  const NeoIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = MzajColors.lime,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: 52,
          height: 52,
          decoration: NeoStyle.pill(color: color),
          child: Icon(icon, color: MzajColors.black),
        ),
      ),
    );
  }
}

class NeoScaffold extends StatelessWidget {
  const NeoScaffold({
    super.key,
    required this.backgroundColor,
    required this.body,
    this.appBar,
    this.bottomBar,
    this.floatingBar,
  });

  final Color backgroundColor;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomBar;
  final Widget? floatingBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: Column(
        children: [
          Expanded(child: body),
          if (floatingBar != null) floatingBar!,
          if (bottomBar != null) bottomBar!,
        ],
      ),
    );
  }
}
