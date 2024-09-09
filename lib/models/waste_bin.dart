import 'package:cloud_firestore/cloud_firestore.dart';

class WasteBin {
  String id;
  String binType;
  double longitude;
  double latitude;

  WasteBin(
      {this.id = '',
      required this.binType,
      required this.longitude,
      required this.latitude});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'binType': binType,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory WasteBin.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WasteBin(
      id: doc.id,
      binType: data['binType'],
      longitude: data['longitude'],
      latitude: data['latitude'],
    );
  }
}
