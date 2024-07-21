import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/widgets/loader.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({super.key});

  @override
  State<StatefulWidget> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> with OSMMixinObserver {
  GeoPoint? sendGeoPoint;
  late final MapController controller = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(
    enableTracking: true,
    unFollowUser: false,
  ));

  final Key key = GlobalKey();
  ValueNotifier<bool> isTracking = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    controller.addObserver(this);
    controller.listenerMapSingleTapping.addListener(onMapSingleTap);
    controller.listenerRegionIsChanging.addListener(() {
      if (controller.listenerRegionIsChanging.value != null) {}
    });
  }

  void onMapSingleTap() async {
    if (controller.listenerMapSingleTapping.value != null) {
      if ((await controller.geopoints).isNotEmpty) {
        await controller.removeMarker((await controller.geopoints).last);
      }
      setState(() {
        sendGeoPoint = controller.listenerMapSingleTapping.value!;
      });
      await controller.addMarker(
        sendGeoPoint!,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_pin,
            size: 35,
            color: Colors.green,
          ),
        ),
      );
      GeoPoint? selectedGeoPoint = await showModalBottomSheet<GeoPoint>(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await controller.myLocation().then((value) {
                        Navigator.of(context).pop(value);
                        return value;
                      });
                    },
                    child: ListTile(
                      leading: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.green, width: 2)),
                        child: const Icon(Icons.location_searching,
                            color: Colors.green),
                      ),
                      title: const Text('Send your current location'),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      (await controller.geopoints.then((value) {
                        Navigator.of(context).pop(value.last);
                        return value.last;
                      }));
                    },
                    child: ListTile(
                      leading: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.green, width: 2)),
                        child:
                            const Icon(Icons.location_pin, color: Colors.green),
                      ),
                      title: const Text('Send selected location'),
                    ),
                  ),
                ],
              ),
            );
          });

      Navigator.pop(context, selectedGeoPoint);
    }
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      await controller.setZoom(zoomLevel: 15);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controller.listenerMapSingleTapping.removeListener(() {});
    controller.listenerRegionIsChanging.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Location'),
        actions: [
          IconButton(
            onPressed: () async {
              await controller.currentLocation();
            },
            icon: const Icon(Icons.location_history),
          ),
          IconButton(
            onPressed: () async {
              if (isTracking.value) {
                await controller.disabledTracking();
              }
              if (!isTracking.value) {
                await controller.currentLocation();
                await controller.enableTracking();
              }
              isTracking.value = !isTracking.value;
            },
            icon: ValueListenableBuilder<bool>(
              valueListenable: isTracking,
              builder: (ctx, tracking, _) {
                return Icon(
                  tracking ? Icons.location_disabled : Icons.my_location,
                  color: tracking ? Colors.white : Colors.grey[400],
                );
              },
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (ctx) {
          return OSMFlutter(
            key: key,
            controller: controller,
            osmOption: const OSMOption(
              zoomOption: ZoomOption(
                initZoom: 5,
              ),
              showContributorBadgeForOSM: true,
            ),
            mapIsLoading: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Map Is Loading ...'),
                  const SizedBox(
                    height: 10,
                  ),
                  loader(radius: 20, color: lightAppBarColor)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
