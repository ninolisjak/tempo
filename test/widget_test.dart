import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tempo/app.dart';
import 'package:tempo/screens/camera_screen.dart';

/// The equalizer, halo and photo drift loop forever, so `pumpAndSettle` never
/// returns. Pump a fixed number of frames instead — enough for a route change.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Feed → Camera → Song search.
Future<void> toSongSearch(WidgetTester tester) async {
  await tester.tap(find.text('Post today'));
  await settle(tester);
  await tester.tap(find.byKey(CameraScreen.shutterKey));
  await settle(tester);
}

/// The default 800x600 test window is nothing like a phone; these screens are
/// laid out for a tall, narrow viewport.
Future<void> pumpPhone(WidgetTester tester) async {
  tester.view
    ..physicalSize = const Size(402 * 3, 874 * 3)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const TempoApp());
  await settle(tester);
}

void main() {
  testWidgets('Feed is the entry screen', (tester) async {
    await pumpPhone(tester);

    expect(find.text('tempo'), findsOneWidget);
    expect(find.text('TUESDAY'), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
    expect(find.text('Post today'), findsOneWidget);
    expect(find.text('Maya'), findsOneWidget);

    // A 4:5 photo per post means only the first is above the fold. The friend
    // rail scrolls too, so name the feed list explicitly.
    await tester.scrollUntilVisible(
      find.text('Theo'),
      400,
      scrollable: find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      ),
    );
    expect(find.text('Theo'), findsOneWidget);
  });

  testWidgets('Post today opens the camera', (tester) async {
    await pumpPhone(tester);

    await tester.tap(find.text('Post today'));
    await settle(tester);

    expect(find.text('BACK LENS'), findsOneWidget);
    expect(find.text('BACK CAMERA'), findsOneWidget);
  });

  testWidgets('Lens toggle switches the viewfinder label', (tester) async {
    await pumpPhone(tester);

    await tester.tap(find.text('Post today'));
    await settle(tester);
    await tester.tap(find.text('FRONT'));
    await settle(tester);

    expect(find.text('FRONT LENS'), findsOneWidget);
    expect(find.text('FRONT CAMERA'), findsOneWidget);
  });

  testWidgets('Shutter reaches song search with the default track selected',
      (tester) async {
    await pumpPhone(tester);
    await toSongSearch(tester);

    expect(find.text("What's on\nrepeat today?"), findsOneWidget);
    expect(find.text('SELECTED · NIGHTSHIFT'), findsOneWidget);
    expect(find.text('Fade Into You'), findsOneWidget);
  });

  testWidgets('Search filters on title and artist', (tester) async {
    await pumpPhone(tester);
    await toSongSearch(tester);

    await tester.enterText(find.byType(TextField), 'mazzy');
    await settle(tester);

    expect(find.text('Fade Into You'), findsOneWidget);
    expect(find.text('Tape Loop'), findsNothing);
  });

  testWidgets('Selecting a track updates the footer', (tester) async {
    await pumpPhone(tester);
    await toSongSearch(tester);

    await tester.tap(find.text('Tape Loop'));
    await settle(tester);

    expect(find.text('SELECTED · TAPE LOOP'), findsOneWidget);
  });

  testWidgets('Compose shows the handoff defaults', (tester) async {
    await pumpPhone(tester);
    await toSongSearch(tester);

    await tester.tap(find.text('Next'));
    await settle(tester);

    expect(find.text('DRAG · KNOB ROTATES'), findsOneWidget);
    expect(find.text('SIZE'), findsOneWidget);
    expect(find.text('TILT'), findsOneWidget);
    expect(find.text('FROST'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.text('-3°'), findsOneWidget);
    expect(find.text('26%'), findsOneWidget);
  });

  testWidgets('Sharing inserts your post at the top of the feed',
      (tester) async {
    await pumpPhone(tester);
    await toSongSearch(tester);

    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'a note');
    await settle(tester);
    await tester.tap(find.text('Share with friends'));
    await settle(tester);

    expect(find.text('YOU · JUST NOW'), findsOneWidget);
    expect(find.text('a note'), findsOneWidget);
  });

  testWidgets('Streak opens the archive', (tester) async {
    await pumpPhone(tester);

    await tester.tap(find.text('ARCHIVE'));
    await settle(tester);

    expect(find.text('Sam Ortiz'), findsOneWidget);
    expect(find.text('@samo · 128 DAYS · 31 STREAK'), findsOneWidget);
    expect(find.text('AUGUST'), findsOneWidget);
  });
}
