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
  double _currentZoom = 12.0;

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
              initZoom: 12,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
          ),
        ));
  }

  Future<void> loadBins() async {
    List<WasteBin> bins = await WasteBinRepository().getAllBins();
    print("bins are ${bins}");
    for (WasteBin bin in bins) {
      await controller.addMarker(
        GeoPoint(latitude: bin.latitude, longitude: bin.longitude),
        markerIcon: const MarkerIcon(
          icon: Icon(
            CustomBins.plasticbin,
            color: Colors.blue,
            size: 56,
          ),
        ),
      );
    }
  }
}
