---
target: lib/screens/login_screen.dart
total_score: 22
max_score: 36
na_heuristics: 10
p0_count: 0
p1_count: 2
timestamp: 2026-08-23T23-39-55Z
slug: lib-screens-login-screen-dart
---
#### Design Specificity Verdict

The interface attempts a sophisticated, ethereal mesh gradient but implements it using fixed-pixel blurred containers (e.g., `width: 800`, `width: 600`). On a wide web viewport, these blobs space out elegantly. On a narrow mobile screen (~390px), they completely overlap. Because the blobs use complementary/complex colors (Peach, Mauve, Gray-Purple, Pale Rose, Dark Plum), stacking them forces the colors to blend into a muddy, indistinct wash.

Regarding the logo: You are not seeing two versions of the codebase. You are seeing the consequences of platform-dependent fallbacks and fixed scaling:
1. `fontFamily: 'cursive'` relies on the OS default. Web browsers might use Comic Sans or a web-standard cursive, while iOS uses Snell Roundhand and Android uses Dancing Script.
2. The letter spacing (`letterSpacing: 9.0`) and the pixel offset (`Offset(-25, 20)`) are hardcoded, causing the "RIGHT OVERFLOWED" layout error on web when the screen is too narrow to contain the fixed `fontSize: 72`.

**Deterministic scan**: The CLI detector found 0 issues, which is expected as it primarily targets web markup (HTML/Astro/React) rather than Flutter Dart UI code.
**Visual overlays**: Skipped due to Flutter architecture not supporting standard DOM injection.

#### Overall Impression
A beautiful concept hampered by non-responsive execution. The styling intent is clear and elegant, but hardcoded pixel values and missing font assets break the illusion across different devices and platforms.

#### What's Working
- **Mood and Tone**: The color palette (when not entirely overlapped) feels premium, soft, and aligned with a fragrance brand.
- **Micro-interactions**: The custom glassmorphic text fields with focus state animations show excellent attention to detail.

#### Priority Issues

- **[P1] Inconsistent Logo Typography and Layout Overflow**
  - **Why it matters**: Relying on the OS `cursive` fallback font guarantees the brand will look different on every platform. Hardcoded pixel offsets and large font sizes cause layout overflows (the yellow/black warning tape).
  - **Fix**: Load a specific custom font asset (e.g., Google Fonts 'Great Vibes') so the brand is identical everywhere. Wrap the logo in a `FittedBox` or use responsive scaling to prevent overflow on narrow screens.
  - **Suggested command**: /impeccable typeset

- **[P1] Muddy Mobile Background**
  - **Why it matters**: Fixed pixel sizes (`width: 800`) for background blobs cause them to completely overlap on mobile screens, destroying the intended gradient and leaving a murky wash.
  - **Fix**: Use relative sizing (e.g., `MediaQuery.of(context).size.width * 0.8`) or layout constraints for the blobs so they scale down proportionally on mobile.
  - **Suggested command**: /impeccable adapt

- **[P2] Form Accessibility & Friction**
  - **Why it matters**: The login fields lack AutofillHints, making mobile login tedious. The white text on a semi-transparent background may lose contrast depending on which blob sits behind it.
  - **Fix**: Add `autofillHints: const [AutofillHints.email]` and `AutofillHints.password` to the fields. Ensure a minimum contrast ratio by slightly tweaking the field background opacity.
  - **Suggested command**: /impeccable harden

#### Persona Red Flags

**Casey (Distracted Mobile User)**: 
- The muddy background makes the contrast on the input fields unpredictable. 
- Form fields lack `autofillHints`, forcing tedious manual typing on a mobile keyboard. 
- The 'Log In' button text is quite small (`fontSize: 12`) for a primary mobile action.

**Jordan (First-Timer)**: 
- The visible yellow/black layout overflow error on the web (if the screen is resized) and the inconsistent font could make the site feel broken or untrustworthy, reducing confidence to register.

#### Minor Observations
- The 'Forgot password?' link has an empty `onTap` handler.
- 8 simultaneous heavy blur filters (`ImageFilter.blur(sigmaX: 60, sigmaY: 60)`) might cause scrolling or rendering performance issues on lower-end Android devices.

#### Questions to Consider
- Does the brand need the logo to be constructed from raw text, or could we use an SVG asset to guarantee 100% fidelity and easier scaling?
- Should the mesh gradient be a static pre-rendered image on mobile to save performance, rather than computing 8 heavy blur filters live?
