import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/index.dart';
import '../widgets/index.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // ============================================================
    // COLORS (P6 Q1/Q3: dark-aware; cards are solid, never glass)
    // ============================================================
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? const Color(0xFFFDF4F5)
        : const Color(0xFF633E50);
    final secondaryTextColor = isDark
        ? const Color(0xFFC4ACAC)
        : const Color(0xFF765867);

    // Solid card surfaces matching the rest of the app (Q3).
    final userName = authState.user?.name ?? 'User';
    final userEmail = authState.user?.email ?? '';

    // Safely get the first letter.
    final firstLetter = userName.trim().isNotEmpty
        ? userName.trim().substring(0, 1).toUpperCase()
        : 'U';

    // P7: no explicit color — flat theme scaffold background.
    return Scaffold(
      // C22: distilled — mobile AppBar removed (brand title + dead
      // overflow action). Desktop TopNavBar covers nav.
      appBar: null,

      // ============================================================
      // BODY (P7: flat theme background; decorative gradient removed)
      // ============================================================
      body: SafeArea(
        // C9: no-scroll fit at 360x800 — fixed header/cards plus an
        // Expanded logo zone that centers the muted mark in the
        // card-edge-to-screen-bottom space instead of scrolling.
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // PAGE TITLE
              // ==================================================
              Text(
                'My Profile',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Manage your account and preferences.',
                style: TextStyle(color: secondaryTextColor, fontSize: 13),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // PROFILE + SETTINGS (P7 impeccable adapt: stacked
              // on mobile, side-by-side on web)
              // ==================================================
              LayoutBuilder(
                builder: (context, constraints) {
                  final settings = _SettingsColumn(
                    onLogout: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/login');
                    },
                  );
                  final profile = _ProfileCard(
                    userName: userName,
                    userEmail: userEmail,
                    firstLetter: firstLetter,
                  );
                  // C11: nearest upcoming Booking with View detail link.
                  const upcoming = UpcomingBookingSection();
                  if (constraints.maxWidth <=
                      ResponsiveAppShell.tabletBreakpoint) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profile,
                        const SizedBox(height: 12),
                        upcoming,
                        const SizedBox(height: 12),
                        settings,
                      ],
                    );
                  }

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profile,
                          const SizedBox(height: 12),
                          upcoming,
                          const SizedBox(height: 12),
                          settings,
                        ],
                      ),
                    ),
                  );
                },
              ),

              // ==================================================
              // BRAND FOOTER (C9: muted mark optically centered in
              // the card-edge-to-screen-bottom zone; SizedBox
              // bounds the AppLogo FittedBox so its layout box
              // stays compact — Transform.scale kept the full-size
              // box and pushed 360x800 into scroll/overflow).
              Expanded(
                child: Center(
                  child: Opacity(
                    opacity: 0.3,
                    child: SizedBox(
                      width: 120,
                      child: const AppLogo(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PROFILE CARD (P7: shared by stacked + side-by-side compositions)
// ============================================================================

class _ProfileCard extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String firstLetter;

  const _ProfileCard({
    required this.userName,
    required this.userEmail,
    required this.firstLetter,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = CardSurfaces.cardBg(context);
    final cardBorder = CardSurfaces.cardBorder(context);
    final textColor = CardSurfaces.title(context);
    final secondaryTextColor = CardSurfaces.body(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        // P6 (Q3): solid card, never glass.
        color: cardBg,
        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: cardBorder, width: 1),

        boxShadow: [
          BoxShadow(
            color: CardSurfaces.plum.withValues(alpha: 0.10),
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
                  color: CardSurfaces.plum.withValues(alpha: 0.25),
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

                  style: TextStyle(
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

                  style: TextStyle(color: secondaryTextColor, fontSize: 12.5),
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
              color: CardSurfaces.chipBg(context),
              shape: BoxShape.circle,
              border: Border.all(color: CardSurfaces.cardBorder(context)),
            ),

            child: IconButton(
              padding: EdgeInsets.zero,

              icon: Icon(Icons.edit_outlined, color: textColor, size: 18),

              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SETTINGS COLUMN (P7: header + card, shared by both compositions)
// ============================================================================

class _SettingsColumn extends StatelessWidget {
  final VoidCallback onLogout;

  const _SettingsColumn({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final cardBg = CardSurfaces.cardBg(context);
    final cardBorder = CardSurfaces.cardBorder(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,

          decoration: BoxDecoration(
            // P6 (Q3): solid card, never glass.
            color: cardBg,
            borderRadius: BorderRadius.circular(24),

            border: Border.all(color: cardBorder),

            boxShadow: [
              BoxShadow(
                color: CardSurfaces.plum.withValues(alpha: 0.08),
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
                onTap: () {},
              ),

              const _SettingDivider(),

              _ProfileSettingTile(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
                onTap: () {},
              ),

              const _SettingDivider(),

              _ProfileSettingTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                onTap: () {},
              ),

              const _SettingDivider(),

              _ProfileSettingTile(
                icon: Icons.logout_rounded,
                title: 'Logout',
                isDestructive: true,
                showArrow: false,
                onTap: onLogout,
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
  final VoidCallback onTap;
  final bool isDestructive;
  final bool showArrow;

  const _ProfileSettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    // P6 (Q1): dark-aware tile text.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF74445C);
    final textColor = isDark
        ? const Color(0xFFFDF4F5)
        : const Color(0xFF633E50);
    final secondaryTextColor = isDark
        ? const Color(0xFFC4ACAC)
        : const Color(0xFF765867);

    final itemColor = isDestructive
        ? isDark
              ? const Color(0xFFF0A6B0)
              : const Color(0xFF9A4F5D)
        : (isDark ? const Color(0xFFFDF4F5) : primaryColor);

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

                  ],
                ),
              ),

              // ========================================================
              // ARROW
              // ========================================================
              if (showArrow)
                Icon(
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
        // P6 (Q1): visible on solid cards in both themes.
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF36222C)
            : const Color(0x4D99868C),
      ),
    );
  }
}
