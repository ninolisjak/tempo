import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../data/seed.dart';
import '../models/models.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/common.dart';
import '../widgets/equalizer.dart';
import '../widgets/photo_placeholder.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.bg,
      body: Column(
        children: [
          _Header(onBack: onBack),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.fromLTRB(TSpace.xxl, TSpace.xl, TSpace.xxl, 34),
              children: [
                Text(
                  Seed.monthLabel,
                  style: TType.monoLabel(TColor.textFaint),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: Seed.archive.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: TSpace.md,
                    mainAxisSpacing: TSpace.md,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) =>
                      _ArchiveTile(day: Seed.archive[index]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(TSpace.xxl, 52, TSpace.xxl, TSpace.xl),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.17, -1),
          end: Alignment(0.17, 1),
          colors: [TColor.section0, TColor.section1, TColor.section2],
          stops: [0, 0.6, 1],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MonoButton(
                label: 'FEED',
                onPressed: onBack,
                color: TColor.accentLight,
                icon: PhosphorIcons.arrowLeft(),
              ),
              Text('ARCHIVE', style: TType.monoTopLight(TColor.textMuted)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TRadius.card),
                    boxShadow: const [
                      BoxShadow(
                        color: TColor.neutral700,
                        spreadRadius: 1,
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const ArtworkPlaceholder(
                    radius: TRadius.card,
                    opacity: 0.6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Seed.ownerName, style: TType.displayL),
                    const SizedBox(height: 5),
                    Text(
                      '${Seed.ownerHandle} · ${Seed.ownerDays} DAYS · '
                      '${Seed.ownerStreak} STREAK',
                      style: TType.monoHandle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TSpace.xl),
          const _MostPlayed(),
        ],
      ),
    );
  }
}

class _MostPlayed extends StatelessWidget {
  const _MostPlayed();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TSpace.lg, vertical: 9),
      decoration: BoxDecoration(
        color: TColor.bg.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(TRadius.tile),
        border: Border.all(color: TColor.border),
      ),
      child: Row(
        children: [
          const Equalizer(
            height: 13,
            color: TColor.accent,
            period: TMotion.equalizerSlow,
            stagger: Duration(milliseconds: 300),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'Most played this month · ',
                style: TType.mostPlayed,
                children: [
                  TextSpan(
                    text: Seed.mostPlayed,
                    style: TType.mostPlayed.copyWith(color: TColor.accentSoft),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchiveTile extends StatelessWidget {
  const _ArchiveTile({required this.day});

  final ArchiveDay day;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showOpenInSheet(
        context,
        title: day.song.title,
        artist: day.song.artist,
        duration: day.song.duration,
        services: [
          for (final s in Seed.services) (name: s.name, scheme: s.scheme),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TRadius.tile),
          boxShadow: const [
            BoxShadow(color: TColor.line, spreadRadius: 1, blurRadius: 0),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TRadius.tile),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PhotoPlaceholder(index: day.photoIndex, animate: false),
              Positioned(
                top: TSpace.sm,
                left: TSpace.md,
                child: Text(day.day, style: TType.tileDay),
              ),
              Positioned(
                left: 5,
                right: 5,
                bottom: 5,
                child: _SongBar(title: day.song.title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SongBar extends StatelessWidget {
  const _SongBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(TSpace.sm),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: TSpace.xs),
          color: TColor.bg.withValues(alpha: 0.52),
          child: Row(
            children: [
              const SizedBox(
                width: 12,
                height: 12,
                child: ArtworkPlaceholder(radius: 2),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TType.tileSong,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
