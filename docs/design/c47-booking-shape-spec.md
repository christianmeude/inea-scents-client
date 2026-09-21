# C47 — Booking schedule densify shape-spec (docs-only, owner gate before merge)

Status: SPEC — no lib/ or test/ changes. C48 implements after owner APPROVED delta.
Branch: `c47-booking-shape-spec` off `main@ddee6dc`.
Ticket: C47 (spec/UX). Acceptance: owner-APPROVED delta, cal+time grid, sticky rail, mobile stack+collapsed, sticky CTA bar, docs-only.

Grilled shape (locked, do not relitigate): web = calendar+time side-by-side
grid with summary sticky rail; mobile = stacked with summary collapsed;
sticky bottom bar carries total + Proceed.

## 1. Side-by-side grid contract (web ≥768px)

One schedule grid replaces the current loose flow column. Two columns +
one sticky rail; single breakpoint at 768px (matches `TabHeader.narrowBreakpoint`
and `MobileClampScroll.mobileMaxWidth`):

- COL A — calendar: `ReservationCalendarPanel` as-is (delegates to
  `IneaCalendar`; availability polling, booked-day disabling, month paging
  unchanged). No new props in this spec.
- COL B — time + pax: time-picker section and pax readonly row extracted
  from `ReservationDetailsPanel` §2–§3 only. Package summary card (§1)
  does NOT move into the grid — it already duplicates the summary rail's
  proper-noun line and stays retired from the schedule step (C7 precedent:
  inclusions live once, in the rail).
- RAIL — `OrderSummaryPanel` as the sticky summary rail (`isSticky: true`,
  pinned at top of its column, scrolls with the one page-level scroll —
  P7 rule unchanged). CTA text on schedule step stays `Proceed to Payment`
  (no amount-in-CTA; amount suffix applies to `Confirm & Pay` only).
- Densify tokens: grid gap 24px desktop (keep current `SizedBox(width: 24)`);
  tablet 768–1024 keeps current stacked flow + rail row (gap 14 vertical)
  — densify narrows padding only, never introduces a nested column scroll
  (P7: ONE page-level `SingleChildScrollView`, key `app_shell_scroll_view`,
  maxWidth 1200 cap unchanged).
- Gate: `canProceedFromSchedule()` remains the single proceed authority;
  failure surfaces via `showAppError` (C30: banner wide / SnackBar narrow).
  Default time `14:00:00` prefill and `showTimePicker` stay.

## 2. Mobile stacked contract (<768px)

Vertical stack under one clamp scroll; summary collapsed; sticky bottom bar
owns the conversion:

- ORDER: calendar → time picker → pax readonly row → collapsed summary.
  Current `_buildCurrentStep` step-2 order (calendar, product name, pax row,
  time card) reorders so date+time are adjacent (densify intent).
- COLLAPSED SUMMARY: one line — `{pax} PAX · {date} · {time}` (the
  test-pinned one-liner, verbatim) + `Total {₱}` row. Full
  `OrderSummaryPanel` (inclusions/freebies/venue rows) does NOT render
  inline on the schedule step; expands only via disclosure (C48 detail).
  No second CTA inside the collapsed card.
- STICKY BOTTOM BAR: `Total {₱} + Proceed` button, h50 pill (matches current
  mobile CTA), full-width, lives OUTSIDE the scroll view
  (`Scaffold.bottomNavigationBar`, not inside the `Column`) so C40 clamp
  never fights stickiness. Label: `Proceed` on schedule (step 2),
  `Proceed to Payment` step 3, `Confirm & Pay {₱}` step 4 — current labels
  preserved. Disabled + spinner while `isLoading`; re-entrancy guard
  (`_submitting`) unchanged.
- The in-column full-width button in `_buildMobileLayout` retires, replaced
  by the bar (one CTA, never two on screen).

## 3. Coverage — what happens to existing schedule widgets

Inspected at `main@ddee6dc` (paths: `lib/screens/booking_screen.dart`
schedule sections, `lib/widgets/reservation_calendar_panel.dart`,
`reservation_details_panel.dart`, `order_summary_panel.dart`).

