# Handoff: Tempo — one photo, one song, once a day

## Overview
Tempo is a mobile social app. Each user posts **one photo per day** and attaches a **song of the day**. The song renders as a small frosted "now playing" card placed *on top of* the photo — the poster drags, rotates, resizes and sets the frost level of that card, so every post is composed rather than templated. Viewers tap the card to open the track in their own music app (Spotify / Apple Music / YouTube Music).

Flows covered by the prototype: **Feed → Camera (front/back) → Song search → Compose (place the player) → Post**, plus **Archive** (your past days) and the **Open in…** bottom sheet.

## About the Design Files
The files in this bundle are **design references authored in HTML/CSS** — prototypes that show intended look, layout, and behavior. They are **not production code to port line-by-line**.

The target here is **Flutter**. Recreate these screens as Flutter widgets using the app's existing architecture (state management, theming, routing, design tokens). If the Flutter project doesn't exist yet, scaffold it conventionally (`ThemeData` + a `tokens.dart`, `go_router` or `Navigator 2.0`, whatever state solution the team prefers) and build the screens against that.

## Fidelity
**High fidelity.** Colors, type sizes, radii, spacing, and interaction behavior are final and should be matched closely. The photographs and album artwork are intentional **placeholders** (diagonal-stripe gradients with mono labels) — swap in real camera output and artwork from the music API.

## Design system
The visual language is the **Nocturne** design system: dark blue-grey ground, a single blurple accent used as line/glow (never as a large fill), outlined actions, compact spacing, 8px radii, Inter for UI. Display type is **Bricolage Grotesque** (a deliberate addition for headlines and the wordmark). Metadata is **JetBrains Mono**.

## Design Tokens

### Color
| Token | Hex | Use |
| --- | --- | --- |
| bg | `#161826` | app ground |
| surface | `#1C1E2C` | inputs, sheets, bottom bar |
| surfaceAlt | `#232532` | selected list row |
| section | `#262A60` → `#1E2140` → `#161826` | header band gradient (170deg) |
| text | `#E9E9ED` | primary text |
| textBright | `#F3F5FE` | display type, on-photo text |
| textMuted | `#9397AB` | secondary text |
| textFaint | `#75798C` | mono labels, placeholders |
| line | `#292B31` | hairline rules |
| border | `#3F424D` | control borders |
| accent | `#9184D9` | rings, dots, focus |
| accentLight | `#B5ABFC` | accent text/icons on dark, equalizer bars |
| accentSoft | `#D2CEFD` | button labels |
| accentDeep | `#5D5294` / `#796CBF` / `#423A6A` | logo gradient stops |
| neutral-700 | `#595D6C` | avatar gradient stop |

Never pure black/white. Elevation on this ground = 1px edge + ambient darkness:
- `elevSm`: `0 0 0 1px #3F424D`
- `elevMd`: `0 0 0 1px #3F424D, 0 20px 44px rgba(0,0,0,0.5)`
- `elevCard`: `0 0 0 1px rgba(243,245,254,0.20), 0 12px 30px rgba(0,0,0,0.5)` (the player card)

Flutter: shadows map to `BoxShadow`; the `0 0 0 1px` edge maps to `Border.all(width: 1, color: …)` or a `BoxShadow` with `spreadRadius: 1, blurRadius: 0`.

### Typography
| Role | Family | Size / weight / tracking |
| --- | --- | --- |
| Display XL (date "25") | Bricolage Grotesque | 54px / w600 / -0.05em / line-height 0.86 |
| Display L (wordmark, names, sheet title) | Bricolage Grotesque | 19–30px / w600 / -0.04em |
| Question headline ("What's on repeat today?") | Bricolage Grotesque | 30px / w600 / -0.035em / lh 1.02 |
| Body | Inter | 14px / w400 / lh 1.5 |
| List row title | Inter | 14px / w500 |
| Card title (on photo) | Inter | 12px / w500 |
| Card artist (on photo) | Inter | 10px / w400 |
| Meta / labels | JetBrains Mono | 9–11px / w400-500 / letter-spacing 0.10–0.16em / UPPERCASE |

Minimum on-screen size is 10px (mono labels, archive tile song names).

