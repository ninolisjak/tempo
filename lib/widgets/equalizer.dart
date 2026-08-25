import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// Three bars scaling 0.3 → 1 on a staggered loop. Used in the logo panel,
/// the player card and the archive's "most played" strip.
class Equalizer extends StatefulWidget {
  const Equalizer({
    super.key,
    this.barWidth = 2,
    this.height = 12,
    this.gap = 2,
    this.color = TColor.accentLight,
    this.period = TMotion.equalizer,
    this.stagger = const Duration(milliseconds: 250),
  });

  final double barWidth;
  final double height;
  final double gap;
  final Color color;
  final Duration period;
  final Duration stagger;

  @override
  State<Equalizer> createState() => _EqualizerState();
}

class _EqualizerState extends State<Equalizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offsets = [
      0.0,
      widget.stagger.inMilliseconds / widget.period.inMilliseconds,
      2 * widget.stagger.inMilliseconds / widget.period.inMilliseconds,
    ];

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) SizedBox(width: widget.gap),
              SizedBox(
                width: widget.barWidth,
                // The CSS keyframe is 0.3 → 1 → 0.3 across one period.
                height: widget.height * _scaleAt(_controller.value + offsets[i]),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: widget.color),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _scaleAt(double t) {
    final phase = t % 1.0;
    final triangle = phase < 0.5 ? phase * 2 : (1 - phase) * 2;
    return 0.3 + 0.7 * Curves.easeInOut.transform(triangle);
  }
}
