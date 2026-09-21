# C41 — Unified header config + font pairing spec (docs-only, owner gate before merge)

Status: SPEC — no lib/ or test/ changes. C42 implements after owner APPROVED delta.
Branch: `c41-unified-header-spec` off `main@bca41b3`.
Ticket: C41 (spec/UX). Acceptance: owner-APPROVED delta, slots/coverage/pairing, docs-only.

Grilled spec (locked, do not relitigate): strict two-slot header, 5 tab screens,
title scales <768px (rule for C42), 3 Google-Fonts pairings for the owner gate.

## 1. Slot contract (strict, zero actions wired initially)

One shared header widget (name TBD in C42) with exactly two slots:

- LEFT — title + count: title (screen name) + one count/subtitle line
  (e.g. `My Bookings` / `3 bookings`). Screens without a meaningful count
  render their existing subtitle string in the count slot (no layout shift).
- RIGHT — one trailing-action slot: reserved, renders empty until a future
  ticket wires an action. Zero actions wired initially — no buttons, no
  dead affordances (C22/C43 precedent: dead tune-filter, brand-title AppBar,
  and book-another CTA were all removed, not left disabled).

Rules: no third slot, no per-screen AppBar resurrection, no actions smuggled
into the left slot. Dark-aware via `CardSurfaces.title/body` (P7), never
per-screen hex.

## 2. Coverage — 5 tab screens only

