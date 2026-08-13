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
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _loadPackage();
  }

  void _loadPackage() async {
    final packageAsync = ref.read(packageDetailsProvider(widget.packageId));
    packageAsync.whenData((package) {
      ref.read(bookingFormProvider.notifier).setSelectedPackage(package);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingForm = ref.watch(bookingFormProvider);
    final packageAsync = ref.watch(packageDetailsProvider(widget.packageId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: Color(0xFF8B6B7C)),
        ),
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'INEA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B6B7C),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.message, color: Color(0xFF8B6B7C)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark, color: Color(0xFF8B6B7C)),
            onPressed: () {},
          ),
        ],
      ),
      body: packageAsync.when(
        data: (package) {
          return Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(20),
                child: _buildProgressIndicator(currentStep),
              ),
              // Step content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildStepContent(
                      currentStep,
                      package,
                      bookingForm,
                      ref,
                      context,
                    ),
                  ),
                ),
              ),
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: _buildNavigationButtons(),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    final steps = ['Package', 'Scents', 'Schedule', 'Details', 'Payment'];
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
                      color: isActive
                          ? const Color(0xFF8B6B7C)
                          : Colors.grey[300],
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < currentStep
                            ? const Color(0xFF8B6B7C)
                            : Colors.grey[300],
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
                fontWeight: index <= currentStep
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: index <= currentStep
                    ? const Color(0xFF8B6B7C)
                    : Colors.grey,
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
    BookingFormState bookingForm,
    WidgetRef ref,
    BuildContext context,
  ) {
    switch (step) {
      case 0:
        return _buildPackageStep(package);
      case 1:
        return _buildScentsStep(package, ref);
      case 2:
        return _buildScheduleStep(package, ref);
      case 3:
        return _buildDetailsStep(package, bookingForm, ref);
      case 4:
        return _buildPaymentStep(bookingForm, ref);
      default:
        return const SizedBox.shrink();
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
              image: NetworkImage(
                package.images.isNotEmpty
                    ? package.images[0]
                    : 'https://via.placeholder.com/300',
              ),
              fit: BoxFit.cover,
            ),
          ),
          height: 200,
        ),
        const SizedBox(height: 16),
        Text(
          package.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          package.description,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        Text(
          'Php. ${package.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8B6B7C),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Inclusions:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...package.inclusions.map((inclusion) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(inclusion)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildScentsStep(Package package, WidgetRef ref) {
    final bookingForm = ref.watch(bookingFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Please Choose Available Scents',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (package.scents.isEmpty)
          const Text('No scents available')
        else
          Column(
            children: package.scents.map((scent) {
              final isSelected = bookingForm.selectedScentIds.contains(
                scent.id,
              );
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF8B6B7C)
                        : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Material(
                  color: isSelected
                      ? const Color(0xFF8B6B7C).withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ref
                          .read(bookingFormProvider.notifier)
                          .toggleScent(scent.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              ref
                                  .read(bookingFormProvider.notifier)
                                  .toggleScent(scent.id);
                            },
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  scent.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  scent.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildScheduleStep(Package package, WidgetRef ref) {
    final bookingForm = ref.watch(bookingFormProvider);
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Please Choose Available Schedule',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Booked', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 16),
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF8B6B7C),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Available', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: TableCalendar(
            firstDay: now,
            lastDay: DateTime(now.year, now.month + 3, 0),
            focusedDay: bookingForm.selectedDate ?? now,
            selectedDayPredicate: (day) {
              return isSameDay(bookingForm.selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              ref
                  .read(bookingFormProvider.notifier)
                  .setSelectedDate(selectedDay);
            },
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontSize: 12),
              weekendStyle: TextStyle(fontSize: 12),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF8B6B7C),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Please Choose Available Pax',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<int>(
            value: bookingForm.selectedPax,
            isExpanded: true,
            underline: const SizedBox(),
            onChanged: (value) {
              if (value != null) {
                ref.read(bookingFormProvider.notifier).setSelectedPax(value);
              }
            },
            items: package.pax_options.map((pax) {
              return DropdownMenuItem(value: pax, child: Text('$pax guests'));
            }).toList(),
            hint: const Text('Select number of guests'),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsStep(
    Package package,
    BookingFormState bookingForm,
    WidgetRef ref,
  ) {
    final nameController = TextEditingController(
      text: bookingForm.customerName,
    );
    final emailController = TextEditingController(
      text: bookingForm.customerEmail,
    );
    final phoneController = TextEditingController(
      text: bookingForm.customerPhone,
    );
    final addressController = TextEditingController(
      text: bookingForm.venueAddress,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Package Variation: ${package.name}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                'Inclusions: ${package.inclusions.join(', ')}',
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (bookingForm.selectedDate != null)
                Text(
                  'Selected Date: ${bookingForm.selectedDate!.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 12),
                ),
              const SizedBox(height: 4),
              Text(
                'Total Cost: Php. ${package.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B6B7C),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Customer Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (value) {
            ref.read(bookingFormProvider.notifier).setCustomerName(value);
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (value) {
            ref.read(bookingFormProvider.notifier).setCustomerEmail(value);
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: 'Phone',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (value) {
            ref.read(bookingFormProvider.notifier).setCustomerPhone(value);
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: 'Venue Address',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 3,
          onChanged: (value) {
            ref.read(bookingFormProvider.notifier).setVenueAddress(value);
          },
        ),
      ],
    );
  }

  Widget _buildPaymentStep(BookingFormState bookingForm, WidgetRef ref) {
    const paymentMethods = ['GCash', 'VISA', 'Mastercard', 'Maya'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Featuring your logo'),
                  Text('${bookingForm.selectedPackage?.price ?? 0}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('4 Inspired scents'), const Text('800')],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('Perfume Bar Setup'), const Text('1500')],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B6B7C),
                    ),
                  ),
                  Text(
                    'Php. ${(bookingForm.selectedPackage?.price ?? 0) + 800 + 1500}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B6B7C),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Choose Payment Method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: paymentMethods.map((method) {
              final isSelected = bookingForm.paymentMethod == method;
              return GestureDetector(
                onTap: () {
                  ref
                      .read(bookingFormProvider.notifier)
                      .setPaymentMethod(method);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? const Color(0xFF8B6B7C) : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                        ? const Color(0xFF8B6B7C).withValues(alpha: 0.1)
                        : Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    method,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? const Color(0xFF8B6B7C)
                          : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (currentStep > 0)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() => currentStep--);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF8B6B7C)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  color: Color(0xFF8B6B7C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (currentStep > 0) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: currentStep < 4
                ? () {
                    setState(() => currentStep++);
                  }
                : () async {
                    final booking = await ref
                        .read(bookingFormProvider.notifier)
                        .submitBooking();
                    if (booking != null && mounted) {
                      context.go('/home');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking submitted successfully!'),
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B6B7C),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              currentStep < 4 ? 'Next' : 'Confirm & Pay',
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
