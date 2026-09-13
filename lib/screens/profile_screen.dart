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

    final textColor =
        isDark ? const Color(0xFFFDF4F5) : const Color(0xFF633E50);
    final secondaryTextColor =
        isDark ? const Color(0xFFC4ACAC) : const Color(0xFF765867);

    // Solid card surfaces matching the rest of the app (Q3).
    final circleBg = isDark
        ? const Color(0xFF36222C)
        : const Color(0xFFFDF4F5);
    final circleBorder = isDark
        ? const Color(0xFFFDF4F5).withValues(alpha: 0.25)
        : const Color(0x4D99868C);
    final userName = authState.user?.name ?? 'User';
    final userEmail = authState.user?.email ?? '';

    // Safely get the first letter.
    final firstLetter = userName.trim().isNotEmpty
        ? userName.trim().substring(0, 1).toUpperCase()
        : 'U';

    // P7: no explicit color — flat theme scaffold background.
    return Scaffold(

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
                      color: circleBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: circleBorder,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
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
      // BODY (P7: flat theme background; decorative gradient removed)
      // ============================================================
      body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),

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

                  const SizedBox(height: 5),

                  Text(
                    'Manage your account and preferences.',
                    style: TextStyle(color: secondaryTextColor, fontSize: 13),
                  ),

                  const SizedBox(height: 20),

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
                      if (constraints.maxWidth <=
                          ResponsiveAppShell.tabletBreakpoint) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profile,
                            const SizedBox(height: 28),
                            settings,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: profile),
                          const SizedBox(width: 16),
                          Expanded(child: settings),
                        ],
                      );
                    },
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

        border: Border.all(
          color: cardBorder,
          width: 1,
        ),

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

                  style: TextStyle(
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
                    color: CardSurfaces.plum.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    'INEA MEMBER',

                    style: TextStyle(
                      color: textColor,
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
              color: CardSurfaces.chipBg(context),
              shape: BoxShape.circle,
              border: Border.all(
                color: CardSurfaces.cardBorder(context),
              ),
            ),

            child: IconButton(
              padding: EdgeInsets.zero,

              icon: Icon(
                Icons.edit_outlined,
                color: textColor,
                size: 18,
              ),

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
        const _SectionHeader(
          title: 'Settings',
          subtitle: 'Account & preferences',
          icon: Icons.settings_outlined,
        ),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,

          decoration: BoxDecoration(
            // P6 (Q3): solid card, never glass.
            color: cardBg,
            borderRadius: BorderRadius.circular(24),

            border: Border.all(
              color: cardBorder,
            ),

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
                subtitle: 'Update your personal information',
                onTap: () {},
              ),

              const _SettingDivider(),

              _ProfileSettingTile(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
                subtitle: 'Keep your account secure',
                onTap: () {},
              ),

              const _SettingDivider(),

              _ProfileSettingTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle: 'Get assistance with your account',
                onTap: () {},
              ),

              const _SettingDivider(),

              _ProfileSettingTile(
                icon: Icons.logout_rounded,
                title: 'Logout',
                subtitle: 'Sign out of your account',
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
    // P6 (Q1/Q3): dark-aware, solid icon chip.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF74445C);
    final textColor =
        isDark ? const Color(0xFFFDF4F5) : const Color(0xFF633E50);
    final secondaryTextColor =
        isDark ? const Color(0xFFC4ACAC) : const Color(0xFF765867);

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF36222C)
                : const Color(0xFFFDF4F5),
            shape: BoxShape.circle,

            border: Border.all(
              color: isDark
                  ? const Color(0xFFFDF4F5).withValues(alpha: 0.25)
                  : const Color(0x4D99868C),
            ),
          ),

          child: Icon(
            icon,
            color: isDark ? const Color(0xFFFDF4F5) : primaryColor,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,

                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,

                style: TextStyle(
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
    // P6 (Q1): dark-aware tile text.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF74445C);
    final textColor =
        isDark ? const Color(0xFFFDF4F5) : const Color(0xFF633E50);
    final secondaryTextColor =
        isDark ? const Color(0xFFC4ACAC) : const Color(0xFF765867);

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

                    Text(
                      subtitle,

                      style: TextStyle(
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

