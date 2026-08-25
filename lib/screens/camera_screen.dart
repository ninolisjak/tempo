import 'package:flutter/material.dart';

import '../data/seed.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/common.dart';
import '../widgets/halo.dart';
import '../widgets/photo_placeholder.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({
    super.key,
    required this.onClose,
    required this.onCapture,
  });

  /// The shutter is a bare circle with no label, so tests address it by key.
  static const shutterKey = Key('camera.shutter');

  final VoidCallback onClose;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isFront = state.lens == CameraLens.front;

    return Scaffold(
      backgroundColor: TColor.bgCamera,
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(TSpace.xxl, 54, TSpace.xxl, TSpace.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MonoButton(label: 'CLOSE', onPressed: onClose),
                Text(
                  isFront ? 'FRONT LENS' : 'BACK LENS',
                  style: TType.monoTop(TColor.text),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(TSpace.xl, TSpace.sm, TSpace.xl, 0),
              child: Center(child: _Viewfinder(isFront: isFront)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, TSpace.xxl, 24, 38),
            child: Column(
              children: [
                _LensToggle(
                  lens: state.lens,
                  onChanged: state.setLens,
                ),
                const SizedBox(height: 16),
                _Shutter(onPressed: onCapture),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Viewfinder extends StatelessWidget {
  const _Viewfinder({required this.isFront});

  final bool isFront;

  @override
  Widget build(BuildContext context) {
    return PhotoFrame(
      aspectRatio: 3 / 4,
      shadows: const [
        BoxShadow(color: TColor.line, spreadRadius: 1, blurRadius: 0),
      ],
      children: [
        const PhotoPlaceholder(index: 0, drift: TMotion.driftViewfinder),
        Center(
          child: Text(
            isFront ? 'FRONT CAMERA' : 'BACK CAMERA',
            style: TType.monoPhoto(
              TColor.textBright.withValues(alpha: 0.5),
              tracking: 0.16,
            ),
          ),
        ),
        Positioned(
          left: TSpace.xl,
          bottom: TSpace.xl,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(Seed.dayNumber, style: TType.stamp),
              Text(
                ' AUG',
                style: TType.monoTopLight(
                  TColor.textBright.withValues(alpha: 0.28),
                ).copyWith(fontSize: 11, letterSpacing: 11 * 0.1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LensToggle extends StatelessWidget {
  const _LensToggle({required this.lens, required this.onChanged});

  final CameraLens lens;
  final ValueChanged<CameraLens> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TRadius.pill),
        border: Border.all(color: TColor.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _chip('BACK', CameraLens.back),
          const SizedBox(width: TSpace.xs),
          _chip('FRONT', CameraLens.front),
        ],
      ),
    );
  }

  Widget _chip(String label, CameraLens value) {
    final selected = lens == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: TSpace.md),
        decoration: BoxDecoration(
          color: selected ? TColor.border : Colors.transparent,
          borderRadius: BorderRadius.circular(TRadius.pill),
        ),
        child: Text(
          label,
          style: TType.monoTop(selected ? TColor.text : TColor.textFaint)
              .copyWith(letterSpacing: 10 * 0.1),
        ),
      ),
    );
  }
}

class _Shutter extends StatelessWidget {
  const _Shutter({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: CameraScreen.shutterKey,
      onTap: onPressed,
      child: Halo(
        borderRadius: BorderRadius.circular(TRadius.pill),
        period: TMotion.haloShutter,
        child: Container(
          width: 76,
          height: 76,
          alignment: Alignment.center,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: TGradient.shutter,
            ),
          ),
        ),
      ),
    );
  }
}
