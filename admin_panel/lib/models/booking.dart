import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String bookingID; // Document ID
  final String userID; // Reference to the user
  final String facilityID; // Reference to the facility
  final String courtID; // Reference to the court
  final String paymentID; // Reference to the payment
  final DateTime bookingDate; // Booking date
  final String timeslot; // Selected timeslot
  final int duration; // Duration in hours
  final double amount; // Total amount paid

  Booking({
    required this.bookingID,
    required this.userID,
    required this.facilityID,
    required this.courtID,
    required this.paymentID,
    required this.bookingDate,
    required this.timeslot,
    required this.duration,
    required this.amount,
  });

  // Convert Firestore document to Booking object
  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Booking(
      bookingID: doc.id,
      userID: data['userID'] ?? '',
      facilityID: data['facilityID'] ?? '',
      courtID: data['courtID'] ?? '',
      paymentID: data['paymentID'] ?? '',
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      timeslot: data['timeslot'] ?? '',
      duration: data['duration'] ?? 0,
      amount: data['amount']?.toDouble() ?? 0.0,
    );
  }

  // Convert Booking object to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userID': userID,
      'facilityID': facilityID,
      'courtID': courtID,
      'paymentID': paymentID,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'timeslot': timeslot,
      'duration': duration,
      'amount': amount,
    };
  }
}
