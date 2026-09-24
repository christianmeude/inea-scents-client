import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/index.dart';

/// C16/C26: Home is a concierge stack, not a catalog. Check-date CTA first,
// then the C11 upcoming Booking, one Offering teaser (→ /packages).
// No catalog grid lives here.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // C40: clamp overscroll on mobile (<768px); SDK default
          // (stretch Android / bounce iOS) displaced content past edge.
          // Desktop/web physics untouched (null = platform default).
          physics: MobileClampScroll.physicsOf(context),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: ResponsiveAppShell.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // C42: unified header (mobile logo row retired — brand
                  // lives in TopNavBar on tablet/desktop).
                  // C72: shared header token; bottom 0 preserves the exact
                  // prior visuals (SizedBox h18 + horizontal 20, gap below
                  // stays the SizedBox h20).
                  Padding(
                    padding:
                        ResponsiveAppShell.screenHeaderPadding.copyWith(
                      bottom: 0,
                    ),
                    child: const TabHeader(
                      title: 'Home',
                      count: 'Plan your scent experience.',
                    ),
                  ),
                  // C60: Q9 retired — the flow itself resumes the draft
                  // at its stored stage.
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: NextStepCard(),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: UpcomingBookingSection(),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _OfferingTeaser(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Single static teaser into the Offerings list. No fetching here.
class _OfferingTeaser extends StatelessWidget {
  const _OfferingTeaser();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('home_offering_teaser'),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CardSurfaces.cardBg(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: CardSurfaces.cardBorder(context)),
        boxShadow: [
          BoxShadow(
            color: CardSurfaces.plum.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore our Offerings',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: CardSurfaces.title(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Check your date, then pick a Pax Choice for your event.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: CardSurfaces.body(context),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton(
            key: const Key('home_view_offerings_cta'),
            // C31: plum/cream token both modes (was dark-on-dark).
            style: FilledButton.styleFrom(
              backgroundColor: CardSurfaces.plum,
              foregroundColor: CardSurfaces.onPrimaryButton,
            ),
            onPressed: () => context.go('/packages'),
            child: const Text('View Offerings'),
          ),
        ],
      ),
    );
  }
}
