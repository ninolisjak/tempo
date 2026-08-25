import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/common.dart';
import '../widgets/photo_placeholder.dart';
import '../widgets/player_card.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({
    super.key,
    required this.onBack,
    required this.onShare,
  });

  final VoidCallback onBack;
  final VoidCallback onShare;

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  late final TextEditingController _caption;

  /// The card's laid-out height as a percentage of the photo box — needed to
  /// clamp vertical dragging, and only known after layout.
  double _cardHeightPct = 0;

  /// Drag bookkeeping, in photo-box percentage units.
  double _dragX = 0;
  double _dragY = 0;

  /// Knob bookkeeping.
  Offset _knobCenter = Offset.zero;
  double _knobStartAngle = 0;
  double _knobStartRotation = 0;

  final _photoKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _caption = TextEditingController(
      text: AppStateScope.read(context).caption,
    );
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final placement = state.placement;

    return Scaffold(
      backgroundColor: TColor.bg,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(TSpace.xxl, 54, TSpace.xxl, TSpace.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MonoButton(label: 'BACK', onPressed: widget.onBack),
                Text(
                  'DRAG · KNOB ROTATES',
                  style: TType.monoTopLight(TColor.textFaint),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  TSpace.xxl, TSpace.sm, TSpace.xxl, 12),
              children: [
                KeyedSubtree(
                  key: _photoKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boxSize = Size(
                          constraints.maxWidth, constraints.maxWidth * 5 / 4);

                      return PhotoFrame(
                        aspectRatio: 4 / 5,
                        clipOverflow: false,
                        shadows: TElevation.sm,
                        children: [
                          const PhotoPlaceholder(index: 0, animate: false),
                          Center(
                            child: Text(
                              'YOUR PHOTO',
                              style: TType.monoPhoto(
                                TColor.textBright.withValues(alpha: 0.4),
                                tracking: 0.16,
                              ),
                            ),
                          ),
                          PlacedPlayerCard(
                            song: state.song,
                            placement: placement,
                            boxSize: boxSize,
                            onCardHeight: (height) =>
                                _cardHeightPct = height / boxSize.height * 100,
                            onPanStart: (_) {
                              _dragX = placement.x;
                              _dragY = placement.y;
                            },
                            onPanUpdate: (details) {
                              _dragX += details.delta.dx / boxSize.width * 100;
                              _dragY += details.delta.dy / boxSize.height * 100;
                              state.moveCard(
                                _dragX,
                                _dragY,
                                cardHeightPct: _cardHeightPct,
                              );
                              // Keep the accumulator in step with the clamp so
                              // the card does not drift once it hits an edge.
                              _dragX = state.placement.x;
                              _dragY = state.placement.y;
                            },
                            knob: _RotateKnob(
                              onPanStart: (details) {
                                _knobCenter = _cardCenter(boxSize, state);
                                _knobStartAngle = _angleTo(
                                  details.globalPosition,
                                  _knobCenter,
                                );
                                _knobStartRotation = state.placement.rotation;
                              },
                              onPanUpdate: (details) {
                                final now = _angleTo(
                                  details.globalPosition,
                                  _knobCenter,
                                );
                                final delta =
                                    (now - _knobStartAngle) * 180 / math.pi;
                                state.rotateCardByKnob(
                                  (_knobStartRotation + delta).roundToDouble(),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: TSpace.xl),
                _SliderRow(
                  label: 'SIZE',
                  value: placement.width,
                  min: 26,
                  max: 62,
                  readout: '${placement.width.round()}%',
                  onChanged: state.setSize,
                ),
                const SizedBox(height: 7),
                _SliderRow(
                  label: 'TILT',
                  value: placement.rotation.clamp(-20, 20),
                  min: -20,
                  max: 20,
                  readout: '${placement.rotation.round()}°',
                  onChanged: state.setTilt,
                ),
                const SizedBox(height: 7),
                _SliderRow(
                  label: 'FROST',
                  value: placement.frost,
                  min: 6,
                  max: 62,
                  readout: '${placement.frost.round()}%',
                  onChanged: state.setFrost,
                ),
                const SizedBox(height: 9),
                _CaptionField(
                  controller: _caption,
                  onChanged: state.setCaption,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
                TSpace.xxl, TSpace.lg, TSpace.xxl, 32),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: TColor.line)),
            ),
            child: OutlinedPill(
              label: 'Share with friends',
              onPressed: widget.onShare,
              expand: true,
              padding: const EdgeInsets.symmetric(vertical: TSpace.xl),
              textStyle: TType.buttonLarge,
            ),
          ),
        ],
      ),
    );
  }

  /// The card's centre in global coordinates, which the knob rotates around.
  Offset _cardCenter(Size boxSize, AppState state) {
    final box = _photoKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return Offset.zero;
    final origin = box.localToGlobal(Offset.zero);
    final p = state.placement;
    final width = boxSize.width * p.width / 100;
    final height = boxSize.height * _cardHeightPct / 100;
    return origin +
        Offset(
          boxSize.width * p.x / 100 + width / 2,
          boxSize.height * p.y / 100 + height / 2,
        );
  }

  double _angleTo(Offset point, Offset center) =>
      math.atan2(point.dy - center.dy, point.dx - center.dx);
}

class _RotateKnob extends StatelessWidget {
  const _RotateKnob({required this.onPanStart, required this.onPanUpdate});

  final GestureDragStartCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TColor.bg,
          shape: BoxShape.circle,
          border: Border.all(color: TColor.accent),
        ),
        child: Icon(
          PhosphorIcons.arrowCounterClockwise(),
          size: 11,
          color: TColor.accentSoft,
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.readout,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String readout;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TRadius.tile),
        border: Border.all(color: TColor.line),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            child: Text(
              label,
              style: TType.monoLabel(TColor.textFaint)
                  .copyWith(letterSpacing: 9 * 0.1),
            ),
          ),
          const SizedBox(width: TSpace.lg),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackShape: const RectangularSliderTrackShape(),
                // Whole-step values without the divisions tick marks, which
                // the design does not have.
                tickMarkShape: SliderTickMarkShape.noTickMark,
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                divisions: (max - min).round(),
                onChanged: onChanged,
              ),
            ),
          ),
          const SizedBox(width: TSpace.lg),
          SizedBox(
            width: 34,
            child: Text(
              readout,
              textAlign: TextAlign.right,
              style: TType.monoValue,
            ),
          ),
        ],
      ),
    );
  }
}

class _CaptionField extends StatelessWidget {
  const _CaptionField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 54),
      padding: const EdgeInsets.all(TSpace.lg),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(TRadius.tile),
        border: Border.all(color: TColor.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: null,
        style: TType.input,
        cursorColor: TColor.accent,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintText: 'Add a note (optional)',
          hintStyle: TType.input.copyWith(color: TColor.textFaint),
        ),
      ),
    );
  }
}
