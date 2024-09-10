import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/user.dart';

class HouseholdUser {
  String id;
  String fName;
  String lName;
  String nic;
  String mobile;
  DateTime dob;
  String address;
  User user;

  HouseholdUser(
      {this.id = '',
      required this.fName,
      required this.lName,
      required this.nic,
        required this.mobile,
      required this.dob,
      required this.address,
      required this.user});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fName': fName,
      'lName': lName,
      'nic': nic,
      'mobile': mobile,
      'dob': dob,
      'address': address,
      'user': user.toMap(),
    };
  }

  factory HouseholdUser.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HouseholdUser(
      id: doc.id,
      fName: data['fName'],
      lName: data['lName'],
      nic: data['nic'],
      mobile: data['mobile'],
      dob: data['dob'],
      address: data['address'],
      user: data['user'],
    );
  }
}
