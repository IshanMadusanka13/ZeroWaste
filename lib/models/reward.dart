import 'package:cloud_firestore/cloud_firestore.dart';

class Reward {
  final String userId;
  final int points;

  Reward({
    required this.userId,
    required this.points,
  });

  factory Reward.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reward(
      userId: data['userId'] ?? '',
      points: data['points'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'points': points,
    };
  }
}
