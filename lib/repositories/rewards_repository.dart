import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/reward.dart';

class RewardsRepository {
  final CollectionReference _rewardsCollection =
      FirebaseFirestore.instance.collection('rewards');

  Future<void> updateRewardsForUser(String userId, double pointsToAdd) async {
    try {
      DocumentSnapshot rewardDoc = await _rewardsCollection.doc(userId).get();

      if (rewardDoc.exists) {
        Reward existingReward = Reward.fromDocument(rewardDoc);
        int updatedPoints = existingReward.points + pointsToAdd.round();
        await _rewardsCollection.doc(userId).update({'points': updatedPoints});
      } else {
        Reward newReward = Reward(userId: userId, points: pointsToAdd.round());
        await _rewardsCollection.doc(userId).set(newReward.toMap());
      }
    } catch (e) {
      throw Exception('Error updating rewards: $e');
    }
  }

  Future<void> updateRewardPointsBasedOnGarbageEntry(
      String userId, double previousPoints, double newPoints) async {
    try {
      DocumentSnapshot rewardDoc = await _rewardsCollection.doc(userId).get();

      if (rewardDoc.exists) {
        Reward existingReward = Reward.fromDocument(rewardDoc);
        int currentRewardPoints = existingReward.points;
        int pointsDifference = (newPoints - previousPoints).round();

        if (pointsDifference != 0) {
          int updatedPoints = currentRewardPoints + pointsDifference;

          if (updatedPoints < 0) updatedPoints = 0;

          await _rewardsCollection.doc(userId).update({
            'points': updatedPoints,
          });

          print('Reward points updated: $updatedPoints');
        } else {
          print('No change in reward points.');
        }
      } else {
        await _rewardsCollection.doc(userId).set({
          'points': newPoints.round(),
        });

        print('New reward created with points: ${newPoints.round()}');
      }
    } catch (e) {
      throw Exception('Error updating reward points: $e');
    }
  }

  Future<void> reduceRewardPointsOnDelete(
      String userId, double deletedPoints) async {
    try {
      DocumentSnapshot rewardDoc = await _rewardsCollection.doc(userId).get();

      if (rewardDoc.exists) {
        Reward existingReward = Reward.fromDocument(rewardDoc);
        int currentRewardPoints = existingReward.points;

        int updatedPoints = currentRewardPoints - deletedPoints.round();

        if (updatedPoints > 0) {
          await _rewardsCollection.doc(userId).update({
            'points': updatedPoints,
          });
          print('Reward points reduced: $updatedPoints');
        } else {
          await _rewardsCollection.doc(userId).delete();
          print('Reward deleted due to zero points.');
        }
      } else {
        print('No reward found for user.');
      }
    } catch (e) {
      throw Exception('Error reducing reward points: $e');
    }
  }
}
