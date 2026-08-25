import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// The mark: a gradient rounded square holding three bottom-aligned bars at
/// 52% / 100% / 72% of the tall bar.
class TempoMark extends StatelessWidget {
  const TempoMark({super.key, this.size = 26});

  final double size;

  @override
  Widget build(BuildContext context) {
    final barWidth = size * (4 / 44);
    final gap = size * (3 / 44);
    final tall = size * 0.45;
    final bottomPad = size * 0.24;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.only(bottom: bottomPad),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * (13 / 44)),
        gradient: TGradient.logo,
        boxShadow: [
          BoxShadow(
            color: TColor.accentLight.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 0,
          ),
          BoxShadow(
            color: TColor.accentDeep.withValues(alpha: 0.45),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _bar(barWidth, tall * 0.52, TColor.logoBar),
          SizedBox(width: gap),
          _bar(barWidth, tall, TColor.textBright),
          SizedBox(width: gap),
          _bar(barWidth, tall * 0.72, TColor.logoBar),
        ],
      ),
    );
  }

  Widget _bar(double w, double h, Color color) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(w),
        ),
      );
}

/// Mark + wordmark + the baseline-aligned accent dot.
class TempoLockup extends StatelessWidget {
  const TempoLockup({super.key, this.markSize = 26, this.wordSize = 21});

  final double markSize;
  final double wordSize;

  @override
  Widget build(BuildContext context) {
    final dot = wordSize * (4 / 21);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TempoMark(size: markSize),
        SizedBox(width: markSize * (9 / 26)),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('tempo', style: TType.wordmark(wordSize)),
            SizedBox(width: wordSize * (1.5 / 21)),
            Padding(
              padding: EdgeInsets.only(bottom: wordSize * (3 / 21)),
              child: Container(
                width: dot,
                height: dot,
                decoration: const BoxDecoration(
                  color: TColor.accentLight,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
