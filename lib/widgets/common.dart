import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// A hairline that fades to transparent at its ends, as Nocturne asks.
class FadingRule extends StatelessWidget {
  const FadingRule({super.key, this.fadeLeft = true, this.fadeRight = true});

  final bool fadeLeft;
  final bool fadeRight;

  @override
  Widget build(BuildContext context) {
    const solid = TColor.border;
    final clear = TColor.border.withValues(alpha: 0);
    return SizedBox(
      height: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              fadeLeft ? clear : solid,
              solid,
              fadeRight ? clear : solid,
            ],
            stops: const [0, 0.5, 1],
          ),
        ),
      ),
    );
  }
}

/// The outlined primary action — an accent border on transparent, never a fill.
class OutlinedPill extends StatelessWidget {
  const OutlinedPill({
    super.key,
    required this.label,
    required this.onPressed,
    this.expand = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
    this.textStyle,
  });

  final String label;
  final VoidCallback onPressed;
  final bool expand;
  final EdgeInsets padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expand ? double.infinity : null,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: padding,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TRadius.pill),
            side: const BorderSide(color: TColor.accent),
          ),
          overlayColor: TColor.accent,
        ),
        child: Text(label, style: textStyle ?? TType.button),
      ),
    );
  }
}

/// A bare mono label used as navigation — CLOSE, BACK, ARCHIVE.
class MonoButton extends StatelessWidget {
  const MonoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = TColor.textMuted,
    this.icon,
    this.style,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 5),
          ],
          Text(label, style: style ?? TType.monoTop(color)),
        ],
      ),
    );
  }
}

/// The location chip on a photo: a blurred pill with an accent dot.
class PlaceChip extends StatelessWidget {
  const PlaceChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(TRadius.pill),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: TSpace.md, vertical: 5),
          color: TColor.bg.withValues(alpha: 0.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: TColor.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: TSpace.sm),
              Text(label, style: TType.monoPlace),
            ],
          ),
        ),
      ),
    );
  }
}

/// A photo box: rounded, clipped, elevated, with content stacked on top.
class PhotoFrame extends StatelessWidget {
  const PhotoFrame({
    super.key,
    required this.aspectRatio,
    required this.children,
    this.radius = TRadius.photo,
    this.shadows,
    this.clipOverflow = true,
  });

  final double aspectRatio;
  final List<Widget> children;
  final double radius;
  final List<BoxShadow>? shadows;

  /// Compose lets the rotate knob spill outside the frame.
  final bool clipOverflow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadows ?? TElevation.md,
      ),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: clipOverflow ? Clip.hardEdge : Clip.none,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// The Open-in bottom sheet.
Future<void> showOpenInSheet(
  BuildContext context, {
  required String title,
  required String artist,
  required String duration,
  required List<({String name, String scheme})> services,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: TColor.scrim,
    isScrollControlled: true,
    builder: (context) => _OpenInSheet(
      title: title,
      artist: artist,
      duration: duration,
      services: services,
    ),
  );
}

class _OpenInSheet extends StatelessWidget {
  const _OpenInSheet({
    required this.title,
    required this.artist,
    required this.duration,
    required this.services,
  });

  final String title;
  final String artist;
  final String duration;
  final List<({String name, String scheme})> services;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: TGradient.sheet,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(TRadius.photo)),
        boxShadow: [
          BoxShadow(color: TColor.border, spreadRadius: 1, blurRadius: 0),
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 44,
            offset: Offset(0, -18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, TSpace.xxl, 16, 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 52, height: 52, child: _SheetArtwork()),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TType.sheetTitle,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TType.rowArtist.copyWith(height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: TSpace.md),
                Text(duration, style: TType.monoTopLight(TColor.textFaint)),
              ],
            ),
            const SizedBox(height: TSpace.xl),
            Text('OPEN IN YOUR APP', style: TType.monoLabel(TColor.textFaint)),
            const SizedBox(height: TSpace.xl),
            for (final service in services) ...[
              _ServiceRow(name: service.name),
              if (service != services.last) const SizedBox(height: TSpace.sm),
            ],
          ],
        ),
      ),
    );
  }
}

class _SheetArtwork extends StatelessWidget {
  const _SheetArtwork();

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(TRadius.control),
        child: const ColoredBox(
          color: Color(0x14E9E9ED),
          child: SizedBox.expand(),
        ),
      );
}

class _ServiceRow extends StatefulWidget {
  const _ServiceRow({required this.name});

  final String name;

  @override
  State<_ServiceRow> createState() => _ServiceRowState();
}

class _ServiceRowState extends State<_ServiceRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      // Deep-linking lands with the music service integration.
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              _pressed ? TColor.accent.withValues(alpha: 0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(TRadius.tile),
          border: Border.all(color: _pressed ? TColor.accent : TColor.border),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(TSpace.sm),
              child: const ColoredBox(
                color: Color(0x14E9E9ED),
                child: SizedBox(width: 24, height: 24),
              ),
            ),
            const SizedBox(width: TSpace.lg),
            Expanded(child: Text(widget.name, style: TType.serviceRow)),
            Icon(
              PhosphorIcons.arrowSquareOut(),
              size: 14,
              color: TColor.accent,
            ),
          ],
        ),
      ),
    );
  }
}
