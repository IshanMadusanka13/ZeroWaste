import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/business_owner.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/repositories/user_repository.dart';

class BusinessOwnerRepository {
  final CollectionReference _businessOwnerCollection =
      FirebaseFirestore.instance.collection('businessOwner');

  Future<void> addBusinessUser(User user, BusinessOwner businessOwner) async {
    try {
      DocumentReference userId = await UserRepository().addUser(user);
      businessOwner.userId = userId.id;
      await _businessOwnerCollection.add(businessOwner.toMap());
    } catch (e) {
      throw Exception('Error adding BusinessOwner: $e');
    }
  }

  Future<void> updateBusinessUser(
      String userId, BusinessOwner businessOwner) async {
    try {
      await _businessOwnerCollection.doc(userId).update(businessOwner.toMap());
    } catch (e) {
      throw Exception('Error updating BusinessOwner: $e');
    }
  }

  Future<void> deleteBusinessUser(String userId) async {
    try {
      await _businessOwnerCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Error deleting BusinessOwner: $e');
    }
  }

  Future<List<BusinessOwner>> getAllBusinessUsers() async {
    try {
      QuerySnapshot snapshot = await _businessOwnerCollection.get();
      return snapshot.docs
          .map((doc) => BusinessOwner.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Error getting all BusinessOwner: $e');
    }
  }

  Future<BusinessOwner> getBusinessUser(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _businessOwnerCollection.doc(userId).get();
      if (snapshot.exists) {
        return BusinessOwner.fromDocument(snapshot);
      } else {
        throw Exception('BusinessOwner not found');
      }
    } catch (e) {
      throw Exception('Error getting BusinessOwner: $e');
    }
  }
}
