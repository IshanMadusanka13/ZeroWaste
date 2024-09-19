import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/reward_item.dart';

class RewardItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'reward_items';

  Future<void> addItem(RewardItem item) async {
    await _firestore.collection(collection).doc(item.id).set(item.toMap());
  }

  Future<void> updateItem(RewardItem item) async {
    await _firestore.collection(collection).doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }

  Stream<List<RewardItem>> getItems() {
    return _firestore.collection(collection).snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) => RewardItem.fromFirestore(doc),
            )
            .toList();
      },
    );
  }
}
