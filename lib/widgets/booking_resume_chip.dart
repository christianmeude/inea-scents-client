import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/index.dart';
import '../providers/index.dart';
import 'card_surfaces.dart';

/// C53 (Q9): persistent in-progress resume chip.
///
/// Renders on all 5 booking-flow screens (Home, Packages, Calendar, Booking,
/// Profile) whenever the booking flow holds an in-progress draft — a chosen
/// package, date, or Pax Choice on a non-terminal checkout — and hides
/// otherwise (zero layout impact: a shrink when there is no draft).
///
/// Tap resumes the single booking route (`/booking/:id`, draft date + Pax
/// carried as query), or falls back to `/packages` when no package is chosen
/// yet. Branch switches use `go` so the tab selection follows the reroute.
class BookingResumeChip extends ConsumerWidget {
  /// The package shown by the hosting booking screen, if any. When the
  /// draft already belongs to this booking the chip hides — you are
  /// already there, and the flow's own one-liner carries the state.
  final int? currentPackageId;

  const BookingResumeChip({super.key, this.currentPackageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(bookingFlowProvider);
    final packageId = flow.selectedPackage?.id;
    if (currentPackageId != null && packageId == currentPackageId) {
      return const SizedBox.shrink();
    }
    final hasDraft =
        (packageId != null ||
            flow.selectedDate != null ||
            flow.selectedPax != null) &&
        flow.checkoutStatus == BookingCheckoutStatus.idle &&
        flow.booking == null;
    if (!hasDraft) return const SizedBox.shrink();

    final parts = <String>[
      if (flow.selectedPax != null) '${flow.selectedPax} PAX',
      if (flow.selectedDate != null)
        _shortDate(flow.selectedDate!),
      if (flow.selectedTime != null) TimeSlot.display(flow.selectedTime),
    ];
    final label = parts.isEmpty
        ? 'Resume booking'
        : 'Resume booking · ${parts.join(' · ')}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: GestureDetector(
        key: const Key('booking_resume_chip'),
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (packageId != null) {
            final query = <String>[
              if (flow.selectedPax != null) 'pax=${flow.selectedPax}',
              if (flow.selectedDate != null)
                'date=${formatDateParam(flow.selectedDate!)}',
            ];
            final suffix = query.isEmpty ? '' : '?${query.join('&')}';
            context.go('/booking/$packageId$suffix');
          } else if (flow.selectedDate != null) {
            context.go(
              '/packages?date=${formatDateParam(flow.selectedDate!)}',
            );
          } else {
            context.go('/packages');
          }
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Semantics(
            button: true,
            label: label,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: CardSurfaces.chipBg(context),
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: CardSurfaces.cardBorder(context)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.restart_alt_rounded,
                    size: 18,
                    color: CardSurfaces.title(context),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: CardSurfaces.title(context),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: CardSurfaces.title(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _shortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
