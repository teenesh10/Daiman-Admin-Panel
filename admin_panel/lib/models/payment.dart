import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String paymentID; 
  final String paymentMethod; 
  final double amount; 
  final bool isSuccessful; 
  final DateTime paymentDate; 

  Payment({
    required this.paymentID,
    required this.paymentMethod,
    required this.amount,
    required this.isSuccessful,
    required this.paymentDate,
  });

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

  Map<String, dynamic> toFirestore() {
    return {
      'paymentMethod': paymentMethod,
      'amount': amount,
      'isSuccessful': isSuccessful,
      'paymentDate': Timestamp.fromDate(paymentDate),
    };
  }
}
