import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// The breathing accent ring on the "Post today" CTA and the shutter:
/// a 1px edge that brightens and throws a soft glow at the midpoint.
class Halo extends StatefulWidget {
  const Halo({
    super.key,
    required this.child,
    required this.borderRadius,
    this.period = TMotion.haloCta,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final Duration period;

  @override
  State<Halo> createState() => _HaloState();
}

class _HaloState extends State<Halo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: [
              BoxShadow(
                color: Color.lerp(TColor.accent, TColor.accentLight, t)!,
                spreadRadius: 1,
                blurRadius: 0,
              ),
              BoxShadow(
                color: TColor.accent.withValues(alpha: 0.45 * t),
                blurRadius: 22 * t,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
