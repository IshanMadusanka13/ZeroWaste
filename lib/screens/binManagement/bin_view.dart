import 'dart:math';

import 'package:flutter/cupertino.dart';
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
  late WasteBin selectedBin;
  bool updateStatus = false;
  GeoPoint? _binLocation;

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
      print('Long Press $updateStatus');
      if (updateStatus) {
        if (controller.listenerMapLongTapping.value != null) {
          createPin(controller.listenerMapLongTapping.value!);
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
            onPressed: () {
              updateStatus = true;
              Navigator.of(context).pop();
            },
            text: 'Change',
            iconData: Icons.location_pin,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {
              deleteBin(selectedBin);
              Navigator.of(context).pop();
            },
            text: 'Remove',
            iconData: Icons.delete,
            color: Colors.red,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  Future<void> createPin(GeoPoint location) async {
    if (_binLocation == null) {
      _binLocation = location;
      await controller.addMarker(
        _binLocation!,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 48,
          ),
        ),
      );
    } else {
      GeoPoint? oldBinLocation = _binLocation;
      _binLocation = location;
      await controller.changeLocationMarker(
        oldLocation: oldBinLocation!,
        newLocation: _binLocation!,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 48,
          ),
        ),
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm New Marker?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                _binLocation = null;
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _binLocation = null;
                updateBin(location);
              },
            )
          ],
        );
      },
    );
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

  void updateBin(GeoPoint location) {
    WasteBin newBin = selectedBin;
    newBin.longitude = location.longitude;
    newBin.latitude = location.latitude;

    WasteBinRepository().updateBin(selectedBin).then((_) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Successfully to Updated WasteBin'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go("/home");
                },
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Failed to Update WasteBin'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void deleteBin(WasteBin bin) {
    WasteBinRepository().deleteBin(bin.id).then((_) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('WasteBin Deleted'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go("/home");
                  },
                ),
              ],
            );
          });
    }).catchError((error) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Failed to Delete WasteBin'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });
  }
}
