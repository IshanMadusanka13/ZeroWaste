import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/employee.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/repositories/user_repository.dart';

class EmployeeRepository {
  final CollectionReference _employeeCollection =
      FirebaseFirestore.instance.collection('employee');

  Future<String> generateUniqueId() async {
    try {
      QuerySnapshot snapshot = await _employeeCollection.get();
      int count = snapshot.size;
      if (count == 0) {
        return 'E0001';
      } else {
        count++;
        String userId = 'E${count.toString().padLeft(4, '0')}';
        return userId;
      }
    } catch (e) {
      throw Exception('Error generating unique Employee ID: $e');
    }
  }

  Future<void> addEmployee(User user, Employee employee) async {
    try {
      DocumentReference userId = await UserRepository().addUser(user);
      employee.userId = userId.id;
      employee.id = await generateUniqueId();
      await _employeeCollection.doc(employee.id).set(employee.toMap());
    } catch (e) {
      throw Exception('Error adding Employee: $e');
    }
  }

  Future<void> updateEmployee(String userId, Employee employee) async {
    try {
      await _employeeCollection.doc(userId).update(employee.toMap());
    } catch (e) {
      throw Exception('Error updating Employee: $e');
    }
  }

  Future<void> deleteEmployee(String userId) async {
    try {
      await _employeeCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Error deleting Employee: $e');
    }
  }

  Future<List<Employee>> getAllEmployees() async {
    try {
      QuerySnapshot snapshot = await _employeeCollection.get();
      return snapshot.docs.map((doc) => Employee.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all Employee: $e');
    }
  }

  Future<Employee> getEmployee(String userId) async {
    try {
      DocumentSnapshot snapshot = await _employeeCollection.doc(userId).get();
      if (snapshot.exists) {
        return Employee.fromDocument(snapshot);
      } else {
        throw Exception('Employee not found');
      }
    } catch (e) {
      throw Exception('Error getting Employee: $e');
    }
  }

  Future<Employee?> getEmployeeByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await _employeeCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        return Employee.fromDocument(doc);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error getting Employee by email: $e');
    }
  }
}
