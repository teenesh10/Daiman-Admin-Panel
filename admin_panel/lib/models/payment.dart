import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String paymentID; // Document ID (auto-generated in subcollection)
  final String paymentMethod; // Payment method (e.g., card, Stripe)
  final double amount; // Payment amount
  final bool isSuccessful; // Payment status
  final DateTime paymentDate; // Payment date

  Payment({
    required this.paymentID,
    required this.paymentMethod,
    required this.amount,
    required this.isSuccessful,
    required this.paymentDate,
  });

  // Convert Firestore document to Payment object
  factory Payment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Payment(
      paymentID: doc.id,
      paymentMethod: data['paymentMethod'] ?? '',
      amount: data['amount']?.toDouble() ?? 0.0,
      isSuccessful: data['isSuccessful'] ?? false,
      paymentDate: (data['paymentDate'] as Timestamp).toDate(),
    );
  }

  // Convert Payment object to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'paymentMethod': paymentMethod,
      'amount': amount,
      'isSuccessful': isSuccessful,
      'paymentDate': Timestamp.fromDate(paymentDate),
    };
  }
}
