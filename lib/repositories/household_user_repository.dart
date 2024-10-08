import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/household_user.dart';

class HouseholdUserRepository {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('householdUser');

  Future<void> addUser(HouseholdUser user) async {
    try {
      await _usersCollection.add(user.toMap());
    } catch (e) {
      throw Exception('Error adding HouseholdUser: $e');
    }
  }

  Future<void> updateUser(String userId, HouseholdUser user) async {
    try {
      await _usersCollection.doc(userId).update(user.toMap());
    } catch (e) {
      throw Exception('Error updating HouseholdUser: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Error deleting HouseholdUser: $e');
    }
  }

  Future<List<HouseholdUser>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _usersCollection.get();
      return snapshot.docs.map((doc) => HouseholdUser.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all HouseholdUser: $e');
    }
  }

  Future<HouseholdUser> getUser(String userId) async {
    try {
      DocumentSnapshot snapshot = await _usersCollection.doc(userId).get();
      if (snapshot.exists) {
        return HouseholdUser.fromDocument(snapshot);
      } else {
        throw Exception('HouseholdUser not found');
      }
    } catch (e) {
      throw Exception('Error getting HouseholdUser: $e');
    }
  }

}