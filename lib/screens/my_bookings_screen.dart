import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../providers/index.dart';
import '../models/index.dart';
import '../utils/peso.dart';
import '../widgets/index.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  // ============================================================
  // INEA COLORS
  // ============================================================

  // P6 (G5): shared ambient triple so the capped local gradient melts
  // into the shell's full-bleed ambient instead of stopping at 1200px.
  static const Color backgroundTop = Color(0xFFF8E9DF);
  static const Color backgroundMiddle = Color(0xFFD8B0BA);
  static const Color backgroundBottom = Color(0xFFB78C9C);

  static const Color primaryColor = AppTheme.primary;
  static const Color primaryLight = Color(0xFF95647E);

  static const Color textColor = Color(0xFF633E50);
  static const Color secondaryTextColor = Color(0xFF765867);

  static const Color borderColor = Color(0xFFE4CBD2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsProvider);
    // C43: header is title+count only (book-another removed);
    // empty state keeps its own CTA to /packages.

    // P7: no explicit color — flat theme scaffold background.
    // C43: header shows title+count only (no book-another affordance).
    return Scaffold(

      // ============================================================
      // BODY (P7: flat theme background; decorative gradient removed)
      // ============================================================
      body: SafeArea(
        child: bookingsAsync.when(
          data: (bookings) {
            if (bookings.isEmpty) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // C42: unified header over the empty state.
                        const TabHeader(
                          title: 'My Bookings',
                          count: '0 bookings',
                        ),
                        const Expanded(child: _EmptyBookings()),
                      ],
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              color: primaryColor,
              onRefresh: () => ref.refresh(bookingsProvider.future),
              child: SingleChildScrollView(
                // C40: clamp overscroll on mobile (<768px); SDK default
                // (stretch Android / bounce iOS) displaced content past edge.
                // Desktop/web physics untouched (null = platform default).
                physics: MobileClampScroll.physicsOf(context),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ==================================================
                          // PAGE HEADER (C42: unified header, trailing
                          // empty — C43 title+count adopted as-is)
                          // ==================================================
                          TabHeader(
                            title: 'My Bookings',
                            count: '${bookings.length} '
                                '${bookings.length == 1 ? 'booking' : 'bookings'}',
                          ),

                          const SizedBox(height: 20),

                          // ==================================================
                          // BOOKING CARDS (P7 impeccable adapt: single
                          // column on mobile, pairs on web — rows size to
                          // the tallest card, so nothing overflows)
                          // ==================================================
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final cards = bookings
                                  .map(
                                    (booking) => _BookingCard(booking: booking),
                                  )
                                  .toList();
                              if (constraints.maxWidth <=
                                  ResponsiveAppShell.tabletBreakpoint) {
                                return Column(children: cards);
                              }
                              final rows = <Widget>[];
                              for (var i = 0; i < cards.length; i += 2) {
                                final pair = cards.sublist(
                                  i,
                                  (i + 2).clamp(0, cards.length),
                                );
                                rows.add(
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: pair[0]),
                                      if (pair.length > 1) ...[
                                        const SizedBox(width: 24),
                                        Expanded(child: pair[1]),
                                      ] else
                                        const Expanded(
                                          child: SizedBox.shrink(),
                                        ),
                                    ],
                                  ),
                                );
                                rows.add(const SizedBox(height: 2));
                              }
                              return Column(children: rows);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },

          // ======================================================
          // LOADING
          // ======================================================
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 2.5,
            ),
          ),

          // ======================================================
          // ERROR
          // ======================================================
          // P6 (Q6/Q8): shared friendly card; raw errors stay
          // in logs, never on screen.
          error: (error, stack) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ErrorStateCard(
                  title: 'Unable to load bookings',
                  message:
                      "We couldn't load your bookings. "
                      'Check your connection and try again.',
                  onRetry: () => ref.invalidate(bookingsProvider),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// BOOKING CARD
// ============================================================================

class _BookingCard extends ConsumerWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // C51: live flow subscription — the in-flight Booking's fresh Status
    // (flipped by poll/recheck) renders here with no list refresh. Any
    // other row keeps its cached copy.
    final flowBooking = ref.watch(
      bookingFlowProvider.select((s) => s.booking),
    );
    final live =
        (flowBooking != null &&
            flowBooking.id != null &&
            flowBooking.id == booking.id)
        ? flowBooking
        : booking;
    final status = live.status.toString();
    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),

      decoration: BoxDecoration(
        color: CardSurfaces.cardBg(context),
        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: CardSurfaces.cardBorder(context), width: 1),

        boxShadow: [
          BoxShadow(
            color: MyBookingsScreen.primaryColor.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================================
            // TOP ROW
            // ==========================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Booking icon
                Container(
                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color: CardSurfaces.chipBg(context),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Icon(
                    Icons.local_mall_outlined,
                    color: CardSurfaces.title(context),
                    size: 23,
                  ),
                ),

                const SizedBox(width: 13),

                // Booking reference
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BOOKING REFERENCE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: CardSurfaces.body(context),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        live.bookingReference ?? 'N/A',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: CardSurfaces.title(context),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Status
                _StatusBadge(status: status, color: statusColor),
              ],
            ),

            const SizedBox(height: 18),

            // ==========================================================
            // DIVIDER
            // ==========================================================
            Container(height: 1, color: CardSurfaces.cardBorder(context)),

            const SizedBox(height: 17),

            // ==========================================================
            // PACKAGE NAME
            // ==========================================================
            Text(
              live.package?.name ?? 'Unknown Pax Choice',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: CardSurfaces.title(context),
                letterSpacing: -0.2,
              ),
            ),

            const SizedBox(height: 18),

            // ==========================================================
            // EVENT DATE
            // ==========================================================
            _BookingDetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Event Date',
              value: live.eventDate?.toString().split(' ')[0] ?? 'N/A',
            ),

            const SizedBox(height: 11),

            // ==========================================================
            // VENUE
            // ==========================================================
            _BookingDetailRow(
              icon: Icons.location_on_outlined,
              label: 'Venue',
              value: live.venueAddress ?? 'N/A',
            ),

            const SizedBox(height: 11),

            // ==========================================================
            // PAX
            // ==========================================================
            _BookingDetailRow(
              icon: Icons.people_outline,
              label: 'PAX',
              value: live.pax == null
                  ? 'N/A'
                  : live.pax == 1
                  ? '1 PAX'
                  : '${live.pax} PAX',
            ),

            const SizedBox(height: 18),

            // ==========================================================
            // PRICE
            // ==========================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),

              decoration: BoxDecoration(
                color: CardSurfaces.chipBg(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: CardSurfaces.cardBorder(context)),
              ),

              child: Row(
                children: [
                  Text(
                    'Pax Choice Price',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: CardSurfaces.body(context),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // C25: price takes remaining width and ellipsizes
                  // instead of overflowing the row at 360px.
                  Expanded(
                    child: Text(
                      live.package != null
                          ? formatPeso(
                              live.package!.priceForPax(live.pax),
                            )
                          : 'N/A',
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: CardSurfaces.title(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// BOOKING DETAIL ROW
// ============================================================================

class _BookingDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _BookingDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,

          decoration: BoxDecoration(
            color: CardSurfaces.chipBg(context),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Icon(icon, size: 17, color: CardSurfaces.title(context)),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: CardSurfaces.body(context),
                  letterSpacing: 0.4,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: CardSurfaces.title(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// STATUS BADGE
// ============================================================================

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    // C68: chip appear on mount (fade + scale, layout-stable).
    return ChipAppear(
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),

      decoration: BoxDecoration(
        // C55: bolder fill + border so the semantic chip reads at 9px.
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.40), width: 1),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,

            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),

          const SizedBox(width: 5),

          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: color,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

// ============================================================================
// EMPTY BOOKINGS
// ============================================================================

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,

              decoration: BoxDecoration(
                color: CardSurfaces.chipBg(context),
                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: MyBookingsScreen.primaryColor.withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Icon(
                Icons.calendar_month_outlined,
                size: 42,
                // C36: title token (was 0xFF8B6B7C, fails 4.5).
                color: CardSurfaces.title(context),
              ),
            ),

            const SizedBox(height: 22),

            Text(
              'No bookings yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CardSurfaces.title(context),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Your perfume experiences and upcoming '
              'events will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: CardSurfaces.body(context),
              ),
            ),

            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: () {
                context.go('/packages');
              },
              // P7: theme ElevatedButton drives both modes.
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Explore Pax Choices',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NOTE (P6 Q6/Q8): the bespoke _ErrorBookings was retired; call sites use
// the shared ErrorStateCard from widgets/index.dart (friendly copy, dark-
// aware, raw errors never rendered).

// ============================================================================
// STATUS COLOR
// ============================================================================

// C55: status chips resolve through AppTheme semantic tokens
// (success/pending/errorOnLight/secondary) — never bespoke hex.
Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'confirmed':
    case 'paid':
      return AppTheme.success;

    case 'pending':
      return AppTheme.pending;

    case 'cancelled':
    case 'canceled':
    case 'expired':
      return AppTheme.errorOnLight;

    default:
      return AppTheme.secondary;
  }
}
