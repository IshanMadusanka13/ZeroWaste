import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/household_user.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/repositories/user_repository.dart';

class HouseholdUserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('householdUser');

  Future<void> addUser(User user, HouseholdUser householdUser) async {
    try {
      DocumentReference userId = await UserRepository().addUser(user);
      householdUser.userId = userId.id;
      await _usersCollection.add(householdUser.toMap());
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
      return snapshot.docs
          .map((doc) => HouseholdUser.fromDocument(doc))
          .toList();
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

  Future<HouseholdUser?> getHouseholdUserByUserId(String userId) async {
    print(userId);
    try {
      QuerySnapshot querySnapshot =
          await _usersCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        return HouseholdUser.fromDocument(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting HouseholdUser by email: $e');
      return null;
    }
  }
}