| # | Widget / section | Current state (inspected) | C48 target |
|---|---|---|---|
| 1 | `ReservationCalendarPanel` (+ `IneaCalendar`) | Thin alias (`selectedDate`/`onDateSelected` only); `IneaCalendar` owns polling/disabling/`showChrome` (C28) | REUSE as-is in grid COL A and mobile stack top. No prop changes in this spec |
| 2 | `ReservationDetailsPanel` §1 package summary card | Product name + starting-at + PAX-range line | RETIRE from schedule step (duplicates rail proper-noun line); product name survives only as mobile stack section label |
| 3 | `ReservationDetailsPanel` §2 pax readonly row | `pax_readonly_row` + `pax_change_link` → `_goToStep(2)` in-flow (C6) | ADAPT: move into grid COL B / mobile stack; keys + in-flow Change preserved, no router jump |
| 4 | `ReservationDetailsPanel` §3 time picker | `event_time_picker_button`, inline `showTimePicker`, `TimeSlot.display` | ADAPT: move into grid COL B / mobile stack adjacent to calendar; keys + prefill preserved |
| 5 | `OrderSummaryPanel` | `Your Booking`, pinned one-liner, full date/time/venue rows, `InclusionsList`, `₱`-only total, CTA | REUSE as web/tablet sticky rail unchanged; mobile schedule step shows COLLAPSED variant only (§2) |
| 6 | Desktop flow `Row` (`desktop_reservation_columns_view`) | Calendar + details `Expanded` pair, gap 24, flex-2 flow + flex-1 rail | ADAPT into §1 grid (COL A + COL B); flex ratio + gaps unchanged |
| 7 | Tablet stacked flow + rail | `Column` (calendar, gap 14, details) + rail row | KEEP; densify padding only |
| 8 | Mobile `_buildCurrentStep` step 2 + in-column CTA | Calendar → name → pax → time; full-width h50 pill CTA in-column | REORDER per §2; CTA migrates to sticky bottom bar, in-column button retires |

Out of scope: payment/details/checkout steps, `DesktopPaymentPanel`,
timeline, header, contact fields — untouched.

## 4. Rules (AAA + C42 + C40 interplay)

- AAA: all text on `CardSurfaces.title/body` tokens (C36 7:1); theme
  `ElevatedButton` supplies CTA contrast (C31, no per-screen hex/plum text).
  Touch: bar CTA ≥48px (current 50/46 pass); `pax_change_link` keeps its
  48px minimum context. No new font faces — pairing B fallbacks untouched.
- C42 `TabHeader`: booking flow is NOT a tab screen (C41 §2 out-of-scope
  list) — keeps its own Back + C27 Schedule/Details/Payment timeline header.
  C48 must NOT adopt `TabHeader` here; title-scale rule (26/22) does not apply.
- C40 clamp: `MobileClampScroll.physicsOf(context)` stays on the page scroll
  (<768px clamp, desktop platform-default). Sticky bar outside the scroll
  view; rail `isSticky` is top-pinned-in-column, never `position: fixed` —
  no nested scrolls (P7).
- Terms per CONTEXT.md: Booking (never order/reservation in copy), Pax,
  Time Slot. Class names keep `Reservation*`/`Order*` per ADR 0008
  zero-ripple rule — copy only.
- Zero lib/test edits in this ticket; C48 carries all widget moves.

## 5. C48 handoff (what C48 will implement — not this ticket)

1. Web ≥768px: grid COL A (calendar) + COL B (time + pax readonly) + sticky
   rail (`OrderSummaryPanel`, `isSticky: true`); retire details §1 card.
2. Mobile <768px: reorder step-2 stack (calendar → time → pax → collapsed
   summary one-liner + total); migrate CTA to sticky bottom bar
   (`Scaffold.bottomNavigationBar`, h50 pill, labels per §2).
3. Keep keys (`reservation_calendar_panel`, `pax_readonly_row`,
   `pax_change_link`, `event_time_picker_button`, `mobile_inea_calendar`),
   `canProceedFromSchedule()` gate + C30 errors, `14:00:00` prefill.
4. Proof: `dart analyze`, schedule-step widget tests (grid order, collapsed
   one-liner verbatim, single CTA, bar outside scroll), `code-review` green;
   full suite pre-merge. Mobile clamp + desktop physics verified unchanged.

Gate: owner replies `APPROVED C47 BY owner` in the track log; C48 implements
this shape only. Any grid/rail/bar deviation needs a fresh APPROVED delta.
