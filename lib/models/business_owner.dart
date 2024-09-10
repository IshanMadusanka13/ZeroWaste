import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/user.dart';

class BusinessOwner {
  String id;
  String companyName;
  String contactPersonName;
  String mobile;
  String address;
  User user;

  BusinessOwner(
      {this.id = '',
        required this.companyName,
        required this.contactPersonName,
        required this.mobile,
        required this.address,
        required this.user});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyName': companyName,
      'contactPersonName': contactPersonName,
      'mobile': mobile,
      'address': address,
      'user': user.toMap(),
    };
  }

  factory BusinessOwner.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BusinessOwner(
      id: doc.id,
      companyName: data['companyName'],
      contactPersonName: data['contactPersonName'],
      mobile: data['mobile'],
      address: data['address'],
      user: data['user'],
    );
  }
}
