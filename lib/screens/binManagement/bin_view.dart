import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/waste_bin.dart';
import 'package:zero_waste/repositories/waste_bin_repository.dart';
import 'package:zero_waste/routes/routes.dart';
import 'package:zero_waste/utils/custom_bins_icons.dart';

class BinView extends StatefulWidget {
  const BinView({super.key});

  @override
  State<BinView> createState() => _BinViewState();
}

class _BinViewState extends State<BinView>{
  late MapController controller;

  @override
  void initState() {
    super.initState();
    controller = MapController.withUserPosition(
        trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));
    loadBins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bin View'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go("/home");
            },
          ),
        ),
        body: OSMFlutter(
          controller: controller,
          osmOption: const OSMOption(
            userTrackingOption: UserTrackingOption(
              enableTracking: true,
              unFollowUser: false,
            ),
            zoomOption: ZoomOption(
              initZoom: 14,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
          ),
        ));
  }

  Future<void> loadBins() async {
    List<WasteBin> bins = await WasteBinRepository().getAllBins();
    for (WasteBin bin in bins) {
      await controller.addMarker(
        GeoPoint(latitude: bin.latitude, longitude: bin.longitude),
        markerIcon: MarkerIcon(
          icon: CustomBins.getBinIcon(bin.binType),
        ),

      );
    }
  }

  void _onMarkerTap(WasteBin bin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bin Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Type: ${bin.binType}'),
              Text('Latitude: ${bin.latitude}'),
              Text('Longitude: ${bin.longitude}'),
              // Add more details as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


}