### Spacing & radii
Compact scale (0.7× density): 4 / 6 / 8 / 11 / 14 / 18 / 22 / 32.
Radii: `4` (artwork thumb), `8` (controls, list rows), `10–13` (logo tile, archive tiles), `12` (player card), `16` (photo, viewfinder), `999` (pills, avatars).

### Icons
**Phosphor** (regular weight): `play`, `magnifying-glass`, `arrow-counter-clockwise`, `arrow-left`, `arrow-square-out`. Flutter: `phosphor_flutter` package.

## Logo
Lockup = **mark + wordmark + accent dot**.
- Mark: rounded square (44px @ radius 13 in the panel; 26px @ radius 8 in-app) filled with `linear-gradient(150deg, #B5ABFC 0%, #796CBF 55%, #423A6A 100%)`, 1px `rgba(181,171,252,0.5)` edge, glow `0 6px 16px rgba(93,82,148,0.45)`. Inside, three bottom-aligned rounded bars (equalizer): heights 52% / 100% / 72% of the tall bar; outer two `#1A1C2B`, centre `#F3F5FE`; bar width 4px @44px tile, gap 3px, bottom padding 24% of tile.
- Wordmark: "tempo", Bricolage Grotesque w600, tracking -0.05em, lowercase, `#F3F5FE`, followed by a 7px `#B5ABFC` dot baseline-aligned (4px at small size).

Flutter: `Container` + `BoxDecoration(gradient: LinearGradient(...))` with a `Row` of three `Container`s; or export as an `SvgPicture` asset for reuse in the launcher icon.

## Screens / Views

### 1. Feed
- **Purpose:** see today's posts from friends, chronological.
- **Header band** (`padding: 60/18/16`, gradient `170deg #262A60 → #1E2140 55% → #161826`):
  - Logo lockup row (26px mark + 21px wordmark), 18px bottom margin.
  - Left: mono `TUESDAY` (9.5px, 0.16em, `#B5ABFC`), then the date lockup: `25` at 54px w600 beside `August / 2026` at 13px Bricolage `#9397AB`.
  - Right: tappable streak — `31` (22px Bricolage `#D2CEFD`) over mono `DAY STREAK` (9px `#9397AB`). Navigates to Archive.
  - **Friend rail:** horizontal scroll, 16px gaps. Each item: 44px circle, 2px padding ring whose fill is `linear-gradient(160deg,#B5ABFC,#5D5294)` when the friend posted today and `#292B31` when not; inner circle is the avatar (`radial-gradient(120% 120% at 30% 20%, #595D6C, #2B2741 70%)` placeholder, opacity 0.55 when not posted). Below: mono 10px name, `#D2CEFD` posted / `#75798C` not. No pulse animation.
- **Post card** (list, 34px vertical gaps, 14px side padding):
  - Row: friend name as 26px Bricolage w600 headline, a 1px rule that fades to transparent at both ends, mono 9.5px timestamp.
  - Photo: `aspect-ratio 4/5`, radius 16, `elevMd`. Placeholder = diagonal 115° stripe overlay over an indigo/plum gradient, animating with a slow 26s "drift" (scale 1.04 → 1.12, translate -2%/-1.5%, alternate) — in Flutter a very slow `AnimatedScale`/`Transform` loop, or skip for real photos.
  - Location chip, top-left: mono 8.5px uppercase, 4px accent dot, `rgba(22,24,38,0.5)` + blur 10, pill.
  - **Player card** — see "Player card" below. Positioned per post as % of the photo box (left/top/width) with a rotation.
  - Below: caption 14px Inter `#CFD3E5` + mono track duration `#595D6C` right-aligned.
- **Bottom bar** (absolute, `padding 14/20/30`, solid `#161826` with a `rgba(63,66,77,0.5)` 1px top rule, gradient fade above it): mono `FEED` (52px fixed), centre CTA pill "● Post today" (height 46, `#1C1E2C` fill, `#D2CEFD` label, nowrap, breathing accent halo animation `3.2s`), mono `ARCHIVE` (52px fixed, → Archive). Feed scroller has 128px bottom padding so captions clear the bar.
- **After posting**, the user's own post is inserted at the top with a `YOU · JUST NOW` mono kicker and a fading rule.

