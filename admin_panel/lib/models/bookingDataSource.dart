// ignore_for_file: file_names

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/models/booking.dart';

class BookingDataSource extends CalendarDataSource {
  BookingDataSource(List<Booking> bookings) {
    appointments = bookings;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startTime;

  @override
  DateTime getEndTime(int index) {
    final Booking booking = appointments![index];
    return booking.startTime.add(Duration(hours: booking.duration));
  }

  @override
  String getSubject(int index) {
    final Booking booking = appointments![index];
    final courtNames = booking.courts.map((c) => c['courtName']).join(', ');
    return 'Facility: ${booking.facilityID}\nCourts: $courtNames';
  }

  @override
  Color getColor(int index) => Colors.blueAccent;

  @override
  bool isAllDay(int index) => false;
}
