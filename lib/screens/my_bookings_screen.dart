import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/index.dart';
import '../models/index.dart';
import '../widgets/index.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  // ============================================================
  // INEA COLORS
  // ============================================================

  static const Color backgroundTop = Color(0xFFF8E9DF);
  static const Color backgroundMiddle = Color(0xFFE8CDD2);
  static const Color backgroundBottom = Color(0xFFD7B4C0);

  static const Color primaryColor = Color(0xFF74445C);
  static const Color primaryLight = Color(0xFF95647E);

  static const Color textColor = Color(0xFF633E50);
  static const Color secondaryTextColor = Color(0xFF765867);

  static const Color borderColor = Color(0xFFE4CBD2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsProvider);

    return Scaffold(
      backgroundColor: backgroundTop,

      // ============================================================
      // APP BAR
      // ============================================================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        // ==========================================================
        // BRAND
        // Same alignment as PackagesScreen
        // ==========================================================
        title: const _BrandName(),

        // Keep the left side empty so the brand remains centered.
        leading: const SizedBox(),

        // Keep the AppBar balanced.
        actions: const [SizedBox(width: 58)],
      ),

      // ============================================================
      // BODY
      // ============================================================
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [backgroundTop, backgroundMiddle, backgroundBottom],
          ),
        ),

        child: SafeArea(
          child: Stack(
            children: [
              // ======================================================
              // SOFT BACKGROUND CIRCLES
              // ======================================================
              Positioned(
                top: -110,
                left: -120,
                child: _SoftCircle(
                  size: 300,
                  color: const Color(0xFFEBC9B8).withValues(alpha: 0.50),
                ),
              ),

              Positioned(
                top: 180,
                right: -150,
                child: _SoftCircle(
                  size: 330,
                  color: const Color(0xFFD3A4AF).withValues(alpha: 0.30),
                ),
              ),

              Positioned(
                bottom: -170,
                left: -120,
                child: _SoftCircle(
                  size: 360,
                  color: const Color(0xFFB78C9C).withValues(alpha: 0.22),
                ),
              ),

              // ======================================================
              // BOOKINGS CONTENT
              // ======================================================
              bookingsAsync.when(
                data: (bookings) {
                  if (bookings.isEmpty) {
                    return const _EmptyBookings();
                  }

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                    children: [
                      // ==================================================
                      // PAGE HEADER
                      // ==================================================
                      const Text(
                        'My Bookings',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        '${bookings.length} '
                        '${bookings.length == 1 ? 'booking' : 'bookings'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: secondaryTextColor,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // BOOKING CARDS
                      // ==================================================
                      ...bookings.map(
                        (booking) => _BookingCard(booking: booking),
                      ),
                    ],
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
                error: (error, stack) {
                  return _ErrorBookings(error: error.toString());
                },
              ),
            ],
          ),
        ),
      ),

      // ============================================================
      // BOTTOM NAVIGATION
      // ============================================================
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

// ============================================================================
// INEA BRAND NAME
// EXACT SAME ALIGNMENT AS PACKAGESSCREEN
// ============================================================================

class _BrandName extends StatelessWidget {
  const _BrandName();

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFF6D3E55);

    return SizedBox(
      width: 130,
      height: 58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ==========================================================
          // INEA
          // ==========================================================
          Text(
            'INEA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              letterSpacing: 5.2,
              height: 0.85,
              color: brandColor,
              shadows: [
                Shadow(
                  color: Colors.white.withValues(alpha: 0.75),
                  blurRadius: 1.5,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),

          const SizedBox(height: 3),

          // ==========================================================
          // SCENTS
          // ==========================================================
          Text(
            'Scents',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              fontFamily: 'serif',
              letterSpacing: 0.3,
              height: 0.95,
              color: brandColor,
              shadows: [
                Shadow(
                  color: Colors.white.withValues(alpha: 0.75),
                  blurRadius: 1.5,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BOOKING CARD
// ============================================================================

class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final status = booking.status.toString();
    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 1),

        boxShadow: [
          BoxShadow(
            color: MyBookingsScreen.primaryColor.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

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
                    color: const Color(0xFFF1DDE5),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: const Icon(
                    Icons.local_mall_outlined,
                    color: MyBookingsScreen.primaryColor,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 13),

                // Booking reference
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BOOKING REFERENCE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: Color(0xFF9A7A89),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        booking.bookingReference ?? 'N/A',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: MyBookingsScreen.textColor,
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
            Container(height: 1, color: const Color(0xFFF0E1E5)),

            const SizedBox(height: 17),

            // ==========================================================
            // PACKAGE NAME
            // ==========================================================
            Text(
              booking.package?.name ?? 'Unknown Package',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: MyBookingsScreen.textColor,
                letterSpacing: -0.2,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'INEA Scents Perfume Experience',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF9A7A89),
                letterSpacing: 0.2,
              ),
            ),

            const SizedBox(height: 18),

            // ==========================================================
            // EVENT DATE
            // ==========================================================
            _BookingDetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Event Date',
              value: booking.eventDate?.toString().split(' ')[0] ?? 'N/A',
            ),

            const SizedBox(height: 11),

            // ==========================================================
            // VENUE
            // ==========================================================
            _BookingDetailRow(
              icon: Icons.location_on_outlined,
              label: 'Venue',
              value: 'N/A',
            ),

            const SizedBox(height: 11),

            // ==========================================================
            // GUESTS
            // ==========================================================
            _BookingDetailRow(
              icon: Icons.people_outline,
              label: 'Guests',
              value: 'N/A',
            ),

            const SizedBox(height: 18),

            // ==========================================================
            // PRICE
            // ==========================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),

              decoration: BoxDecoration(
                color: MyBookingsScreen.backgroundTop,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: MyBookingsScreen.borderColor.withValues(alpha: 0.65),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Package Price',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: MyBookingsScreen.secondaryTextColor,
                    ),
                  ),

                  Text(
                    booking.package != null 
                        ? 'Php. ${booking.package!.price?.toStringAsFixed(2) ?? '0.00'}'
                        : 'N/A',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: MyBookingsScreen.primaryColor,
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
            color: const Color(0xFFF5E8EC),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Icon(icon, size: 17, color: MyBookingsScreen.primaryColor),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9A7A89),
                  letterSpacing: 0.4,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: MyBookingsScreen.textColor,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),

      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.22), width: 1),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,

            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),

          const SizedBox(width: 5),

          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: color,
            ),
          ),
        ],
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
                color: Colors.white.withValues(alpha: 0.75),
                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: MyBookingsScreen.primaryColor.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: const Icon(
                Icons.calendar_month_outlined,
                size: 42,
                color: Color(0xFF8B6B7C),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'No bookings yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: MyBookingsScreen.textColor,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your perfume experiences and upcoming '
              'events will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: MyBookingsScreen.secondaryTextColor,
              ),
            ),

            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyBookingsScreen.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Explore Packages',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ERROR STATE
// ============================================================================

class _ErrorBookings extends StatelessWidget {
  final String error;

  const _ErrorBookings({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,

              decoration: const BoxDecoration(
                color: Color(0xFFF5E8EC),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: Color(0xFF8B4F68),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Unable to load bookings',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: MyBookingsScreen.textColor,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              error,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: MyBookingsScreen.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// STATUS COLOR
// ============================================================================

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'confirmed':
      return const Color(0xFF648B70);

    case 'pending':
      return const Color(0xFFC28A52);

    case 'cancelled':
      return const Color(0xFF9A607B);

    default:
      return const Color(0xFF8B7B84);
  }
}

// ============================================================================
// SOFT BACKGROUND CIRCLE
// ============================================================================

class _SoftCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _SoftCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
