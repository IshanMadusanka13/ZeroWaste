import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/collection_route.dart';
import 'package:zero_waste/models/waste_bin.dart';

class CollectionRouteRepository {
  final CollectionReference _routeCollection =
  FirebaseFirestore.instance.collection('route');

  Future<String> generateRouteId() async {
    try {
      QuerySnapshot snapshot = await _routeCollection.get();
      int count = snapshot.size;
      if (count == 0) {
        return 'R0001';
      } else {
        count++;
        String userId = 'R${count.toString().padLeft(4, '0')}';
        return userId;
      }
    } catch (e) {
      throw Exception('Error generating unique Route ID: $e');
    }
  }

  Future<void> addRoute(CollectionRoute collectionRoute) async {
    try {
      collectionRoute.id = await generateRouteId();
      await _routeCollection.doc(collectionRoute.id).set(collectionRoute.toMap());
    } catch (e) {
      throw Exception('Error adding CollectionRoute: $e');
    }
  }

  Future<void> updateRoute(CollectionRoute collectionRoute) async {
    try {
      await _routeCollection.doc(collectionRoute.id).update(collectionRoute.toMap());
    } catch (e) {
      throw Exception('Error updating CollectionRoute: $e');
    }
  }

  Future<void> deleteRoute(String routeId) async {
    try {
      await _routeCollection.doc(routeId).delete();
    } catch (e) {
      throw Exception('Error deleting CollectionRoute: $e');
    }
  }

  Future<List<CollectionRoute>> getAllRoutes() async {
    try {
      QuerySnapshot snapshot = await _routeCollection.get();
      return snapshot.docs.map((doc) => CollectionRoute.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error getting all CollectionRoute: $e');
    }
  }

  Future<CollectionRoute> getRoute(String routeId) async {
    try {
      DocumentSnapshot snapshot = await _routeCollection.doc(routeId).get();
      if (snapshot.exists) {
        return CollectionRoute.fromDocument(snapshot);
      } else {
        throw Exception('CollectionRoute not found');
      }
    } catch (e) {
      throw Exception('Error getting CollectionRoute: $e');
    }
  }
}
