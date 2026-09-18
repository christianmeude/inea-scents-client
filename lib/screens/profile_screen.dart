import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/index.dart';
import '../providers/index.dart';
import '../widgets/index.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final wishlistAsync = ref.watch(wishlistProvider);
    final bookingsAsync = ref.watch(bookingsProvider);

    // ============================================================
    // COLORS
    // ============================================================

    const backgroundTop = Color(0xFFF8E9DF);
    const backgroundMiddle = Color(0xFFD8B0BA);
    const backgroundBottom = Color(0xFFB78C9C);

    const primaryColor = Color(0xFF74445C);
    const textColor = Color(0xFF633E50);
    const secondaryTextColor = Color(0xFF765867);

    final userName = authState.user?.name ?? 'User';
    final userEmail = authState.user?.email ?? '';

    // Safely get the first letter.
    final firstLetter = userName.trim().isNotEmpty
        ? userName.trim().substring(0, 1).toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: backgroundTop,

      // ============================================================
      // APP BAR (Mobile only, Desktop uses TopNavBar in App Shell)
      // ============================================================
      appBar: MediaQuery.of(context).size.width < 768
          ? AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,

              title: const _BrandName(),

              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.55),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.more_horiz_rounded,
                        color: textColor,
                        size: 22,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            )
          : null,

      // ============================================================
      // BODY
      // ============================================================
      body: Stack(
        children: [
          // ========================================================
          // GRADIENT BACKGROUND
          // ========================================================
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [backgroundTop, backgroundMiddle, backgroundBottom],
              ),
            ),
          ),

          // ========================================================
          // TOP-LEFT GLOW
          // ========================================================
          Positioned(
            top: -130,
            left: -120,
            child: _BlurCircle(
              size: 390,
              color: const Color(0xFFEBC9B8).withValues(alpha: 0.75),
            ),
          ),

          // ========================================================
          // TOP-RIGHT GLOW
          // ========================================================
          Positioned(
            top: 80,
            right: -150,
            child: _BlurCircle(
              size: 370,
              color: const Color(0xFFD3A4AF).withValues(alpha: 0.72),
            ),
          ),

          // ========================================================
          // BOTTOM-LEFT GLOW
          // ========================================================
          Positioned(
            bottom: -170,
            left: -130,
            child: _BlurCircle(
              size: 430,
              color: const Color(0xFF9C8491).withValues(alpha: 0.65),
            ),
          ),

          // ========================================================
          // BOTTOM-RIGHT GLOW
          // ========================================================
          Positioned(
            bottom: -150,
            right: -120,
            child: _BlurCircle(
              size: 420,
              color: const Color(0xFF69384F).withValues(alpha: 0.55),
            ),
          ),

          // ========================================================
          // CENTER GLOW
          // ========================================================
          Positioned(
            top: MediaQuery.of(context).size.height * 0.28,
            left: MediaQuery.of(context).size.width * 0.18,
            child: _BlurCircle(
              size: 420,
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),

          // ========================================================
          // CONTENT
          // ========================================================
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // PAGE TITLE
                  // ==================================================
                  const Text(
                    'My Profile',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Manage your account and preferences.',
                    style: TextStyle(color: secondaryTextColor, fontSize: 13),
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // PROFILE CARD
                  // ==================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.34),
                      borderRadius: BorderRadius.circular(24),

                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.60),
                        width: 1,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.10),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        // ==================================================
                        // AVATAR
                        // ==================================================
                        Container(
                          width: 68,
                          height: 68,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF95647E), Color(0xFF74445C)],
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),

                          child: Center(
                            child: Text(
                              firstLetter,

                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // ==================================================
                        // USER INFORMATION
                        // ==================================================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                userName,

                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                userEmail,

                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 12.5,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),

                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: const Text(
                                  'INEA MEMBER',

                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ==================================================
                        // EDIT BUTTON
                        // ==================================================
                        Container(
                          width: 38,
                          height: 38,

                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.40),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.55),
                            ),
                          ),

                          child: IconButton(
                            padding: EdgeInsets.zero,

                            icon: const Icon(
                              Icons.edit_outlined,
                              color: primaryColor,
                              size: 18,
                            ),

                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const _SectionHeader(
                    title: 'Upcoming Booking',
                    subtitle: 'Your next INEA Scents experience',
                    icon: Icons.event_available_outlined,
                  ),

                  const SizedBox(height: 14),

                  bookingsAsync.when(
                    data: (bookings) {
                      final upcoming = _nextBooking(bookings);
                      if (upcoming == null) {
                        return const _EmptyUpcomingBooking();
                      }

                      return _UpcomingBookingCard(booking: upcoming);
                    },
                    loading: () => const _UpcomingBookingLoading(),
                    error: (error, stack) => _UpcomingBookingError(
                      onRetry: () => ref.invalidate(bookingsProvider),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // WISHLIST TITLE
                  // ==================================================
                  const _SectionHeader(
                    title: 'My Wishlist',
                    subtitle: 'Your favorite scents',
                    icon: Icons.favorite_rounded,
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // WISHLIST
                  // ==================================================
                  wishlistAsync.when(
                    data: (wishlist) {
                      if (wishlist.isEmpty) {
                        return const _EmptyWishlist();
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 16,
                            ),

                        itemCount: wishlist.length,

                        itemBuilder: (context, index) {
                          return PackageCard(package: wishlist[index]);
                        },
                      );
                    },

                    loading: () {
                      return const SizedBox(
                        height: 220,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: primaryColor,
                          ),
                        ),
                      );
                    },

                    error: (error, stack) {
                      return _WishlistError(error: error);
                    },
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // SETTINGS TITLE
                  // ==================================================
                  const _SectionHeader(
                    title: 'Settings',
                    subtitle: 'Account & preferences',
                    icon: Icons.settings_outlined,
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // SETTINGS CARD
                  // ==================================================
                  Container(
                    width: double.infinity,

                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.34),
                      borderRadius: BorderRadius.circular(24),

                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.60),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        _ProfileSettingTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Edit Profile',
                          subtitle: 'Update your personal information',
                          onTap: () => context.push('/edit-profile'),
                        ),

                        const _SettingDivider(),

                        _ProfileSettingTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Change Password',
                          subtitle: 'Keep your account secure',
                          onTap: () => context.push('/change-password'),
                        ),

                        const _SettingDivider(),

                        _ProfileSettingTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
                          subtitle: 'Get assistance with your account',
                          onTap: () => context.push('/help-support'),
                        ),

                        const _SettingDivider(),

                        _ProfileSettingTile(
                          icon: Icons.logout_rounded,
                          title: 'Logout',
                          subtitle: 'Sign out of your account',
                          isDestructive: true,
                          showArrow: false,
                          onTap: () {
                            ref.read(authProvider.notifier).logout();

                            context.go('/login');
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // BRAND FOOTER
                  // ==================================================
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'INEA',
                          style: TextStyle(
                            color: Color(0xFF6D3E55),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 4,
                          ),
                        ),

                        SizedBox(height: 1),

                        Text(
                          'Scents',
                          style: TextStyle(
                            color: Color(0xFF6D3E55),
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'serif',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Booking? _nextBooking(List<Booking> bookings) {
  final upcoming =
      bookings.where((booking) => booking.eventDate != null).toList()
        ..sort((a, b) => a.eventDate!.compareTo(b.eventDate!));

  if (upcoming.isEmpty) return null;
  final today = DateTime.now();
  return upcoming.firstWhere(
    (booking) => !booking.eventDate!.isBefore(today),
    orElse: () => upcoming.first,
  );
}

class _UpcomingBookingCard extends StatelessWidget {
  final Booking booking;

  const _UpcomingBookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final eventDate = booking.eventDate;
    final dateLabel = eventDate == null
        ? 'Date to be confirmed'
        : '${eventDate.day.toString().padLeft(2, '0')}/'
              '${eventDate.month.toString().padLeft(2, '0')}/'
              '${eventDate.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF74445C).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: Color(0xFF74445C),
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  booking.package?.name ?? 'INEA Scents booking',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF633E50),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _BookingStatusLabel(status: booking.status ?? 'Pending'),
            ],
          ),
          const SizedBox(height: 16),
          _UpcomingBookingDetail(icon: Icons.event_outlined, text: dateLabel),
          const SizedBox(height: 9),
          _UpcomingBookingDetail(
            icon: Icons.location_on_outlined,
            text: booking.venueAddress ?? 'Venue to be confirmed',
          ),
          const SizedBox(height: 9),
          _UpcomingBookingDetail(
            icon: Icons.people_outline,
            text: booking.pax == null
                ? 'Guest count to be confirmed'
                : '${booking.pax} ${booking.pax == 1 ? 'guest' : 'guests'}',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/bookings'),
              icon: const Icon(Icons.arrow_forward_rounded, size: 17),
              label: const Text('VIEW BOOKING DETAILS'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF74445C),
                side: BorderSide(
                  color: const Color(0xFF74445C).withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingBookingDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _UpcomingBookingDetail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF765867), size: 17),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF765867), fontSize: 12.5),
          ),
        ),
      ],
    );
  }
}

