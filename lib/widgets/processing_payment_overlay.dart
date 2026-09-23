import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/index.dart';
import 'card_surfaces.dart';

/// C51: provider-level minimized flag for the payment modal.
///
/// Lives outside any route, so minimizing survives navigation (tab
/// switches, pushes, pops). The checkout itself already lives in
/// [bookingFlowProvider]; this boolean is the only extra state the
/// minimizable modal needs.
final paymentOverlayMinimizedProvider = StateProvider<bool>((ref) => false);

bool _isProcessing(BookingCheckoutStatus status) =>
    status == BookingCheckoutStatus.awaitingPayment;

bool _isResult(BookingCheckoutStatus status) =>
    status == BookingCheckoutStatus.confirmed ||
    status == BookingCheckoutStatus.cancelled;

/// C51: global minimizable payment modal.
///
/// Renders above every tab (hosted by [ProcessingPaymentOverlayHost]) while
/// an online checkout is processing or has just resolved:
/// - expanded modal by default; [paymentOverlayMinimizedProvider] collapses
///   it to a bottom-right pill that survives navigation;
/// - no dismiss-X while processing — only Minimize; Dismiss (Done/Rebook)
///   appears on a result;
/// - auto-expands on success/fail: any terminal Status clears the minimized
///   flag, even mid-minimized.
///
/// On the booking checkout route itself the screen already carries the
/// checkout card, so the overlay stays a pill there and never double-renders.
/// Copy stays distinct from the booking screen's checkout cards so both can
/// coexist without ambiguous text.
class ProcessingPaymentOverlay extends ConsumerWidget {
  const ProcessingPaymentOverlay({super.key});

  static bool _onBookingCheckoutRoute(BuildContext context) {
    try {
      final router = GoRouter.maybeOf(context);
      final path = router?.routeInformationProvider.value.uri.path ?? '';
      return path.startsWith('/booking/');
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(bookingFlowProvider);
    final status = flow.checkoutStatus;
    ref.listen<BookingCheckoutStatus>(
      bookingFlowProvider.select((s) => s.checkoutStatus),
      (previous, next) {
        if (_isResult(next)) {
          ref.read(paymentOverlayMinimizedProvider.notifier).state = false;
        }
      },
    );

    if (flow.booking == null || (!_isProcessing(status) && !_isResult(status))) {
      return const SizedBox.shrink();
    }
    final minimized =
        ref.watch(paymentOverlayMinimizedProvider) ||
        _onBookingCheckoutRoute(context);
    // C67: spring entrance on minimize↔expand. Entrance-only (no
    // cross-fade) so the outgoing child unmounts immediately; the
    // incoming child scales + slides in from the bottom-right anchor.
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (minimized) {
      return _PillSpring(
        key: const ValueKey('pill-spring'),
        reducedMotion: reducedMotion,
        child: _ProcessingPill(status: status),
      );
    }
    return _PillSpring(
      key: const ValueKey('modal-spring'),
      reducedMotion: reducedMotion,
      child: _ProcessingModal(status: status),
    );
  }
}

/// C67: spring entrance for the payment pill minimize↔expand transition.
///
/// Scale + slide anchored bottom-right on [Curves.easeOutBack] (spring
/// overshoot), Flutter built-ins only. Entrance-only: the outgoing child
/// unmounts immediately so result auto-expand timing is unchanged. When
/// reduced-motion is on the child renders instantly with no animation
/// widgets.
class _PillSpring extends StatelessWidget {
  final Widget child;
  final bool reducedMotion;

  const _PillSpring({super.key, required this.child, required this.reducedMotion});

