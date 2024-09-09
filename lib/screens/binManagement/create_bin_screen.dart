import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:zero_waste/models/waste_bin.dart';
import 'package:zero_waste/repositories/waste_bin_repository.dart';

import '../../widgets/select_dropdown.dart';

class CreateBinScreen extends StatefulWidget {
  const CreateBinScreen({super.key});

  @override
  State<CreateBinScreen> createState() => _CreateBinScreenState();
}

class _CreateBinScreenState extends State<CreateBinScreen> {
  late MapController controller;
  final _formKey = GlobalKey<FormState>();
  String? _binType;
  GeoPoint? _binLocation;

  @override
  void initState() {
    super.initState();
    controller = MapController.withUserPosition(
        trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    controller.listenerMapLongTapping.addListener(() async {
      if (controller.listenerMapLongTapping.value != null) {
        createPin(controller.listenerMapLongTapping.value);
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade200, Colors.blue.shade200],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bgImg.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(50, 30),
                      bottomRight: Radius.elliptical(50, 30))),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create Bin",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectDropdown(
                        title: "Bin Type",
                        items: const [
                          'Organic',
                          'Plastic',
                          'Glass',
                          'Paper',
                          'Metal',
                        ],
                        selectedValue: _binType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _binType = newValue;
                          });
                        },
                        hint: "Select Item"),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Select Bin Location",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: OSMFlutter(
                      controller: controller,
                      osmOption: const OSMOption(
                        zoomOption: ZoomOption(
                          initZoom: 12,
                          minZoomLevel: 3,
                          maxZoomLevel: 19,
                          stepZoom: 1.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 35),
            Container(
              margin: const EdgeInsets.fromLTRB(40, 5, 20, 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () => _submitForm(context),
                child: Text("Create Bin",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createPin(GeoPoint? location) async {
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
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final wasteBin = WasteBin(
          binType: _binType!,
          longitude: _binLocation!.longitude,
          latitude: _binLocation!.latitude);

      WasteBinRepository().addBin(wasteBin).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('WasteBin added successfully!')));
        context.go("/home");
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add WasteBin')));
      });
    }
  }
}
