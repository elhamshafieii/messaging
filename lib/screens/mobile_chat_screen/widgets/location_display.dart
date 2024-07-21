import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/models/message.dart';

class LocationDisplay extends StatefulWidget {
  const LocationDisplay({
    super.key,
    required this.message,
  });
  final Message message;
  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

class _LocationDisplayState extends State<LocationDisplay>
    with OSMMixinObserver {
  MapController? controller;
  GeoPoint? geoPoint;
  @override
  void initState() {
    super.initState();
    final List<double> selectedLocation =
        json.decode(widget.message.text).cast<double>().toList();
    geoPoint = GeoPoint(
        latitude: selectedLocation.first, longitude: selectedLocation.last);
    controller = MapController(
        initPosition: GeoPoint(
            latitude: geoPoint!.latitude, longitude: geoPoint!.longitude));
    controller!.addObserver(this);
  }

  @override
  void dispose() {
    if (controller != null) {
      controller!.dispose();
      controller!.removeObserver(this);
    }
    super.dispose();
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      await controller!.setZoom(zoomLevel: 12);
      await controller!.setStaticPosition(
        [geoPoint!],
        '1',
      );
      await controller!.setMarkerOfStaticPoint(
          id: '1',
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_pin,
              color: Colors.green,
            ),
          ));
    }
  }

  @override
  void onSingleTap(GeoPoint position) {
    super.onSingleTap(position);
    MapsLauncher.launchCoordinates(geoPoint!.latitude, geoPoint!.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: controller!,
      osmOption: const OSMOption(
        zoomOption: ZoomOption(
          initZoom: 5,
        ),
      ),
      mapIsLoading: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Map Is Loading ...'),
            const SizedBox(
              height: 10,
            ),
            loader( radius: 10, color: lightTextColor)
          ],
        ),
      ),
    );
  }
}