Canonical tab list verified in `lib/config/router.dart` `StatefulShellRoute`
branches (branch order = nav index): Home (`/home`), Packages (`/packages`),
Bookings (`/bookings`), Calendar (`/calendar`), Profile (`/profile`).
(Note: `TopNavBar._getCurrentIndex` maps the same 0–4 order: home, packages,
bookings, calendar, profile. The ticket shorthand "Home, Packages, Calendar,
Bookings, Profile" is the same set; branch order above is authoritative.)

Out of scope: `/booking/:id`, `/bookings/:id`, `/profile/edit`,
`/profile/password`, auth/splash routes — they keep their own bars/titles.

| # | Screen (route) | Current header state (inspected) | C42 target |
|---|---|---|---|
| 1 | Home (`home_screen.dart`) | No AppBar. Mobile-only (`<768px`) centered `AppLogo`; no title, no count. Desktop: `TopNavBar` only. Body starts at `NextStepCard`. | Title `Home` + subtitle in count slot; trailing slot empty. Mobile logo row retires (brand lives in `TopNavBar` on tablet/desktop; mobile keeps shell chrome only). |
| 2 | Packages (`packages_screen.dart`) | `appBar: null` (C22). Body title `Our Collections` 24/w600/ls 0.2 + subtitle `Discover your perfect scent.` 13. No count, no action. | Title `Our Collections` + count slot (e.g. `N Pax Choices` or subtitle fallback); trailing slot empty. |
| 3 | Calendar (`calendar_screen.dart`) | `appBar: null` (C22). Body title `Availability` 26/w600/ls 0.1 + subtitle `Choose a date…` 13. Pull-to-refresh is the refresh path (no header button). | Title `Availability` + subtitle in count slot; trailing slot empty. |
| 4 | Bookings (`my_bookings_screen.dart`) | No AppBar. C43 header is already title+count only: `My Bookings` 26/w600/ls −0.3 + `N booking(s)` 13. Empty state keeps its own CTA to `/packages`. Reference implementation. | Adopt as-is into the shared widget; trailing slot empty. |
| 5 | Profile (`profile_screen.dart`) | `appBar: null` (C22). Body title `My Profile` 24/w600/ls 0.2 + subtitle `Manage your account…` 13. Avatar card + settings below; muted logo footer. | Title `My Profile` + subtitle in count slot; trailing slot empty. |

Unification deltas for C42: 24 vs 26 title sizes converge on one token (§3);
`letterSpacing` converges (0.2 / 0.1 / −0.3 today); padding converges on
`fromLTRB(20, 18, 20, 30)`-family with max-width 1200 cap (Packages uses
`fromLTRB(20, 12, 20, 24)`; Calendar desktop caps at 1000 — header aligns to
the 1200 shell cap regardless).

## 3. Title-scale rule (for C42)

Single breakpoint, matching `ResponsiveAppShell.tabletBreakpoint` and the
existing `< 768` checks (`home_screen.dart`, `packages_screen.dart`):

- Viewport ≥ 768px: title 26px / w600, count/subtitle 13px.
- Viewport < 768px: title 22px / w600, count/subtitle 13px (subtitle never scales).
- Single-line title with `overflow: ellipsis`; count line fixed height so the
  header box is identical with subtitle text or `N item(s)` text.
- Letter-spacing: one value (recommend −0.3, the C43 Bookings value) both sizes.
- No `FittedBox` scaling of the title; step change only (predictable tests).

## 4. Current font usage (investigated)

- Body/UI: `GoogleFonts.figtreeTextTheme` in `theme.dart` light + dark
  (`lib/config/theme.dart:83,342`). Explicit `GoogleFonts.figtree` call sites
  in `custom_text_field.dart`, auth screens. System fallback today: implicit
  (no explicit `fontFamilyFallback` anywhere in `lib/`).
- Brand only: `JosefinSans` (INEA wordmark) + `GreatVibes` (Scents script) in
  `top_nav_bar.dart` `_BrandLogo`, `app_logo.dart`, auth screens. Never body copy.
- C22 top-nav pill: 18px icon + 13px label (`top_nav_bar.dart:270,277`),
  w500 (w700 selected), ls 0.4, plain `TextStyle` (not a Google Font) — out of
  scope for this pairing spec, cited as the size anchor for the 13px count line.
- Zero-serif rule (current): no serif face in Flutter UI — grep for
  Playfair/Cormorant/Lora/Merriweather/serif finds only the `sans-serif`
  fallback in the `checkout_window_web.dart` shim. Any serif title (options B/C
  below) is therefore a DESIGN delta needing the owner APPROVED gate.
- Tests: every widget test sets `GoogleFonts.config.allowRuntimeFetching =
  false`, so fetched fonts never load under test — layout must hold on
  fallback stacks (§5). Any new face must be smoke-rendered with fetching
  disabled before merge of the implementing ticket.

## 5. Three title/body pairing proposals (owner picks one)

All bodies stay Figtree except option C (full swap). Every stack ends in
explicit system fallbacks that hold with font-fetch disabled.

- **A — Status quo (no new fonts, no serif, no gate risk).**
  Title: Josefin Sans 600 (brand echo) / Body: Figtree 400–600.
  Fallbacks — title: `'Josefin Sans', 'Segoe UI', Verdana, sans-serif`;
  body: `'Figtree', -apple-system, 'Segoe UI', Roboto, sans-serif`.
  Pros: zero fetch cost, zero serif-rule delta, tests already green on this.
  Cons: least "concierge" of the three; geometric title next to humanist body.

- **B — Recommended: Cormorant Garamond + Figtree (serif delta).**
  Title: Cormorant Garamond 600 / Body: Figtree 400–600 (unchanged).
  Fallbacks — title: `'Cormorant Garamond', Georgia, 'Times New Roman', serif`;
  body: as in A. Fetch-disabled rendering falls back to Georgia — x-height
  is smaller, so C42 must set `height: 1.15` on the title and keep the
  single-line ellipsis rule (§3) so Georgia never wraps where Cormorant fits.
  Pros: Elegant Concierge serif voice, body untouched, one new family.
  Cons: requires owner APPROVED serif delta (zero-serif rule today).

- **C — Playfair Display + Inter (full swap, highest cost).**
  Title: Playfair Display 600 / Body: Inter 400–600 (replaces Figtree).
  Fallbacks — title: `'Playfair Display', Georgia, serif`;
  body: `'Inter', -apple-system, 'Segoe UI', Roboto, sans-serif`.
  Pros: strongest editorial contrast, Inter's tabular figures suit counts.
  Cons: two new families, full body-font migration, largest regression
  surface; needs APPROVED delta + full-suite visual pass.

Gate: owner replies `APPROVED <A|B|C> BY owner` (per AGENTS.md §8 gate token)
in the track log; C42 implements the picked pairing only, with
`fontFamilyFallback` stacks committed in code and a fetch-disabled smoke test.

## 6. C42 handoff (what C42 will implement — not this ticket)

1. New shared header widget (title+count left, one trailing slot right,
   trailing empty) + per-screen adoption on the 5 tab screens per table §2.
2. Title-scale rule §3 (26 ≥768px / 22 <768px, subtitle fixed 13, ls −0.3).
3. Owner-picked pairing from §5 with explicit fallback stacks; smoke-render
   with `allowRuntimeFetching = false`.
4. Convergence: one title size/letter-spacing/padding token; header aligns to
   the 1200 shell cap on all 5 screens.
5. Proof: `dart analyze`, full suite, `code-review` green; no new actions
   wired (trailing slot stays empty until a future ticket claims it).