class _BookingStatusLabel extends StatelessWidget {
  final String status;

  const _BookingStatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF74445C).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF74445C),
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _EmptyUpcomingBooking extends StatelessWidget {
  const _EmptyUpcomingBooking();

  @override
  Widget build(BuildContext context) {
    return _ProfileMessageCard(
      icon: Icons.event_busy_outlined,
      message: 'No upcoming bookings yet.',
      actionLabel: 'BROWSE PACKAGES',
      onPressed: () => context.push('/packages'),
    );
  }
}

class _UpcomingBookingLoading extends StatelessWidget {
  const _UpcomingBookingLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Color(0xFF74445C),
        ),
      ),
    );
  }
}

class _UpcomingBookingError extends StatelessWidget {
  final VoidCallback onRetry;

  const _UpcomingBookingError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return _ProfileMessageCard(
      icon: Icons.cloud_off_outlined,
      message: 'Unable to load your booking.',
      actionLabel: 'TRY AGAIN',
      onPressed: onRetry,
    );
  }
}

class _ProfileMessageCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onPressed;

  const _ProfileMessageCard({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF74445C), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFF633E50)),
            ),
          ),
          TextButton(onPressed: onPressed, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

// ============================================================================
// INEA BRAND NAME
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
// SECTION HEADER
// ============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF633E50);
    const secondaryTextColor = Color(0xFF765867);
    const primaryColor = Color(0xFF74445C);

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.38),
            shape: BoxShape.circle,

            border: Border.all(color: Colors.white.withValues(alpha: 0.60)),
          ),

          child: Icon(icon, color: primaryColor, size: 20),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,

                style: const TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,

                style: const TextStyle(
                  color: secondaryTextColor,
                  fontSize: 11.5,
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
// PROFILE SETTING TILE
// ============================================================================

class _ProfileSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool showArrow;

  const _ProfileSettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF74445C);
    const textColor = Color(0xFF633E50);
    const secondaryTextColor = Color(0xFF765867);

    final itemColor = isDestructive ? const Color(0xFF9A4F5D) : primaryColor;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.click,
        borderRadius: BorderRadius.circular(24),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),

          child: Row(
            children: [
              // ========================================================
              // ICON
              // ========================================================
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: isDestructive
                      ? const Color(0xFF9A4F5D).withValues(alpha: 0.10)
                      : primaryColor.withValues(alpha: 0.10),

                  borderRadius: BorderRadius.circular(13),
                ),

                child: Icon(icon, color: itemColor, size: 20),
              ),

              const SizedBox(width: 14),

              // ========================================================
              // TEXT
              // ========================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        color: isDestructive
                            ? const Color(0xFF9A4F5D)
                            : textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,

                      style: const TextStyle(
                        color: secondaryTextColor,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),

              // ========================================================
              // ARROW
              // ========================================================
              if (showArrow)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: secondaryTextColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SETTING DIVIDER
