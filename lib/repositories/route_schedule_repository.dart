import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_waste/models/route_schedule.dart';

class RouteScheduleRepository {
  final CollectionReference _scheduleCollection =
      FirebaseFirestore.instance.collection('routeSchedule');

  Future<void> addSchedule(RouteSchedule routeSchedule) async {
    try {
      await _scheduleCollection.add(routeSchedule.toMap());
    } catch (e) {
      throw Exception('Error adding RouteSchedule: $e');
    }
  }

  Future<void> updateSchedule(RouteSchedule routeSchedule) async {
    try {
      await _scheduleCollection
          .doc(routeSchedule.id)
          .update(routeSchedule.toMap());
    } catch (e) {
      throw Exception('Error updating RouteSchedule: $e');
    }
  }

  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await _scheduleCollection.doc(scheduleId).delete();
    } catch (e) {
      throw Exception('Error deleting RouteSchedule: $e');
    }
  }

  Future<List<RouteSchedule>> getAllSchedules() async {
    try {
      QuerySnapshot snapshot = await _scheduleCollection.get();
      return snapshot.docs
          .map((doc) => RouteSchedule.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Error getting all RouteSchedule: $e');
    }
  }

  Future<RouteSchedule> getSchedule(String scheduleId) async {
    try {
      DocumentSnapshot snapshot =
          await _scheduleCollection.doc(scheduleId).get();
      if (snapshot.exists) {
        return RouteSchedule.fromDocument(snapshot);
      } else {
        throw Exception('RouteSchedule not found');
      }
    } catch (e) {
      throw Exception('Error getting RouteSchedule: $e');
    }
  }

  Future<List<RouteSchedule>> findFutureSchedulesByDriverId(
      String driverId) async {
    final now = DateTime.now();
    final schedules = await _scheduleCollection
        .where('driverId', isEqualTo: driverId)
        //.where('scheduleDate', isGreaterThanOrEqualTo: now)
        .get();

    return schedules.docs
        .map((doc) => RouteSchedule.fromDocument(doc))
        .toList();
  }
}
