import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:zero_waste/models/waste_bin.dart';
import 'package:zero_waste/repositories/waste_bin_repository.dart';
import 'package:zero_waste/utils/custom_bins_icons.dart';

class BinView extends StatefulWidget {
  const BinView({super.key});

  @override
  State<BinView> createState() => _BinViewState();
}

class _BinViewState extends State<BinView> {
  late MapController controller;
  late List<WasteBin> bins;
  bool updateStatus = false;

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

    controller.listenerMapLongTapping.addListener(() async {
      if(updateStatus){
        if (controller.listenerMapLongTapping.value != null) {
          //createPin(controller.listenerMapLongTapping.value);
        }
      }
    });

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
          onGeoPointClicked: _onGeoPointClicked,
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

  void _onGeoPointClicked(GeoPoint geoPoint) {
    late WasteBin selectedBin;

    for (WasteBin bin in bins) {
      if (bin.latitude == geoPoint.latitude &&
          bin.longitude == geoPoint.longitude) {
        selectedBin = bin;
      }
    }

    Dialogs.bottomMaterialDialog(
        msg: 'Do You Want To Make any Changes to the Selected Marker?',
        title: 'Make Changes',
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {updateStatus = true;},
            text: 'Change',
            iconData: Icons.location_pin,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {
              deleteBin(selectedBin);
            },
            text: 'Remove',
            iconData: Icons.delete,
            color: Colors.red,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  Future<void> loadBins() async {
    bins = await WasteBinRepository().getAllBins();
    for (WasteBin bin in bins) {
      await controller.addMarker(
        GeoPoint(latitude: bin.latitude, longitude: bin.longitude),
        markerIcon: MarkerIcon(
          icon: CustomBins.getBinIcon(bin.binType),
        ),
      );
    }
  }

  void updateBin(WasteBin bin) {
    WasteBinRepository().updateBin(bin.id, bin).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WasteBin Updated successfully!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to Update WasteBin')));
    });
  }

  void deleteBin(WasteBin bin) {
    WasteBinRepository().deleteBin(bin.id).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WasteBin Deleted successfully!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to Delete WasteBin')));
    });
  }
}
