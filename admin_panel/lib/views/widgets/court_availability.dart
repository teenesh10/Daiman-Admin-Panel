import 'package:admin_panel/controllers/manage_booking_controller.dart';
import 'package:admin_panel/models/booking.dart';
import 'package:admin_panel/models/court.dart';
import 'package:admin_panel/views/widgets/booking_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourtAvailabilityMatrix extends StatelessWidget {
  final List<Court> courts;
  final List<Booking> bookings;
  final DateTime selectedDate;

  const CourtAvailabilityMatrix({
    super.key,
    required this.courts,
    required this.bookings,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final List<DateTime> timeSlots = [];
    DateTime start =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 8, 0);
    DateTime end = start.add(const Duration(hours: 18));

    while (start.isBefore(end)) {
      timeSlots.add(start);
      start = start.add(const Duration(minutes: 30));
    }

    final List<List<DateTime>> slotPairs = [];
    for (int i = 0; i < timeSlots.length; i += 2) {
      if (i + 1 < timeSlots.length) {
        slotPairs.add([timeSlots[i], timeSlots[i + 1]]);
      } else {
        slotPairs.add([timeSlots[i]]);
      }
    }

    final sortedCourts = [...courts]
      ..sort((a, b) => a.courtName.compareTo(b.courtName));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegend(),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sticky court names
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  ...sortedCourts.map((court) => Container(
                        width: 100,
                        height: 60,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          court.courtName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ),
              const SizedBox(width: 8),
              // Time slot columns
              ...slotPairs.map(
                (pair) => Column(
                  children: [
                    // Header time slots
                    Container(
                      width: 70,
                      height: 40,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: pair
                            .map((slot) => Text(
                                  DateFormat.jm().format(slot),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    // Cells for each court
                    ...sortedCourts.map((court) {
                      Booking? matchedBooking;

                      for (var slot in pair) {
                        for (var booking in bookings) {
                          bool courtIncluded = booking.courts
                              .any((c) => c['courtID'] == court.courtID);
                          if (!courtIncluded) continue;

                          DateTime bookingStart = booking.startTime;
                          DateTime bookingEnd = bookingStart
                              .add(Duration(hours: booking.duration));

                          if (slot.isAtSameMomentAs(bookingStart) ||
                              (slot.isAfter(bookingStart) &&
                                  slot.isBefore(bookingEnd))) {
                            matchedBooking = booking;
                            break;
                          }
                        }
                        if (matchedBooking != null) break;
                      }

                      return GestureDetector(
                        onTap: matchedBooking != null
                            ? () async {
                                final controller = ManageBookingController();
                                final userInfo =
                                    await controller.getBookingUserDetails(
                                        matchedBooking!.userID);
                                if (context.mounted) {
                                  showBookingDetailsDialog(
                                      context, matchedBooking, userInfo);
                                }
                              }
                            : null,
                        child: Container(
                          width: 70,
                          height: 60,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 4),
                          decoration: BoxDecoration(
                            color: matchedBooking != null
                                ? Colors.red
                                : Colors.green,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _legendBox(Colors.green, "Available"),
        const SizedBox(width: 12),
        _legendBox(Colors.red, "Booked"),
      ],
    );
  }

  Widget _legendBox(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(label),
      ],
    );
  }
}
