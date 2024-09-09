import 'package:cloud_firestore/cloud_firestore.dart';

class Reward {
  final String userId;
  final int points;
  final String prize;

  Reward({
    required this.userId,
    required this.points,
    required this.prize,
  });

  factory Reward.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reward(
      userId: data['userId'] ?? '',
      points: data['points'] ?? 0,
      prize: data['prize'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'points': points,
      'prize': prize,
    };
  }
}
