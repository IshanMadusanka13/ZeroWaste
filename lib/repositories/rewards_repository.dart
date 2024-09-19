import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/reward.dart';
import 'package:zero_waste/models/garbage_entry.dart';

class RewardsRepository {
  final CollectionReference _rewardsCollection =
      FirebaseFirestore.instance.collection('rewards');
  final CollectionReference _garbageEntriesCollection =
      FirebaseFirestore.instance.collection('garbageEntries');

  /// This method updates rewards by calculating the total points from garbage entries for each user
  Future<void> updateRewardsFromGarbageEntries() async {
    try {
      // Fetch all garbage entries
      QuerySnapshot garbageEntries = await _garbageEntriesCollection.get();

      // Iterate over all garbage entries
      for (QueryDocumentSnapshot doc in garbageEntries.docs) {
        GarbageEntry entry = GarbageEntry.fromFirestore(doc);

        // Fetch the corresponding reward document for the user
        DocumentSnapshot rewardDoc =
            await _rewardsCollection.doc(entry.userId).get();

        if (rewardDoc.exists) {
          // If a reward exists for the user, update their points
          Reward existingReward = Reward.fromFirestore(rewardDoc);
          int updatedPoints = existingReward.points + entry.totalPoints.round();

          await _rewardsCollection.doc(entry.userId).update({
            'points': updatedPoints,
          });
        } else {
          // If no reward exists for the user, create a new reward document
          Reward newReward = Reward(
            userId: entry.userId,
            points: entry.totalPoints.round(),
          );

          await _rewardsCollection
              .doc(entry.userId)
              .set(newReward.toFirestore());
        }
      }
    } catch (e) {
      throw Exception('Error updating rewards: $e');
    }
  }

  /// This method recalculates total points from garbage entries for each user in the rewards collection
  Future<void> recalculateTotalRewards() async {
    try {
      // Fetch all reward documents
      QuerySnapshot rewardsSnapshot = await _rewardsCollection.get();

      // Iterate over each reward document to recalculate the points
      for (QueryDocumentSnapshot rewardDoc in rewardsSnapshot.docs) {
        String userId = rewardDoc.id;

        // Fetch all garbage entries for the specific user
        QuerySnapshot userGarbageEntries = await _garbageEntriesCollection
            .where('userId', isEqualTo: userId)
            .get();

        int totalPoints = 0;

        // Calculate total points from all the user's garbage entries
        for (QueryDocumentSnapshot entryDoc in userGarbageEntries.docs) {
          GarbageEntry entry = GarbageEntry.fromFirestore(entryDoc);
          totalPoints += entry.totalPoints.round();
        }

        if (totalPoints > 0) {
          // Update the total points in the rewards collection if points are greater than 0
          await _rewardsCollection.doc(userId).update({
            'points': totalPoints,
          });
        } else {
          // Delete the reward document if total points are 0
          await _rewardsCollection.doc(userId).delete();
        }
      }
    } catch (e) {
      throw Exception('Error recalculating rewards: $e');
    }
  }
}
