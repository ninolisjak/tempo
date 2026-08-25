import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/common.dart';
import '../widgets/photo_placeholder.dart';

class SongSearchScreen extends StatefulWidget {
  const SongSearchScreen({
    super.key,
    required this.onRetake,
    required this.onNext,
  });

  final VoidCallback onRetake;
  final VoidCallback onNext;

  @override
  State<SongSearchScreen> createState() => _SongSearchScreenState();
}

class _SongSearchScreenState extends State<SongSearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: AppStateScope.read(context).query,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final results = state.results;

    return Scaffold(
      backgroundColor: TColor.bg,
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(TSpace.xxl, 54, TSpace.xxl, TSpace.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MonoButton(label: 'RETAKE', onPressed: widget.onRetake),
                    Text('2 / 3', style: TType.monoTopLight(TColor.textFaint)),
                  ],
                ),
                const SizedBox(height: 12),
                Text("What's on\nrepeat today?", style: TType.question),
                const SizedBox(height: 12),
                _SearchField(
                  controller: _controller,
                  onChanged: state.setQuery,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              itemCount: results.length,
              separatorBuilder: (_, __) => const SizedBox(height: TSpace.sm),
              itemBuilder: (context, index) {
                final song = results[index];
                return _ResultRow(
                  song: song,
                  selected: state.song == song,
                  onTap: () => state.selectSong(song),
                );
              },
            ),
          ),
          _Footer(song: state.song, onNext: widget.onNext),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: TSpace.lg),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(TRadius.pill),
        border: Border.all(color: TColor.border),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.magnifyingGlass(),
            size: 14,
            color: TColor.textFaint,
          ),
          const SizedBox(width: TSpace.md),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TType.input.copyWith(height: 1),
              cursorColor: TColor.accent,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: 'Song or artist',
                hintStyle: TType.input.copyWith(
                  height: 1,
                  color: TColor.textFaint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.song,
    required this.selected,
    required this.onTap,
  });

  final Song song;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding:
            const EdgeInsets.symmetric(horizontal: TSpace.lg, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? TColor.surfaceAlt : Colors.transparent,
          borderRadius: BorderRadius.circular(TRadius.tile),
          border: Border.all(color: selected ? TColor.accent : TColor.line),
        ),
        child: Row(
          children: [
            const ArtworkPlaceholder(
              radius: TSpace.sm,
              opacity: 0.5,
              size: 42,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TType.rowTitle,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TType.rowArtist,
                  ),
                ],
              ),
            ),
            const SizedBox(width: TSpace.md),
            Text(
              song.duration,
              style: TType.monoMeta(
                selected ? TColor.accentSoft : TColor.textFaint,
                size: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.song, required this.onNext});

  final Song song;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(TSpace.xxl, TSpace.lg, TSpace.xxl, 32),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: TColor.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'SELECTED · ${song.title.toUpperCase()}',
              style: TType.monoFooter,
            ),
          ),
          const SizedBox(width: TSpace.lg),
          OutlinedPill(label: 'Next', onPressed: onNext),
        ],
      ),
    );
  }
}
