import 'package:cloud_firestore/cloud_firestore.dart';

class GarbageEntry {
  final String id;
  final String userId;
  final double plasticWeight;
  final double glassWeight;
  final double paperWeight;
  final double organicWeight;
  final double metelWeight;
  final double eWasteWeight;
  final DateTime date;

  GarbageEntry({
    this.id = '',
    required this.userId,
    required this.plasticWeight,
    required this.glassWeight,
    required this.paperWeight,
    required this.organicWeight,
    required this.metelWeight,
    required this.eWasteWeight,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'plasticWeight': plasticWeight,
      'glassWeight': glassWeight,
      'paperWeight': paperWeight,
      'organicWeight': organicWeight,
      'metelWeight': metelWeight,
      'eWasteWeight': eWasteWeight,
      'date': date,
    };
  }

  factory GarbageEntry.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GarbageEntry(
      id: doc.id,
      userId: data['userId'] ?? '',
      plasticWeight: data['plasticWeight']?.toDouble() ?? 0.0,
      glassWeight: data['glassWeight']?.toDouble() ?? 0.0,
      paperWeight: data['paperWeight']?.toDouble() ?? 0.0,
      organicWeight: data['organicWeight']?.toDouble() ?? 0.0,
      metelWeight: data['metelWeight']?.toDouble() ?? 0.0,
      eWasteWeight: data['eWasteWeight']?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

}