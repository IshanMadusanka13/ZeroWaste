import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/reward.dart';
import 'package:zero_waste/models/garbage_entry.dart';

class RewardsRepository {
  final CollectionReference _rewardsCollection =
      FirebaseFirestore.instance.collection('rewards');
  final CollectionReference _garbageEntriesCollection =
      FirebaseFirestore.instance.collection('garbageEntries');

  Future<void> updateRewardsForUser(String userId, double pointsToAdd) async {
    try {
      DocumentSnapshot rewardDoc = await _rewardsCollection.doc(userId).get();

      if (rewardDoc.exists) {
        Reward existingReward = Reward.fromFirestore(rewardDoc);
        int updatedPoints = existingReward.points + pointsToAdd.round();
        await _rewardsCollection.doc(userId).update({'points': updatedPoints});
      } else {
        // Create a new reward document for the user
        Reward newReward = Reward(userId: userId, points: pointsToAdd.round());
        await _rewardsCollection.doc(userId).set(newReward.toFirestore());
      }
    } catch (e) {
      throw Exception('Error updating rewards: $e');
    }
  }

  /// This method updates the rewards based on the difference between previous
  /// and new garbage entry total points
  Future<void> updateRewardPointsBasedOnGarbageEntry(
      String userId, double previousPoints, double newPoints) async {
    try {
      // Fetch the current reward document for the user
      DocumentSnapshot rewardDoc = await _rewardsCollection.doc(userId).get();

      if (rewardDoc.exists) {
        Reward existingReward = Reward.fromFirestore(rewardDoc);
        int currentRewardPoints = existingReward.points;
        int pointsDifference = (newPoints - previousPoints).round();

        // Update the reward points based on the points difference
        if (pointsDifference != 0) {
          int updatedPoints = currentRewardPoints + pointsDifference;

          if (updatedPoints < 0) updatedPoints = 0; // Ensure no negative points

          await _rewardsCollection.doc(userId).update({
            'points': updatedPoints,
          });

          print('Reward points updated: $updatedPoints');
        } else {
          print('No change in reward points.');
        }
      } else {
        // If no reward exists, create a new one with the new points
        await _rewardsCollection.doc(userId).set({
          'points': newPoints.round(),
        });

        print('New reward created with points: ${newPoints.round()}');
      }
    } catch (e) {
      throw Exception('Error updating reward points: $e');
    }
  }

  /// This method updates the rewards when a garbage entry is deleted
  Future<void> reduceRewardPointsOnDelete(
      String userId, double deletedPoints) async {
    try {
      // Fetch the current reward document for the user
      DocumentSnapshot rewardDoc = await _rewardsCollection.doc(userId).get();

      if (rewardDoc.exists) {
        Reward existingReward = Reward.fromFirestore(rewardDoc);
        int currentRewardPoints = existingReward.points;

        // Calculate the updated points after deleting the garbage entry
        int updatedPoints = currentRewardPoints - deletedPoints.round();

        if (updatedPoints > 0) {
          // Update the reward document with the reduced points
          await _rewardsCollection.doc(userId).update({
            'points': updatedPoints,
          });
          print('Reward points reduced: $updatedPoints');
        } else {
          // If points drop to zero or below, delete the reward document
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