### 2. Camera
- Ground `#121422`. Top row: mono `CLOSE`, `BACK LENS` / `FRONT LENS` label, spacer.
- Viewfinder: `aspect-ratio 3/4`, radius 16, placeholder gradient with drift, centre mono label `BACK CAMERA` / `FRONT CAMERA`, and a big translucent `25 AUG` date stamp bottom-left (30px Bricolage at `rgba(243,245,254,0.28)`).
- Lens toggle: pill segmented control, 1px `#3F424D` border; selected chip fill `#3F424D`, label `#E9E9ED`; unselected label `#75798C`.
- Shutter: 76px circle, transparent, animated accent halo; inner 58px circle `linear-gradient(160deg,#B5ABFC,#796CBF)`. Tap → Song search.

### 3. Song search
- Headline `What's on / repeat today?` (30px Bricolage, two lines).
- Search field: pill, `#1C1E2C`, 1px `#3F424D` edge, Phosphor magnifying-glass 14px `#75798C`, Inter 13.5px input. Filters title + artist, case-insensitive, live.
- Result rows: 42px artwork placeholder (radius 6), title 14px w500, artist 11.5px `#9397AB`, mono duration right. **Selected** row: fill `#232532`, 1px `#9184D9` ring, duration `#D2CEFD`.
- Footer: mono `SELECTED · <TRACK>` left, outlined pill `Next` right → Compose.

### 4. Compose — place the player
- Top row: mono `BACK`, mono `DRAG · KNOB ROTATES`.
- Photo box (4/5, radius 16) is the drag container.
- **Player card** is absolutely positioned inside it at `left: x%`, `top: y%`, `width: w%`, `transform: rotate(r deg)`.
  - Drag anywhere on the card → updates x/y, clamped so the card stays inside the photo (x ≤ 100 − w, y ≤ 100 − cardHeight%).
  - **Rotate knob**: 20px circle at the card's bottom-right (`right/bottom: -9px`), 1px accent border, `#161826` fill, Phosphor `arrow-counter-clockwise`. Dragging it rotates the card around its centre; clamped ±45°, and it stays in sync with the TILT slider.
- Three control rows (radius 10, 1px `#292B31` edge, mono 9px label, native range input, mono value on the right):
  - `SIZE` 26–62 (% of photo width), default **40**
  - `TILT` −20…20 (deg), default **−3**
  - `FROST` 6–62 (%) → card background `rgba(28,30,44, frost/100)`, default **26**
- Caption `TextField`: `#1C1E2C`, 1px `#3F424D`, radius 10, min height 54, Inter 13.5px, placeholder "Add a note (optional)".
- Footer: outlined pill `Share with friends`, full width → sets `posted = true`, returns to Feed.

### 5. Archive
- Header band (same gradient): mono `← FEED` (Phosphor arrow-left) and `ARCHIVE`; 56px rounded avatar; name `Sam Ortiz` 30px Bricolage; mono `@samo · 128 DAYS · 31 STREAK`; a "most played" strip — animated 3-bar equalizer + `Most played this month · Mazzy Star` (accent name).
- Grid: 3 columns, 8px gaps, tiles `aspect-ratio 3/4`, radius 10, 1px `#292B31`. Day number top-left (15px Bricolage), and a mini song bar at the bottom (12px artwork chip + 10px Inter title, `rgba(22,24,38,0.52)` + blur 10). Tap → Open-in sheet.

### 6. Open in… (bottom sheet)
- Scrim `rgba(12,13,22,0.66)`; tapping it closes.
- Sheet: `linear-gradient(180deg,#20233A,#1C1E2C 40%)`, top radius 16, `padding 18/16/34`, `elevMd` inverted (`0 -18px 44px rgba(0,0,0,0.6)`).
- Header: 52px artwork, title 19px Bricolage, artist 11.5px `#9397AB`, mono duration.
- mono `OPEN IN YOUR APP`, then three rows (Spotify, Apple Music, YouTube Music): 24px logo chip, 13.5px w500 label, Phosphor `arrow-square-out` accent. Hover/press: 1px accent ring + `rgba(145,132,217,0.10)` fill. In production these deep-link to the listener's preferred service (`spotify:track:…`, `music://`, `youtube music://`) with a web fallback.

