import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/waste_bin.dart';

class WasteBinRepository {
  final CollectionReference _binCollection =
      FirebaseFirestore.instance.collection('wastebin');

  Future<void> addBin(WasteBin wasteBin) async {
    try {
      await _binCollection.add(wasteBin.toMap());
    } catch (e) {
      throw Exception('Error adding WasteBin: $e');
    }
  }

  Future<void> updateBin(String binId, WasteBin wasteBin) async {
    try {
      await _binCollection.doc(wasteBin.id).update(wasteBin.toMap());
    } catch (e) {
      throw Exception('Error updating WasteBin: $e');
    }
  }

  Future<void> deleteBin(String binId) async {
    try {
      await _binCollection.doc(binId).delete();
    } catch (e) {
      throw Exception('Error deleting WasteBin: $e');
    }
  }

  Future<List<WasteBin>> getAllBins() async {
    try {
      QuerySnapshot snapshot = await _binCollection.get();
      return snapshot.docs.map((doc) => WasteBin.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all WasteBins: $e');
    }
  }

  Future<WasteBin> getBin(String binId) async {
    try {
      DocumentSnapshot snapshot = await _binCollection.doc(binId).get();
      if (snapshot.exists) {
        return WasteBin.fromDocument(snapshot);
      } else {
        throw Exception('WasteBin not found');
      }
    } catch (e) {
      throw Exception('Error getting WasteBin: $e');
    }
  }
}
