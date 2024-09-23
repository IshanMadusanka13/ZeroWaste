import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserRepository {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');

  Future<DocumentReference<Object?>> addUser(User user) async {
    try {
      DocumentReference userRef = await _usersCollection.add(user.toMap());
      return userRef;
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }

  Future<void> updateUser(String userId, User user) async {
    try {
      await _usersCollection.doc(userId).update(user.toMap());
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _usersCollection.get();
      return snapshot.docs.map((doc) => User.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all users: $e');
    }
  }

  Future<User> getUser(String userId) async {
    try {
      DocumentSnapshot snapshot = await _usersCollection.doc(userId).get();
      if (snapshot.exists) {
        return User.fromDocument(snapshot);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  Future<User> login(User user) async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.where('email', isEqualTo: user.email).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        if (documentSnapshot.get('password') == user.password) {
          return User.fromDocument(documentSnapshot);
        } else {
          throw Exception('Invalid password');
        }
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }


}