import 'package:flutter/widgets.dart';

@immutable
class Song {
  const Song({
    required this.title,
    required this.artist,
    required this.duration,
  });

  final String title;
  final String artist;
  final String duration;

  @override
  bool operator ==(Object other) =>
      other is Song && other.title == title && other.artist == artist;

  @override
  int get hashCode => Object.hash(title, artist);
}

/// Where the poster placed the player card on the photo.
///
/// This is content, not presentation — it is persisted with the post.
@immutable
class CardPlacement {
  const CardPlacement({
    this.x = 50,
    this.y = 44,
    this.width = 40,
    this.rotation = -3,
    this.frost = 26,
  });

  /// Left edge, as a percentage of the photo's width.
  final double x;

  /// Top edge, as a percentage of the photo's height.
  final double y;

  /// Card width, as a percentage of the photo's width. Range 26–62.
  final double width;

  /// Degrees, clamped to ±45 by the knob and ±20 by the slider.
  final double rotation;

  /// Background opacity of the card, as a percentage. Range 6–62.
  final double frost;

  Color get frostColor =>
      const Color(0xFF1C1E2C).withValues(alpha: frost / 100);

  CardPlacement copyWith({
    double? x,
    double? y,
    double? width,
    double? rotation,
    double? frost,
  }) =>
      CardPlacement(
        x: x ?? this.x,
        y: y ?? this.y,
        width: width ?? this.width,
        rotation: rotation ?? this.rotation,
        frost: frost ?? this.frost,
      );
}

@immutable
class Post {
  const Post({
    required this.author,
    required this.place,
    required this.time,
    required this.photoLabel,
    required this.song,
    required this.caption,
    required this.placement,
    required this.photoIndex,
    this.isMine = false,
  });

  final String author;
  final String place;
  final String time;

  /// Placeholder copy shown centred on the photo until real capture lands.
  final String photoLabel;
  final Song song;
  final String caption;
  final CardPlacement placement;

  /// Index into the placeholder gradient set.
  final int photoIndex;
  final bool isMine;
}

@immutable
class Friend {
  const Friend({required this.name, required this.postedToday});

  final String name;
  final bool postedToday;
}

@immutable
class ArchiveDay {
  const ArchiveDay({
    required this.day,
    required this.song,
    required this.photoIndex,
  });

  final String day;
  final Song song;
  final int photoIndex;
}

enum CameraLens { back, front }

@immutable
class MusicService {
  const MusicService({required this.name, required this.scheme});

  final String name;

  /// Deep-link scheme used when opening the track in the listener's app.
  final String scheme;
}
