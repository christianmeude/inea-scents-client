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
  final _formKey = GlobalKey<FormState>();

  static const Color primary = Color(0xFF74445C);
  static const Color primaryDark = Color(0xFF633E50);
  static const Color secondary = Color(0xFF765867);

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
    final bookingFlow = ref.watch(bookingFlowProvider);
    final packageAsync = ref.watch(packageDetailsProvider(widget.packageId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: primary),
        ),
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'INEA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            Text(
              'Scents',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: packageAsync.when(
          data: (package) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  child: _buildProgressIndicator(bookingFlow.currentStep),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildStepContent(
                        bookingFlow.currentStep,
                        package,
                        bookingFlow,
                        ref,
                        context,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildNavigationButtons(bookingFlow),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    final steps = ['Package', 'Date', 'Scents', 'Details', 'Payment'];
    return Column(
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            final isActive = index <= currentStep;
            final isCompleted = index < currentStep;
            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? primary : Colors.grey[300],
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : Text('${index + 1}', style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < currentStep ? primary : Colors.grey[300],
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: steps.map((step) {
            final index = steps.indexOf(step);
            return Text(
              step,
              style: TextStyle(
                fontSize: 10,
                fontWeight: index <= currentStep ? FontWeight.bold : FontWeight.normal,
                color: index <= currentStep ? primary : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStepContent(
    int step,
    Package package,
    BookingFlowState bookingFlow,
    WidgetRef ref,
    BuildContext context,
  ) {
    switch (step) {
      case 0: return _buildPackageStep(package);
      case 1: return _buildScheduleStep(package, ref);
      case 2: return _buildScentsStep(package, ref);
      case 3: return _buildDetailsStep(package, bookingFlow, ref);
      case 4: return _buildPaymentStep(bookingFlow, ref);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildPackageStep(Package package) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage((package.images != null && package.images!.isNotEmpty) ? package.images![0] : 'https://via.placeholder.com/300'),
              fit: BoxFit.cover,
            ),
          ),
          height: 200,
        ),
        const SizedBox(height: 16),
        Text(package.name ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(package.description ?? '', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 16),
        Text('Php. ${(package.price ?? 0).toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
      ],
    );
  }

  Widget _buildScentsStep(Package package, WidgetRef ref) {
    final bookingFlow = ref.watch(bookingFlowProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Please Choose Available Scents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        if (package.scents == null || package.scents!.isEmpty)
          const Text('No scents available')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: package.scents!.length,
            itemBuilder: (context, index) {
              final scent = package.scents![index];
              final isSelected = bookingFlow.selectedScentIds.contains(scent.id!);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? primary : Colors.grey[300]!, width: isSelected ? 2 : 1),
                ),
                child: Material(
                  color: isSelected ? primary.withValues(alpha: 0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => ref.read(bookingFlowProvider.notifier).toggleScent(scent.id!),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Checkbox(value: isSelected, onChanged: (_) => ref.read(bookingFlowProvider.notifier).toggleScent(scent.id!)),
                          Expanded(child: Text(scent.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildScheduleStep(Package package, WidgetRef ref) {
    final bookingFlow = ref.watch(bookingFlowProvider);
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          firstDay: now,
          lastDay: DateTime(now.year + 1, 12, 31),
          focusedDay: bookingFlow.selectedDate ?? now,
          selectedDayPredicate: (day) => isSameDay(bookingFlow.selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) => ref.read(bookingFlowProvider.notifier).setSelectedDate(selectedDay),
        ),
        const SizedBox(height: 16),
        DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: bookingFlow.selectedPax,
            isExpanded: true,
            onChanged: (value) { if (value != null) ref.read(bookingFlowProvider.notifier).setSelectedPax(value); },
            items: (package.paxOptions ?? []).map((pax) => DropdownMenuItem(value: pax, child: Text('$pax guests'))).toList(),
            hint: const Text('Select number of guests'),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsStep(Package package, BookingFlowState bookingFlow, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text(bookingFlow.selectedPackage?.name ?? 'Unknown Package', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: primaryDark)),
        if (bookingFlow.selectedDate != null) Text('Selected Date: ${bookingFlow.selectedDate!.toLocal().toString().split(' ')[0]}', style: const TextStyle(color: secondary, fontSize: 13)),
        const SizedBox(height: 16),
        TextFormField(
          readOnly: true,
          decoration: const InputDecoration(labelText: 'Event Time', border: OutlineInputBorder(), hintText: 'Tap to select time'),
          controller: TextEditingController(text: bookingFlow.selectedTime),
          onTap: () async {
            final TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null && context.mounted) {
              ref.read(bookingFlowProvider.notifier).setSelectedTime(time.format(context));
            }
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Event time is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: bookingFlow.customerName,
          decoration: const InputDecoration(labelText: 'Customer Name', border: OutlineInputBorder(), hintText: 'John Doe'),
          onChanged: (value) => ref.read(bookingFlowProvider.notifier).setCustomerName(value),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: bookingFlow.customerEmail,
          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder(), hintText: 'john@example.com'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email is required';
            }
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value.trim())) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          onChanged: (value) => ref.read(bookingFlowProvider.notifier).setCustomerEmail(value.trim()),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: bookingFlow.customerPhone,
          decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder(), hintText: '09123456789'),
          onChanged: (value) => ref.read(bookingFlowProvider.notifier).setCustomerPhone(value),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: bookingFlow.venueAddress,
          decoration: const InputDecoration(labelText: 'Venue Address', border: OutlineInputBorder()),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Venue address is required';
            }
            return null;
          },
          onChanged: (value) => ref.read(bookingFlowProvider.notifier).setVenueAddress(value),
        ),
      ],
    );
  }

  Widget _buildPaymentStep(BookingFlowState bookingFlow, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Base Price'), Text('${bookingFlow.selectedPackage?.price ?? 0}')]),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, color: primary)), Text('Php. ${bookingFlow.totalPrice}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: primary))]),
            ],
          ),
        ),
        const SizedBox(height: 24),
        for (final method in ['Credit Card', 'Bank Transfer', 'GCash']) 
          Builder(builder: (context) {
            final isSelected = bookingFlow.paymentMethod == method;
            return GestureDetector(
              onTap: () => ref.read(bookingFlowProvider.notifier).setPaymentMethod(method),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all(color: isSelected ? primary : Colors.grey), borderRadius: BorderRadius.circular(8)),
                child: Text(method),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildNavigationButtons(BookingFlowState bookingFlow) {
    return Row(
      children: [
        if (bookingFlow.currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () => ref.read(bookingFlowProvider.notifier).previousStep(),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Back', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
            ),
          ),
        if (bookingFlow.currentStep > 0) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: bookingFlow.currentStep < 4
                ? () {
                    if (bookingFlow.currentStep == 1) {
                      if (bookingFlow.selectedPax == null || bookingFlow.selectedPax == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a valid number of guests (PAX)')),
                        );
                        return;
                      }
                    }
                    if (bookingFlow.currentStep == 3) {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                    }
                    ref.read(bookingFlowProvider.notifier).nextStep();
                  }
                : () async {
                    if (_formKey.currentState!.validate()) {
                      if (bookingFlow.selectedPax == null || bookingFlow.selectedPax == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid PAX selection.')),
                        );
                        return;
                      }
                      final booking = await ref.read(bookingFlowProvider.notifier).submitBooking();
                      if (booking != null && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking submitted successfully!')));
                        context.go('/calendar');
                        ref.read(bookingFlowProvider.notifier).reset();
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ref.read(bookingFlowProvider).errorMessage ?? 'Error')));
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              bookingFlow.currentStep < 4 ? 'Next' : 'Confirm & Pay',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