## Player card (the core component)
Sits on the photo; size and position are user-set.
```
width: w% of photo   (default 40%, range 26–62%)
padding: 8
radius: 12
background: rgba(28,30,44, frost)   frost default 0.26
backdrop blur: 18px, saturate 1.3
edge: 1px rgba(243,245,254,0.20)   shadow: 0 12px 30px rgba(0,0,0,0.5)

[ artwork: 100% width, aspect 1, radius 8 ]
title   Inter 12 w500  #F3F5FE   (ellipsize, 1 line)
artist  Inter 10 w400  rgba(243,245,254,0.70)
progress: 2px track rgba(243,245,254,0.28), fill 38% #B5ABFC, radius 999
row: 3-bar equalizer (2px bars, #B5ABFC, 0.8s scaleY 0.3→1 loop, 0.25s stagger)
     + 24px play button, fill rgba(243,245,254,0.92), Phosphor play 10px #161826
```
Flutter: `BackdropFilter(filter: ImageFilter.blur(sigmaX:18,sigmaY:18))` inside a `ClipRRect`, wrapped in `Transform.rotate`, positioned with `Positioned` inside a `LayoutBuilder`-measured `Stack`. Drag = `GestureDetector.onPanUpdate` converting deltas to fractions of the stack size; rotate knob = second `GestureDetector` computing `atan2` against the card centre.

## Interactions & Behavior
- **Navigation:** Feed ⇄ Camera → Song → Compose → Feed; Feed ⇄ Archive. No modal stack beyond the sheet.
- **Camera lens toggle** switches the viewfinder label/placeholder only (prototype). Real build: `camera` package, front/back `CameraDescription`.
- **Shutter** advances to Song search (in production: capture, then advance).
- **Song search** filters live on title+artist; tapping a row selects it (single select) and updates the footer label.
- **Compose:** drag (pointer), rotate knob (pointer, ±45°, clamps + syncs the slider), three sliders, caption text field.
- **Post** inserts your post at the top of the feed with a "JUST NOW" kicker.
- **Tap any player card** (feed, own post, archive tile) → Open-in sheet for that track.
- **Animations:** equalizer bars 0.8–1.0s ease-in-out infinite alternate (staggered 0.25s); CTA/shutter halo 2.6–3.2s glow pulse; photo drift 18–26s alternate. Hover/press states everywhere use an accent tint; focus ring is 2px `#9184D9` at 2px offset.

## State Management
Single screen-level state object in the prototype; in Flutter this maps to one view-model per flow:
- `screen: feed | camera | song | compose | profile`
- `posted: bool` — whether today's post exists
- `song: {title, artist, duration}` — selected track (default: "Nightshift" / Lucy Dacus)
- `query: string` — search text
- `caption: string`
- `lens: back | front`
- `x, y, w: double` — player card placement, % of photo (default 50, 44, 40)
- `rotate: int` — degrees, −45…45 (default −3)
- `frost: int` — 6…62 (default 26)
- `sheet: {title, artist, duration} | null`

Data needed from services: friends list + today's posts (photo URL, place, time, caption, track, card placement), music search (title/artist/artwork/duration/service deep links), the user's archive by month, streak count. **Card placement (x, y, w, rotate, frost) must be persisted with the post** — it is content, not presentation.

## Assets
- **Photos & album artwork:** placeholders only (striped gradients). Real photos come from the camera; artwork from the music provider.
- **Icons:** Phosphor regular (`phosphor_flutter`).
- **Fonts:** Bricolage Grotesque (display), Inter (UI), JetBrains Mono (metadata) — all Google Fonts; bundle via `google_fonts` or as asset fonts.
- **Logo:** built from shapes (see "Logo"); no image asset needed, though an SVG/PNG export is worth generating for the launcher icon.

## Files
- `Tempo.dc.html` — the current design (all screens, all interactions). Open in a browser; the left panel jumps between screens.
- `ios-frame.jsx` / `support.js` — the phone bezel and runtime the prototype uses. Reference only; nothing to port.
- `nocturne/styles.css`, `nocturne/readme.md` — the Nocturne design system tokens and written guidance the palette comes from.
- Earlier iterations for context (not the target): `Daylist v4.dc.html` (previous naming/slim-bar player).
