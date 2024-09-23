import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/reward_item.dart';

class RewardItemRepository {
  final CollectionReference _rewardItemsCollection =
      FirebaseFirestore.instance.collection('reward_items');

  Future<void> addItem(RewardItem item) async {
    try {
      await _rewardItemsCollection.doc(item.id).set(item.toMap());
    } catch (error) {
      throw Exception("Error Adding Reward Items : $error");
    }
  }

  Future<void> updateItem(RewardItem item) async {
    try {
      await _rewardItemsCollection.doc(item.id).update(item.toMap());
    } catch (error) {
      throw Exception("Error Updating Reward Items : $error");
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _rewardItemsCollection.doc(id).delete();
    } catch (error) {
      throw Exception("Error Deleting Reward Items : $error");
    }
  }

  Stream<List<RewardItem>> getItems() {
    try {
      return _rewardItemsCollection.snapshots().map(
        (snapshot) {
          return snapshot.docs
              .map(
                (doc) => RewardItem.fromDocument(doc),
              )
              .toList();
        },
      );
    } catch (error) {
      throw Exception("Error Getting Reward Items : $error");
    }
  }
}
