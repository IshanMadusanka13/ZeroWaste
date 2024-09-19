import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/garbage_entry.dart';

class GarbageEntryRepository {
  final CollectionReference _garbageEntryCollectionCollection =
      FirebaseFirestore.instance.collection('garbageEntries');

  Future<void> addEntry(GarbageEntry garbageEntry) async {
    try {
      await _garbageEntryCollectionCollection.add(garbageEntry.toMap());
    } catch (e) {
      throw Exception('Error adding GarbageEntry: $e');
    }
  }

  Future<void> updateEntry(String garbageId, GarbageEntry garbageEntry) async {
    try {
      await _garbageEntryCollectionCollection
          .doc(garbageId)
          .update(garbageEntry.toMap());
    } catch (e) {
      throw Exception('Error updating GarbageEntry: $e');
    }
  }

  Future<void> deleteEntry(String garbageId) async {
    try {
      await _garbageEntryCollectionCollection.doc(garbageId).delete();
    } catch (e) {
      throw Exception('Error deleting GarbageEntry: $e');
    }
  }
}
