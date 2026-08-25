import 'package:flutter/widgets.dart';

import '../data/seed.dart';
import '../models/models.dart';

/// The compose draft plus the day's post — one view-model for the whole flow,
/// as the handoff describes. Split per-screen once services land.
class AppState extends ChangeNotifier {
  bool _posted = false;
  Song _song = Seed.defaultSong;
  String _query = '';
  String _caption = '';
  CameraLens _lens = CameraLens.back;
  CardPlacement _placement = const CardPlacement();

  bool get posted => _posted;
  Song get song => _song;
  String get query => _query;
  String get caption => _caption;
  CameraLens get lens => _lens;
  CardPlacement get placement => _placement;

  /// The user's own post for today, once shared.
  Post? get myPost => _posted
      ? Post(
          author: 'You',
          place: '',
          time: 'JUST NOW',
          photoLabel: 'YOUR PHOTO',
          song: _song,
          caption: _caption.isEmpty ? 'no note' : _caption,
          placement: _placement,
          photoIndex: 0,
          isMine: true,
        )
      : null;

  /// Live filter on title + artist, case-insensitive.
  List<Song> get results {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return Seed.songs;
    return Seed.songs
        .where((s) => '${s.title} ${s.artist}'.toLowerCase().contains(q))
        .toList();
  }

  void selectSong(Song value) {
    _song = value;
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setCaption(String value) {
    _caption = value;
    notifyListeners();
  }

  void setLens(CameraLens value) {
    if (_lens == value) return;
    _lens = value;
    notifyListeners();
  }

  /// Drag: [dx] and [dy] are deltas as a fraction of the photo box, already
  /// converted by the gesture handler. [cardHeightPct] keeps the card inside
  /// the frame — it depends on the laid-out card, so the caller supplies it.
  void moveCard(double x, double y, {required double cardHeightPct}) {
    _placement = _placement.copyWith(
      x: x.clamp(0, 100 - _placement.width),
      y: y.clamp(0, (100 - cardHeightPct).clamp(0, 100)),
    );
    notifyListeners();
  }

  /// The rotate knob — wider range than the slider, per the handoff.
  void rotateCardByKnob(double degrees) {
    _placement = _placement.copyWith(rotation: degrees.clamp(-45, 45));
    notifyListeners();
  }

  void setSize(double value) {
    _placement = _placement.copyWith(width: value.clamp(26, 62));
    notifyListeners();
  }

  void setTilt(double value) {
    _placement = _placement.copyWith(rotation: value.clamp(-20, 20));
    notifyListeners();
  }

  void setFrost(double value) {
    _placement = _placement.copyWith(frost: value.clamp(6, 62));
    notifyListeners();
  }

  void publish() {
    _posted = true;
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!.notifier!;
  }

  /// Read without subscribing — for callbacks that only write.
  static AppState read(BuildContext context) {
    final scope =
        context.getInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!.notifier!;
  }
}
