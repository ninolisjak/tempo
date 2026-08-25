import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// Stand-in for camera output and album artwork: a diagonal stripe overlay
/// over an indigo/plum gradient, drifting very slowly.
///
/// Swap the whole widget for an `Image` once real photos land — the drift is
/// a placeholder affordance, not part of the photo treatment.
class PhotoPlaceholder extends StatefulWidget {
  const PhotoPlaceholder({
    super.key,
    this.index = 0,
    this.drift = TMotion.driftPhoto,
    this.animate = true,
  });

  final int index;
  final Duration drift;
  final bool animate;

  static const _grounds = <List<Color>>[
    [Color(0xFF4C5397), Color(0xFF2B2741), Color(0xFF1A1C28)],
    [Color(0xFF595D6C), Color(0xFF262A60), Color(0xFF191B27)],
    [Color(0xFF353B80), Color(0xFF3F424D), Color(0xFF1A1C28)],
  ];

  static const _angles = <Alignment>[
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.topLeft,
  ];

  @override
  State<PhotoPlaceholder> createState() => _PhotoPlaceholderState();
}

class _PhotoPlaceholderState extends State<PhotoPlaceholder>
    with SingleTickerProviderStateMixin {
  // Only created when the drift is wanted — a `late final` here would be
  // constructed by dispose() on a deactivated element.
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller = AnimationController(vsync: this, duration: widget.drift)
        ..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        PhotoPlaceholder._grounds[widget.index % PhotoPlaceholder._grounds.length];
    final begin =
        PhotoPlaceholder._angles[widget.index % PhotoPlaceholder._angles.length];

    final ground = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: -begin,
          colors: colors,
          stops: const [0, 0.58, 1],
        ),
      ),
      child: const _Stripes(),
    );

    final controller = _controller;
    if (controller == null) return ground;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(controller.value);
        return Transform.translate(
          // The CSS drifts by a percentage of the box; approximate in px.
          offset: Offset(-8 * t, -6 * t),
          child: Transform.scale(scale: 1.04 + 0.08 * t, child: child),
        );
      },
      child: ground,
    );
  }
}

class _Stripes extends StatelessWidget {
  const _Stripes();

  @override
  Widget build(BuildContext context) =>
      const CustomPaint(painter: _StripePainter(), size: Size.infinite);
}

class _StripePainter extends CustomPainter {
  const _StripePainter();

  @override
  void paint(Canvas canvas, Size size) {
    // repeating-linear-gradient(115deg, …0 12px, …12px 24px)
    const period = 24.0;
    const bandWidth = 12.0;
    const angle = 115 * 3.1415926535 / 180;

    // The CSS alternates 5% and 1.4% alpha; painting only the 5% band over the
    // ground gives the same read.
    final paint = Paint()
      ..color = const Color(0xFFE9E9ED).withValues(alpha: 0.036)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);

    final reach = size.width + size.height;
    for (var x = -reach; x < reach; x += period) {
      canvas.drawRect(Rect.fromLTWH(x, -reach, bandWidth, reach * 2), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_StripePainter oldDelegate) => false;
}

/// Album-artwork stand-in: a tighter, brighter diagonal hatch.
class ArtworkPlaceholder extends StatelessWidget {
  const ArtworkPlaceholder({
    super.key,
    this.radius = TRadius.control,
    this.opacity = 1,
    this.size,
  });

  final double radius;

  /// The hatch reads brighter on a photo than on the app ground.
  final double opacity;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _HatchPainter(opacity: opacity),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _HatchPainter extends CustomPainter {
  const _HatchPainter({required this.opacity});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    const period = 12.0;
    const bandWidth = 6.0;
    const angle = 135 * 3.1415926535 / 180;

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    // Artwork sits on the frosted card, which already lifts the ground, so the
    // hatch stays well below the CSS alphas to read as texture, not a panel.
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF1A1C2B).withValues(alpha: 0.34 * opacity),
    );
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);

    final paint = Paint()
      ..color = const Color(0xFFF3F5FE).withValues(alpha: 0.10 * opacity);
    final reach = size.width + size.height;
    for (var x = -reach; x < reach; x += period) {
      canvas.drawRect(Rect.fromLTWH(x, -reach, bandWidth, reach * 2), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HatchPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}