// ============================================================================

class _SettingDivider extends StatelessWidget {
  const _SettingDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 73, right: 17),

      child: Divider(
        height: 1,
        thickness: 0.7,
        color: Colors.white.withValues(alpha: 0.55),
      ),
    );
  }
}

// ============================================================================
// EMPTY WISHLIST
// ============================================================================

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF633E50);
    const secondaryTextColor = Color(0xFF765867);
    const primaryColor = Color(0xFF74445C);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 38),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
      ),

      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.favorite_border_rounded,
              color: primaryColor,
              size: 28,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Your wishlist is empty',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Save your favorite scents here\nand find them easily later.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              // Usually the BottomNavBar is used, but if we need a direct action:
              // context.go('/packages');
              // The routing in this app for the packages tab is likely the initial route or /packages.
              // Assuming go_router is available, let's just go to the home/packages tab.
              context.go('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Explore Packages',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// WISHLIST ERROR
// ============================================================================

class _WishlistError extends StatelessWidget {
  final Object error;

  const _WishlistError({required this.error});

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF633E50);
    const secondaryTextColor = Color(0xFF765867);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
      ),

      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 38, color: textColor),

          const SizedBox(height: 10),

          const Text(
            'Unable to load wishlist',
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            '$error',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: secondaryTextColor, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BLURRED BACKGROUND CIRCLE
// ============================================================================

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),

      child: Container(
        width: size,
        height: size,

        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
