import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/models.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'equalizer.dart';
import 'photo_placeholder.dart';

/// The frosted "now playing" card that sits on the photo.
///
/// Sizing and rotation are applied by the caller ([PlacedPlayerCard]); this
/// widget only draws the card at whatever width it is given.
class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    required this.song,
    required this.frostColor,
    this.progress = 0.38,
  });

  final Song song;
  final Color frostColor;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(TRadius.card),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: frostColor,
            borderRadius: BorderRadius.circular(TRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(TSpace.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AspectRatio(
                  aspectRatio: 1,
                  child: ArtworkPlaceholder(radius: TRadius.control),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(1, TSpace.md, 1, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TType.cardTitle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        song.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TType.cardArtist,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(1, TSpace.md, 1, 7),
                  child: _Progress(value: progress),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1, right: 1, bottom: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Equalizer(),
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.textBright.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          PhosphorIcons.play(),
                          size: 10,
                          color: TColor.bg,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: TColor.textBright.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(TRadius.pill),
            ),
            child: const SizedBox.expand(),
          ),
          FractionallySizedBox(
            widthFactor: value,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: TColor.accentLight,
                borderRadius: BorderRadius.circular(TRadius.pill),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A [PlayerCard] positioned on a photo by its stored [CardPlacement].
///
/// Drop this inside a [Stack] that fills the photo box; [boxSize] is that
/// stack's laid-out size, which the percentage placement resolves against.
class PlacedPlayerCard extends StatelessWidget {
  const PlacedPlayerCard({
    super.key,
    required this.song,
    required this.placement,
    required this.boxSize,
    this.onTap,
    this.onPanStart,
    this.onPanUpdate,
    this.knob,
    this.onCardHeight,
  });

  final Song song;
  final CardPlacement placement;
  final Size boxSize;
  final VoidCallback? onTap;
  final GestureDragStartCallback? onPanStart;
  final GestureDragUpdateCallback? onPanUpdate;

  /// The rotate knob, shown only on Compose.
  final Widget? knob;

  /// Reports the card's laid-out height so the caller can clamp dragging.
  final ValueChanged<double>? onCardHeight;

  @override
  Widget build(BuildContext context) {
    final width = boxSize.width * placement.width / 100;

    Widget card = SizedBox(
      width: width,
      child: PlayerCard(song: song, frostColor: placement.frostColor),
    );

    if (onCardHeight != null) {
      card = _MeasureHeight(onHeight: onCardHeight!, child: card);
    }

    // The 1px edge and ambient shade have to sit outside the clip, so they go
    // on a wrapper rather than on the card's own decoration.
    Widget shaded = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TRadius.card),
        boxShadow: TElevation.card,
      ),
      child: card,
    );

    if (knob != null) {
      shaded = Stack(
        clipBehavior: Clip.none,
        children: [
          shaded,
          Positioned(right: -9, bottom: -9, child: knob!),
        ],
      );
    }

    return Positioned(
      left: boxSize.width * placement.x / 100,
      top: boxSize.height * placement.y / 100,
      child: Transform.rotate(
        angle: placement.rotation * 3.1415926535 / 180,
        child: GestureDetector(
          onTap: onTap,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          behavior: HitTestBehavior.opaque,
          child: shaded,
        ),
      ),
    );
  }
}

/// Reports its child's height after layout, once per change.
class _MeasureHeight extends StatefulWidget {
  const _MeasureHeight({required this.onHeight, required this.child});

  final ValueChanged<double> onHeight;
  final Widget child;

  @override
  State<_MeasureHeight> createState() => _MeasureHeightState();
}

class _MeasureHeightState extends State<_MeasureHeight> {
  final _key = GlobalKey();
  double? _last;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _key.currentContext?.findRenderObject() as RenderBox?;
      final height = box?.size.height;
      if (height != null && height != _last) {
        _last = height;
        widget.onHeight(height);
      }
    });
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
