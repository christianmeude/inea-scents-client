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
        child: Column(
          children: [
            if (MediaQuery.of(context).size.width < 768)
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [Center(child: SizedBox(width: 200, child: AppLogo()))],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                // C25: platform-default physics (clamp Android / bounce iOS).
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date-first entry (C13 guard + Availability
                        // gating live on the calendar route).
                        // C26: 16px card rhythm, 20px edges.
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: NextStepCard(),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: UpcomingBookingSection(),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: _OfferingTeaser(),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
            style: FilledButton.styleFrom(
              backgroundColor: CardSurfaces.plum,
            ),
            onPressed: () => context.push('/packages'),
            child: const Text('View Offerings'),
          ),
        ],
      ),
    );
  }
}
