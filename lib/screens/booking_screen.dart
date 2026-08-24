import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/index.dart';
import '../models/index.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final int packageId;

  const BookingScreen({super.key, required this.packageId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  static const Color plum = Color(0xFF6A4053);
  static const Color cream = Color(0xFFFDF4F5);

  int currentStep = 2; // Default to Schedule based on prototype

  @override
  void initState() {
    super.initState();
    _loadPackage();
  }

  void _loadPackage() async {
    final packageAsync = ref.read(packageDetailsProvider(widget.packageId));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      packageAsync.whenData((package) {
        ref.read(bookingFlowProvider.notifier).setSelectedPackage(package);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final packageAsync = ref.watch(packageDetailsProvider(widget.packageId));
    
    // Check if we reached success screen
    if (currentStep == 5) {
      return Scaffold(
        backgroundColor: cream,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(showBack: false),
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0x4D99868C)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6A4053).withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Payment Successful',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF6A4053)),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Thank you for your booking.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: const Color(0x8A6A4053)),
                        ),
                        const Text(
                          'To check your status on go to your\nbooking settings.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: const Color(0x8A6A4053)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: plum,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                    ),
                    child: const Text('Done', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(showBack: true),
            _buildTimeline(),
            Expanded(
              child: packageAsync.when(
                data: (package) => SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildCurrentStep(package),
                ),
                loading: () => const Center(child: CircularProgressIndicator(color: plum)),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (currentStep < 5) currentStep++;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plum,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                  ),
                  child: Text(
                    currentStep == 4 ? 'Confirm & Pay' : currentStep == 3 ? 'Proceed to Payment' : 'Next',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({required bool showBack}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBack)
            GestureDetector(
              onTap: () {
                if (currentStep > 0) {
                  setState(() => currentStep--);
                } else {
                  context.pop();
                }
              },
              child: Row(
                children: const [
                  Icon(Icons.arrow_back, color: plum, size: 20),
                  SizedBox(width: 5),
                  Text('Back', style: TextStyle(color: plum, fontSize: 14)),
                ],
              ),
            )
          else
            const SizedBox(width: 60),
          
          // Logo
          SizedBox(
            width: 140,
            height: 45,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: const Text('INEA', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2, height: 1, color: plum)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: const Text('Scents', style: TextStyle(fontFamily: 'GreatVibes', fontSize: 32, height: 1, color: plum)),
                ),
              ],
            ),
          ),
          
          if (showBack)
            Row(
              children: const [
                Icon(Icons.chat_bubble_rounded, color: plum),
                SizedBox(width: 15),
                Icon(Icons.calendar_today_rounded, color: plum),
              ],
            )
          else
            const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final steps = ['Package', 'Scents', 'Schedule', 'Details', 'Payment'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isPast = index <= currentStep;
          final isCurrent = index == currentStep;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index == 0) const Expanded(child: SizedBox())
                    else Expanded(child: Container(height: 3, color: isPast ? plum : const Color(0xFF99868C))),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isPast ? plum : const Color(0xFF99868C),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (index == steps.length - 1) const Expanded(child: SizedBox())
                    else Expanded(child: Container(height: 3, color: index < currentStep ? plum : const Color(0xFF99868C))),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 10,
                    color: isCurrent ? plum : const Color(0xFF99868C),
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep(Package package) {
    if (currentStep == 2) {
      // Schedule Step
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Please Choose Available Schedule', style: TextStyle(fontSize: 13, color: plum)),
              Row(
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text('Booked', style: TextStyle(fontSize: 11, color: plum)),
                  const SizedBox(width: 12),
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: plum, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text('Available', style: TextStyle(fontSize: 11, color: plum)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x4D99868C)),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleTextStyle: TextStyle(fontSize: 0), // hide standard title
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(color: Colors.transparent),
                todayTextStyle: TextStyle(color: const Color(0xFF6A4053)),
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text('Please Choose Available Pax', style: TextStyle(fontSize: 13, color: plum)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x4D99868C)),
            ),
          ),
        ],
      );
    } else if (currentStep == 3) {
      // Details Step
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: plum)),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0x4D99868C)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Details', style: TextStyle(fontSize: 14, color: const Color(0xFF6A4053))),
                      const SizedBox(height: 15),
                      Text('Package Variation: ${package.name}', style: const TextStyle(fontSize: 13, color: const Color(0x8A6A4053))),
                      const SizedBox(height: 15),
                      const Text('Inclusion/s:', style: TextStyle(fontSize: 13, color: const Color(0x8A6A4053))),
                      const SizedBox(height: 5),
                      ...(package.inclusions ?? []).map((e) => Text('• $e', style: const TextStyle(fontSize: 12, color: const Color(0xFF6A4053)))),
                      const SizedBox(height: 15),
                      const Text('Free:', style: TextStyle(fontSize: 13, color: const Color(0x8A6A4053))),
                      const SizedBox(height: 5),
                      ...(package.freebies ?? []).map((e) => Text('• $e', style: const TextStyle(fontSize: 12, color: const Color(0xFF6A4053)))),
                      const SizedBox(height: 15),
                      const Text('Selected Date:', style: TextStyle(fontSize: 13, color: const Color(0x8A6A4053))),
                      const SizedBox(height: 5),
                      const Text('September 1, 2026', style: TextStyle(fontSize: 13, color: plum)),
                      const SizedBox(height: 15),
                      const Text('Total Cost:', style: TextStyle(fontSize: 13, color: const Color(0x8A6A4053))),
                      const SizedBox(height: 5),
                      Text('Php. ${(package.price ?? 4500).toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, color: plum)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0x4D99868C)),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          color: const Color(0xFFF3EBE1),
                          child: (package.images != null && package.images!.isNotEmpty)
                              ? Image.network(package.images![0], fit: BoxFit.cover)
                              : const SizedBox(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(package.name ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            Text(package.description ?? '', maxLines: 3, style: TextStyle(fontSize: 10, color: const Color(0xFF99868C))),
                            const SizedBox(height: 12),
                            Text('Php. ${(package.price ?? 4499.0).toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, color: plum)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (currentStep == 4) {
      // Payment Step
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: plum)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x4D99868C)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(package.name ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: plum)),
                const SizedBox(height: 15),
                const Text('Inclusion/s:', style: TextStyle(fontSize: 12, color: const Color(0xFF99868C))),
                const SizedBox(height: 10),
                ...[
                  {'label': 'Featuring your logo', 'val': '300'},
                  {'label': '4 Inspired scents', 'val': '800'},
                  {'label': 'Perfume Bar Setup', 'val': '1500'},
                  {'label': 'Claim Stub', 'val': '150'},
                  {'label': 'Duration: 3-4 Hrs', 'val': '0.00'},
                  {'label': '2 staff members', 'val': '1000'},
                  {'label': 'Selfie Mirror', 'val': '0.00'},
                  {'label': '1 Gift for Celebrant', 'val': '0.00'},
                ].map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Text('• ${item['label']}', style: const TextStyle(fontSize: 12, color: const Color(0xFF6A4053))),
                        Expanded(child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text('- ' * (constraints.maxWidth / 8).floor(), maxLines: 1, overflow: TextOverflow.clip, style: TextStyle(color: const Color(0xFF99868C))),
                            );
                          },
                        )),
                        Text(item['val']!, style: const TextStyle(fontSize: 12, color: const Color(0xFF6A4053))),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Total: Php, 4,500.00', style: const TextStyle(fontSize: 13, color: const Color(0xFF99868C))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x4D99868C)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Choose Payment Method', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: plum)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('GCash', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
                    const Text('VISA / MC', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
                    const Text('maya', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    // Fallback for steps 0 and 1
    return Center(child: Text('Step $currentStep details here'));
  }
}
