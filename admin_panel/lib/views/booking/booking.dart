import 'package:admin_panel/models/bookingDataSource.dart';
import 'package:admin_panel/models/facility.dart';
import 'package:admin_panel/views/widgets/court_availability.dart';
import 'package:admin_panel/views/widgets/header.dart';
import 'package:admin_panel/views/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:admin_panel/models/booking.dart';
import 'package:admin_panel/controllers/manage_booking_controller.dart';
import 'package:admin_panel/controllers/manage_facility_controller.dart';
import 'package:intl/intl.dart';

class ManageBookingView extends StatefulWidget {
  const ManageBookingView({super.key});

  @override
  State<ManageBookingView> createState() => _ManageBookingViewState();
}

class _ManageBookingViewState extends State<ManageBookingView> {
  final ManageBookingController _bookingController = ManageBookingController();
  final ManageFacilityController _facilityController =
      ManageFacilityController();
  String? selectedFacilityId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(flex: 1, child: SideMenu()),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                const Header(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Manage Bookings",
                          style: Theme.of(context).textTheme.titleLarge),
                      StreamBuilder<List<Facility>>(
                        stream: _facilityController.getFacilities(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          return DropdownButton<String>(
                            hint: const Text("Filter by Facility"),
                            value: selectedFacilityId,
                            items: snapshot.data!.map((facility) {
                              return DropdownMenuItem(
                                value: facility.facilityID,
                                child: Text(facility.facilityName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => selectedFacilityId = value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<List<Booking>>(
                    stream: _bookingController.getBookings(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final List<Booking> allBookings =
                          snapshot.data!.cast<Booking>();

                      final filtered = selectedFacilityId == null
                          ? <Booking>[]
                          : allBookings
                              .where((b) => b.facilityID == selectedFacilityId)
                              .toList();

                      return SfCalendar(
                        view: CalendarView.month,
                        allowedViews: null, 
                        showNavigationArrow: true,
                        showDatePickerButton: true,
                        dataSource: BookingDataSource(filtered),
                        monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.none,
                        ),
                        todayHighlightColor: Theme.of(context).primaryColor,
                        selectionDecoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onTap: (details) async {
                          if ((details.targetElement ==
                                      CalendarElement.calendarCell ||
                                  details.targetElement ==
                                      CalendarElement.agenda) &&
                              details.date != null) {
                            final DateTime selectedDate = details.date!;

                            if (selectedFacilityId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Please select a facility first."),
                                ),
                              );
                              return;
                            }

                            final bookingsOnDate = filtered
                                .where((booking) =>
                                    booking.date.year == selectedDate.year &&
                                    booking.date.month == selectedDate.month &&
                                    booking.date.day == selectedDate.day)
                                .toList();

                            _facilityController
                                .getCourtsForFacility(selectedFacilityId!)
                                .first
                                .then((courts) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(
                                    "Availability on ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                                  ),
                                  content: CourtAvailabilityMatrix(
                                    courts: courts,
                                    bookings: bookingsOnDate,
                                    selectedDate: selectedDate,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Theme.of(context)
                                            .primaryColor, 
                                      ),
                                      child: const Text("Close"),
                                    ),
                                  ],
                                ),
                              );
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
