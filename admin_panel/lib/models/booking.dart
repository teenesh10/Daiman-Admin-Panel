import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String bookingID;
  String userID;
  String facilityID;
  List<Map<String, dynamic>> courts;
  DateTime date;
  DateTime startTime;
  int duration;
  DateTime bookingMade;
  String paymentMethod;
  double amountPaid;

  Booking({
    required this.bookingID,
    required this.userID,
    required this.facilityID,
    required this.courts,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.bookingMade,
    required this.paymentMethod,
    required this.amountPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookingID': bookingID,
      'userID': userID,
      'facilityID': facilityID,
      'courts': courts,
      'date': Timestamp.fromDate(date),
      'startTime': Timestamp.fromDate(startTime),
      'duration': duration,
      'bookingMade': Timestamp.fromDate(bookingMade),
      'paymentMethod': paymentMethod,
      'amountPaid': amountPaid,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      bookingID: map['bookingID'] ?? '',
      userID: map['userID'] ?? '',
      facilityID: map['facilityID'] ?? '',
      courts: List<Map<String, dynamic>>.from(map['courts'] ?? []),
      date: (map['date'] as Timestamp).toDate(),
      startTime: (map['startTime'] as Timestamp).toDate(),
      duration: map['duration'] ?? 0,
      bookingMade: (map['bookingMade'] as Timestamp).toDate(),
      paymentMethod: map['paymentMethod'] ?? '',
      amountPaid: (map['amountPaid'] as num).toDouble(),
    );
  }
}
