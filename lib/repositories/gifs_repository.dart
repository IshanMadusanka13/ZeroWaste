import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/reward.dart';

class GifsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> buyItem(String userId, int itemPoints) async {
    try {
      return await _firestore.runTransaction((transaction) async {
        DocumentReference rewardRef =
            _firestore.collection('rewards').doc(userId);
        DocumentSnapshot rewardDoc = await transaction.get(rewardRef);

        if (!rewardDoc.exists) {
          return false;
        }

        Reward reward = Reward.fromFirestore(rewardDoc);

        if (reward.points < itemPoints) {
          return false;
        }

        int newPoints = reward.points - itemPoints;
        transaction.update(rewardRef, {'points': newPoints});

        return true;
      });
    } catch (e) {
      print('Error buying item: $e');
      return false;
    }
  }

  Stream<Reward> getRewardStream(String userId) {
    return _firestore
        .collection('rewards')
        .doc(userId)
        .snapshots()
        .map((snapshot) => Reward.fromFirestore(snapshot));
  }
}
