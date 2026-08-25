import 'package:flutter/material.dart';

import '../data/seed.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/common.dart';
import '../widgets/halo.dart';
import '../widgets/photo_placeholder.dart';
import '../widgets/player_card.dart';
import '../widgets/tempo_logo.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key, required this.onPost, required this.onArchive});

  final VoidCallback onPost;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final myPost = state.myPost;

    return Scaffold(
      backgroundColor: TColor.bg,
      body: Stack(
        children: [
          Column(
            children: [
              _Header(onStreakTap: onArchive),
              Expanded(
                child: ListView(
                  // Captions clear the bottom bar.
                  padding: const EdgeInsets.only(top: TSpace.xxl, bottom: 128),
                  children: [
                    if (myPost != null) _OwnPost(post: myPost),
                    for (final post in Seed.posts) _PostCard(post: post),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Content fades out into the bar rather than meeting it hard.
                SizedBox(
                  height: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          TColor.bg.withValues(alpha: 0),
                          TColor.bg,
                        ],
                      ),
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
                _BottomBar(onPost: onPost, onArchive: onArchive),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onStreakTap});

  final VoidCallback onStreakTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(TSpace.xxl, 60, TSpace.xxl, 16),
      decoration: const BoxDecoration(gradient: TGradient.header),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TempoLockup(),
          const SizedBox(height: TSpace.xxl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Seed.weekday, style: TType.monoKicker),
                  const SizedBox(height: 7),
                  // The numeral and the month/year block share a bottom edge,
                  // as the CSS baseline alignment produces.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(Seed.dayNumber, style: TType.dateXL),
                      const SizedBox(width: TSpace.md),
                      Text(
                        '${Seed.monthName}\n${Seed.year}',
                        style: TType.dateSide,
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: onStreakTap,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${Seed.ownerStreak}', style: TType.streak),
                    const SizedBox(height: 5),
                    Text(
                      'DAY STREAK',
                      style: TType.monoLabel(TColor.textMuted).copyWith(
                        letterSpacing: 9 * 0.12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _FriendRail(),
        ],
      ),
    );
  }
}

class _FriendRail extends StatelessWidget {
  const _FriendRail();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: Seed.friends.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) => _FriendAvatar(Seed.friends[index]),
      ),
    );
  }
}

class _FriendAvatar extends StatelessWidget {
  const _FriendAvatar(this.friend);

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    final posted = friend.postedToday;

    return SizedBox(
      width: 48,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: posted ? TGradient.postedRim : null,
              color: posted ? null : TColor.line,
            ),
            child: Opacity(
              opacity: posted ? 1 : 0.55,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: TGradient.avatar,
                ),
                child: SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: TSpace.md),
          Text(
            friend.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TType.monoFriend(
              posted ? TColor.accentSoft : TColor.textFaint,
            ),
          ),
        ],
      ),
    );
  }
}

/// The user's own post, inserted at the top with a JUST NOW kicker.
class _OwnPost extends StatelessWidget {
  const _OwnPost({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(TSpace.xl, 0, TSpace.xl, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('YOU · JUST NOW', style: TType.monoNow),
              const SizedBox(width: TSpace.md),
              const Expanded(child: FadingRule(fadeLeft: false)),
            ],
          ),
          const SizedBox(height: 9),
          _PostPhoto(post: post, drift: TMotion.driftOwn),
          const SizedBox(height: 10),
          Text(post.caption, style: TType.body),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(TSpace.xl, 0, TSpace.xl, 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(post.author, style: TType.name),
              const SizedBox(width: 9),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: FadingRule(),
                ),
              ),
              const SizedBox(width: 9),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(post.time, style: TType.monoMeta(TColor.textFaint)),
              ),
            ],
          ),
          const SizedBox(height: 9),
          _PostPhoto(post: post),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(post.caption, style: TType.body)),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  post.song.duration,
                  style: TType.monoMeta(TColor.neutral700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostPhoto extends StatelessWidget {
  const _PostPhoto({required this.post, this.drift = TMotion.driftPhoto});

  final Post post;
  final Duration drift;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxSize = Size(constraints.maxWidth, constraints.maxWidth * 5 / 4);

        return PhotoFrame(
          aspectRatio: 4 / 5,
          children: [
            PhotoPlaceholder(index: post.photoIndex, drift: drift),
            Center(
              child: Text(
                post.photoLabel,
                style: TType.monoPhoto(
                  TColor.textBright.withValues(alpha: post.isMine ? 0.42 : 0.4),
                ),
              ),
            ),
            if (post.place.isNotEmpty)
              Positioned(
                top: 11,
                left: 12,
                child: PlaceChip(label: post.place),
              ),
            PlacedPlayerCard(
              song: post.song,
              placement: post.placement,
              boxSize: boxSize,
              onTap: () => showOpenInSheet(
                context,
                title: post.song.title,
                artist: post.song.artist,
                duration: post.song.duration,
                services: [
                  for (final s in Seed.services)
                    (name: s.name, scheme: s.scheme),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onPost, required this.onArchive});

  final VoidCallback onPost;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, TSpace.xl, 20, 30),
      decoration: BoxDecoration(
        color: TColor.bg,
        border: Border(
          top: BorderSide(color: TColor.border.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text('FEED', style: TType.monoNav(TColor.text)),
          ),
          const SizedBox(width: TSpace.xl),
          Expanded(child: _PostCta(onPost: onPost)),
          const SizedBox(width: TSpace.xl),
          SizedBox(
            width: 52,
            child: GestureDetector(
              onTap: onArchive,
              behavior: HitTestBehavior.opaque,
              child: Text(
                'ARCHIVE',
                textAlign: TextAlign.right,
                style: TType.monoNav(TColor.textFaint),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCta extends StatelessWidget {
  const _PostCta({required this.onPost});

  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    return Halo(
      borderRadius: BorderRadius.circular(TRadius.pill),
      child: GestureDetector(
        onTap: onPost,
        child: Container(
          height: 46,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: TSpace.xxl),
          decoration: BoxDecoration(
            color: TColor.surface,
            borderRadius: BorderRadius.circular(TRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: TColor.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 9),
              Text('Post today', style: TType.cta),
            ],
          ),
        ),
      ),
    );
  }
}
