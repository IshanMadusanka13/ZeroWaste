import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/garbage_entry.dart';
import 'package:zero_waste/repositories/rewards_repository.dart';

class GarbageEntryRepository {
  final CollectionReference _garbageEntryCollectionCollection =
      FirebaseFirestore.instance.collection('garbageEntries');

  Future<void> addEntry(GarbageEntry garbageEntry) async {
    try {
      await _garbageEntryCollectionCollection.add(garbageEntry.toMap());
    } catch (e) {
      throw Exception('Error adding GarbageEntry: $e');
    }
  }

  Future<void> updateEntry(String garbageId, GarbageEntry garbageEntry) async {
    try {
      await _garbageEntryCollectionCollection
          .doc(garbageId)
          .update(garbageEntry.toMap());
    } catch (e) {
      throw Exception('Error updating GarbageEntry: $e');
    }
  }

  // Future<void> deleteEntry(String garbageId) async {
  //   try {
  //     await _garbageEntryCollectionCollection.doc(garbageId).delete();
  //   } catch (e) {
  //     throw Exception('Error deleting GarbageEntry: $e');
  //   }
  // }

  Future<void> deleteEntry(String garbageId) async {
    try {
      // Fetch the garbage entry to get its total points before deletion
      DocumentSnapshot garbageDoc =
          await _garbageEntryCollectionCollection.doc(garbageId).get();

      if (garbageDoc.exists) {
        GarbageEntry entry = GarbageEntry.fromFirestore(garbageDoc);

        // Call the function to reduce the reward points
        await RewardsRepository()
            .reduceRewardPointsOnDelete(entry.userId, entry.totalPoints);

        // Now delete the garbage entry
        await _garbageEntryCollectionCollection.doc(garbageId).delete();

        print('Garbage entry deleted successfully.');
      } else {
        print('Garbage entry not found.');
      }
    } catch (e) {
      throw Exception('Error deleting GarbageEntry: $e');
    }
  }
}
