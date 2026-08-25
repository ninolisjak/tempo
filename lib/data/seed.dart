import '../models/models.dart';

/// Placeholder content standing in for the feed, music and archive services.
abstract final class Seed {
  static const fadeIntoYou =
      Song(title: 'Fade Into You', artist: 'Mazzy Star', duration: '4:56');
  static const cranes =
      Song(title: 'Cranes in the Sky', artist: 'Solange', duration: '4:12');
  static const tapeLoop =
      Song(title: 'Tape Loop', artist: 'Morcheeba', duration: '5:03');
  static const nightshift =
      Song(title: 'Nightshift', artist: 'Lucy Dacus', duration: '4:22');
  static const weightless =
      Song(title: 'Weightless', artist: 'Marconi Union', duration: '8:08');
  static const motionSickness = Song(
      title: 'Motion Sickness', artist: 'Phoebe Bridgers', duration: '3:48');
  static const rylan =
      Song(title: 'Rylan', artist: 'Sufjan Stevens', duration: '4:31');

  static const songs = <Song>[
    fadeIntoYou,
    cranes,
    tapeLoop,
    nightshift,
    weightless,
    motionSickness,
    rylan,
  ];

  static const defaultSong = nightshift;

  static const posts = <Post>[
    Post(
      author: 'Maya',
      place: 'OCEAN BEACH',
      time: '06:14',
      photoLabel: 'MORNING SURF',
      song: fadeIntoYou,
      caption: 'first light, nobody out yet',
      placement: CardPlacement(x: 50, y: 44, width: 40, rotation: -3, frost: 30),
      photoIndex: 0,
    ),
    Post(
      author: 'Theo',
      place: 'MISSION ROOFTOP',
      time: '13:02',
      photoLabel: 'ROOF LUNCH',
      song: tapeLoop,
      caption: 'roof lunch, no notes',
      placement: CardPlacement(x: 9, y: 12, width: 36, rotation: 3, frost: 24),
      photoIndex: 1,
    ),
    Post(
      author: 'Ines',
      place: 'BERNAL HEIGHTS',
      time: '19:41',
      photoLabel: 'GOLDEN HOUR',
      song: cranes,
      caption: 'walked home the long way',
      placement: CardPlacement(x: 33, y: 55, width: 46, rotation: -6, frost: 40),
      photoIndex: 2,
    ),
  ];

  static const friends = <Friend>[
    Friend(name: 'MAYA', postedToday: true),
    Friend(name: 'THEO', postedToday: true),
    Friend(name: 'INES', postedToday: true),
    Friend(name: 'JUNO', postedToday: false),
    Friend(name: 'PABLO', postedToday: false),
    Friend(name: 'RIA', postedToday: false),
  ];

  static const archive = <ArchiveDay>[
    ArchiveDay(day: '24', song: rylan, photoIndex: 0),
    ArchiveDay(day: '23', song: weightless, photoIndex: 1),
    ArchiveDay(day: '22', song: tapeLoop, photoIndex: 2),
    ArchiveDay(day: '21', song: nightshift, photoIndex: 0),
    ArchiveDay(day: '20', song: motionSickness, photoIndex: 1),
    ArchiveDay(day: '19', song: fadeIntoYou, photoIndex: 2),
    ArchiveDay(day: '18', song: cranes, photoIndex: 0),
    ArchiveDay(day: '17', song: rylan, photoIndex: 1),
    ArchiveDay(day: '16', song: weightless, photoIndex: 2),
  ];

  static const services = <MusicService>[
    MusicService(name: 'Spotify', scheme: 'spotify:track:'),
    MusicService(name: 'Apple Music', scheme: 'music://'),
    MusicService(name: 'YouTube Music', scheme: 'youtubemusic://'),
  ];

  // The profile shown on Archive.
  static const ownerName = 'Sam Ortiz';
  static const ownerHandle = '@samo';
  static const ownerDays = 128;
  static const ownerStreak = 31;
  static const mostPlayed = 'Mazzy Star';

  // Today, as the prototype fixes it.
  static const weekday = 'TUESDAY';
  static const dayNumber = '25';
  static const monthName = 'August';
  static const year = '2026';
  static const monthLabel = 'AUGUST';
}
