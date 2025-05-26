import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String bookingID;
  String userID;
  String facilityID;
  String courtID;
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
    required this.courtID,
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
      'courtID': courtID,
      'date': date,
      'startTime': startTime,
      'duration': duration,
      'bookingMade': bookingMade,
      'paymentMethod': paymentMethod,
      'amountPaid': amountPaid,
    };
  }

  factory Booking.fromFirestore(Map<String, dynamic> map, String documentId) {
    return Booking(
      bookingID: documentId, // use Firestore doc ID for consistency
      userID: map['userID'] ?? '',
      facilityID: map['facilityID'] ?? '',
      courtID: map['courtID'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      startTime: (map['startTime'] as Timestamp).toDate(),
      duration: map['duration'] ?? 0,
      bookingMade: (map['bookingMade'] as Timestamp).toDate(),
      paymentMethod: map['paymentMethod'] ?? '',
      amountPaid: (map['amountPaid'] as num).toDouble(),
    );
  }
}