  @override
  Widget build(BuildContext context) {
    if (reducedMotion) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, value, inner) {
        final scale = 0.85 + 0.15 * value;
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset((1 - value) * 48, (1 - value) * 48),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.bottomRight,
              child: inner,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

/// C51: host that stacks the overlay above tab content. Provider-less
/// contexts (bare shell tests) render the child untouched.
class ProcessingPaymentOverlayHost extends StatelessWidget {
  final Widget child;

  const ProcessingPaymentOverlayHost({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    try {
      ProviderScope.containerOf(context);
    } catch (_) {
      return child;
    }
    return Stack(
      children: [child, const ProcessingPaymentOverlay()],
    );
  }
}

class _ProcessingPill extends ConsumerWidget {
  final BookingCheckoutStatus status;

  const _ProcessingPill({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final processing = _isProcessing(status);
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 96),
        child: GestureDetector(
          key: const Key('processing_pill'),
          behavior: HitTestBehavior.opaque,
          onTap: () {
            ref.read(paymentOverlayMinimizedProvider.notifier).state = false;
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Semantics(
              button: true,
              label: processing
                  ? 'Payment processing — tap to expand'
                  : 'Payment result — tap to expand',
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: CardSurfaces.cardBg(context),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: CardSurfaces.cardBorder(context),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CardSurfaces.plum.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (processing)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    else
                      Icon(
                        status == BookingCheckoutStatus.confirmed
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 18,
                        color: CardSurfaces.title(context),
                      ),
                    const SizedBox(width: 10),
                    Text(
                      processing ? 'Payment processing…' : 'Payment update',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: CardSurfaces.title(context),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.expand_less_rounded,
                      size: 20,
                      color: CardSurfaces.title(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProcessingModal extends ConsumerWidget {
  final BookingCheckoutStatus status;

  const _ProcessingModal({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // No ModalBarrier: taps outside the card fall through so navigation
    // (tabs, back) keeps working while processing runs underneath.
    // The terminal result docks bottom-sheet style: the booking checkout
    // screen already carries its own centered result card, so a centered
    // overlay would swallow its buttons (and duplicate it visually).
    final reference =
        ref.watch(bookingFlowProvider.select((s) => s.booking?.bookingReference)) ??
        '—';
    final notifier = ref.read(bookingFlowProvider.notifier);
    final confirmed = status == BookingCheckoutStatus.confirmed;
    final processing = _isProcessing(status);
    return Align(
      alignment: processing ? Alignment.center : Alignment.bottomCenter,
      child: Container(
        key: const Key('processing_modal'),
        constraints: const BoxConstraints(maxWidth: 420),
        margin: processing
            ? const EdgeInsets.symmetric(horizontal: 30, vertical: 10)
            : const EdgeInsets.fromLTRB(30, 10, 30, 24),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
        decoration: BoxDecoration(
          color: CardSurfaces.cardBg(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: CardSurfaces.cardBorder(context)),
          boxShadow: [
            BoxShadow(
              color: CardSurfaces.plum.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (processing) ...[
              const SizedBox(
                width: 42,
                height: 42,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 20),
              Text(
                'Payment processing',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: CardSurfaces.title(context),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ref $reference · waiting for confirmation. '
                'You can keep browsing — this stays with you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: CardSurfaces.body(context),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  key: const Key('processing_minimize'),
                  onPressed: () {
                    ref
                        .read(paymentOverlayMinimizedProvider.notifier)
                        .state = true;
                  },
                  icon: const Icon(Icons.expand_more_rounded, size: 18),
                  label: const Text('Minimize'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton.icon(
                  onPressed: () => notifier.checkStatusImmediate(),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Check status now'),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
              ),
              // No dismiss-X while processing: Minimize is the only exit.
            ] else ...[
              Icon(
                confirmed
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: 48,
                color: CardSurfaces.title(context),
              ),
              const SizedBox(height: 16),
              Text(
                confirmed ? 'Payment confirmed' : 'Booking cancelled',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: CardSurfaces.title(context),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                confirmed
                    ? 'Ref $reference · your Booking is confirmed.'
                    : 'Ref $reference · the payment did not complete. '
                        'You can start a fresh booking.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: CardSurfaces.body(context),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (confirmed) {
                      notifier.reset();
                    } else {
                      notifier.rebook();
                    }
                  },
                  icon: Icon(
                    confirmed
                        ? Icons.arrow_forward_rounded
                        : Icons.restart_alt_rounded,
                    size: 18,
                  ),
                  // Distinct from the booking screen's own checkout cards
                  // (`Done`/`Rebook`), which stay mounted underneath.
                  label: Text(confirmed ? 'Got it' : 'New booking'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
