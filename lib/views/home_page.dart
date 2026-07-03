import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:metro/model/loc_station.dart';
import 'package:metro/model/route_info.dart';
import 'package:metro/show.dart';
import 'package:metro/views/routes_page.dart';
import '../calculate_route.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

const Color bgDark = Color(0xFF16161A);
const Color surfaceDark = Color(0xFF22222A);
const Color textWhite = Colors.white;
const Color textGrey = Color(0xFFA0A0A5);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final startController = TextEditingController();

  final destController = TextEditingController();

  final goalAreaController = TextEditingController();

  var enabledRoute = false.obs;

  var routeInfo = ''.obs;

  var enabledShowMapStart = false.obs;
  var enabledShowMapDest = false.obs;

  var enableDetailsButton = false.obs;

  final routes = <RouteInfo>[];

  var shows = <String>[].obs;

  @override
  void dispose() {
    startController.dispose();
    destController.dispose();
    goalAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drops = [
      for (final s in locStations)
        DropdownMenuEntry(value: s.station, label: s.station),
    ];
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        title: const Text(
          'Cairo Metro',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: bgDark,
        foregroundColor: textWhite,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white.withValues(alpha: 0.1),
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Start Station:'),
                      const SizedBox(height: 8),
                      Row(
                        spacing: 8.0,
                        children: [
                          Expanded(
                            child: DropdownMenu(
                              onSelected: ((a) {
                                enabledRoute.value =
                                    a != null && destController.text.isNotEmpty;
                                if (startController.text.isNotEmpty) {
                                  enabledShowMapStart.value = true;
                                } else {
                                  enabledShowMapStart.value = false;
                                }
                              }),
                              requestFocusOnTap: true,
                              enableFilter: true,
                              enableSearch: true,
                              controller: startController,
                              hintText: 'Enter start station',
                              textStyle: const TextStyle(color: textWhite),
                              menuHeight: 300,
                              width: MediaQuery.of(context).size.width * 0.6,
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                filled: true,
                                fillColor: surfaceDark,
                                hintStyle: const TextStyle(color: textGrey),
                              ),
                              dropdownMenuEntries: drops,
                            ),
                          ),
                          Obx(() {
                            return IconButton.filled(
                              onPressed: enabledShowMapStart.value
                                  ? () {
                                      final LocStation start;
                                      try {
                                        start = locStations.firstWhere(
                                          (locStation) =>
                                              locStation.station ==
                                              startController.text,
                                        );
                                      } catch (e) {
                                        Get.snackbar(
                                          'Error',
                                          'Station is Wrong',
                                        );
                                        return;
                                      }
                                      final uri = Uri.parse(
                                        'geo:0,0?q=${start.latitude},${start.longitude}',
                                      );
                                      launchUrl(uri);
                                    }
                                  : null,
                              icon: !enabledShowMapStart.value
                                  ? const Icon(Icons.gps_fixed)
                                  : const Icon(
                                      Icons.gps_fixed,
                                      color: Colors.blue,
                                    ),
                              style: IconButton.styleFrom(
                                backgroundColor: surfaceDark,
                                foregroundColor: textWhite,
                                disabledBackgroundColor: Colors.white
                                    .withValues(alpha: 0.05),
                                disabledForegroundColor: textGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _buildLabel('Goal Station:'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          DropdownMenu(
                            requestFocusOnTap: true,
                            enableFilter: true,
                            enableSearch: true,
                            onSelected: (a) {
                              enabledRoute.value =
                                  a != null && destController.text.isNotEmpty;
                              if (destController.text.isNotEmpty) {
                                enabledShowMapDest.value = true;
                              } else {
                                enabledShowMapDest.value = false;
                              }
                            },
                            controller: destController,
                            menuHeight: 300,
                            width: MediaQuery.of(context).size.width * 0.6,
                            hintText: 'Enter destination station',
                            textStyle: const TextStyle(color: textWhite),
                            inputDecorationTheme: InputDecorationTheme(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              filled: true,
                              fillColor: surfaceDark,
                              hintStyle: const TextStyle(color: textGrey),
                            ),
                            dropdownMenuEntries: drops,
                          ),
                          const Spacer(),
                          Obx(() {
                            return IconButton.filled(
                              onPressed: enabledShowMapDest.value
                                  ? () {
                                      final LocStation start;
                                      try {
                                        start = locStations.firstWhere(
                                          (locStation) =>
                                              locStation.station ==
                                              destController.text,
                                        );
                                      } catch (e) {
                                        Get.snackbar(
                                          'Error',
                                          'Station is Wrong',
                                        );
                                        return;
                                      }
                                      final uri = Uri.parse(
                                        'geo:0,0?q=${start.latitude},${start.longitude}',
                                      );
                                      launchUrl(uri);
                                    }
                                  : null,
                              icon: !enabledShowMapDest.value
                                  ? const Icon(Icons.gps_fixed)
                                  : const Icon(
                                      Icons.gps_fixed,
                                      color: Colors.blue,
                                    ),
                              style: IconButton.styleFrom(
                                backgroundColor: surfaceDark,
                                foregroundColor: textWhite,
                                disabledBackgroundColor: Colors.white
                                    .withValues(alpha: 0.05),
                                disabledForegroundColor: textGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(() {
                            return ElevatedButton.icon(
                              onPressed: enabledRoute.value
                                  ? () {
                                      result.clear();
                                      if (startController.text.isEmpty ||
                                          !lines.keys.contains(
                                            startController.text
                                                .toLowerCase()
                                                .trim(),
                                          )) {
                                        Get.snackbar(
                                          'Error',
                                          'Enter the start station correctly',
                                        );
                                        enabledRoute.value = false;
                                        return;
                                      }
                                      if (destController.text.isEmpty ||
                                          !lines.keys.contains(
                                            destController.text
                                                .toLowerCase()
                                                .trim(),
                                          )) {
                                        Get.snackbar(
                                          'Error',
                                          'Enter destination station',
                                        );
                                        enabledRoute.value = false;
                                        return;
                                      }
                                      final String start = startController.text
                                          .toLowerCase();
                                      final String goal = destController.text
                                          .toLowerCase();
                                      routeInfo.value = '';
                                      routes.clear();
                                      shows.clear();
                                      func(start, goal);
                                      shows.value = show(routes);
                                      if (shows.length > 1) {
                                        enableDetailsButton.value = true;
                                      } else {
                                        enableDetailsButton.value = false;
                                      }
                                    }
                                  : null,
                              label: const Text('Show Route'),
                              icon: const Icon(Icons.play_arrow),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: surfaceDark,
                                foregroundColor: textWhite,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                elevation: 0,
                              ),
                            );
                          }),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final pos = await getLocation();

                              final nearestStation = locStations.minBy(
                                (station) => Geolocator.distanceBetween(
                                  pos.latitude,
                                  pos.longitude,
                                  station.latitude,
                                  station.longitude,
                                ),
                              );
                              startController.text = nearestStation!.station;
                              enabledRoute.value =
                                  destController.text.isNotEmpty;

                              Get.snackbar(
                                'Info',
                                '${(Geolocator.distanceBetween(pos.latitude, pos.longitude, nearestStation.latitude, nearestStation.longitude) / 1000).toStringAsFixed(3)} km far from your location',
                              );
                            },
                            label: const Text('Nearby'),
                            icon: const Icon(Icons.location_on),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: surfaceDark,
                              foregroundColor: textWhite,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Obx(() {
                        return shows.isEmpty
                            ? const SizedBox.shrink()
                            : Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: surfaceDark,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.05),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      shows.first,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: textWhite,
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white.withValues(
                                        alpha: 0.05,
                                      ),
                                      height: 1,
                                    ),
                                    const SizedBox(height: 8),
                                    Obx(() {
                                      return Visibility(
                                        visible: enableDetailsButton.value,
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Get.to(
                                              () => RoutesPage(),
                                              arguments: routes,
                                            );
                                          },
                                          label: const Text(
                                            'Show more routes and details',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.info_outline_rounded,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                      }),

                      const SizedBox(height: 32),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Auto-select station by area:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textWhite,
                          ),
                        ),
                      ),
                      Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: goalAreaController,
                              style: const TextStyle(color: textWhite),
                              decoration: InputDecoration(
                                hintText: 'Enter area (e.g. Dokki)',
                                hintStyle: const TextStyle(color: textGrey),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: textGrey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                filled: true,
                                fillColor: surfaceDark,
                              ),
                            ),
                          ),
                          // رجعنا الزرار ده هنا عشان يبقى جنب مساحة البحث
                          IconButton.filled(
                            onPressed: () async {
                              if (goalAreaController.text.trim().isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'Please enter target area',
                                );
                                return;
                              }

                              Location? location;

                              try {
                                final loc = await locationFromAddress(
                                  '${goalAreaController.text}, Egypt',
                                );

                                if (loc.isNotEmpty) {
                                  location = loc.first;
                                }
                              } catch (e) {
                                print('Geocoding Error: $e');
                                Get.snackbar('Error', 'Location search failed');
                                return;
                              }

                              if (location == null) {
                                Get.snackbar(
                                  'Error',
                                  'Could not reach to the location',
                                );
                                return;
                              }

                              if (locStations.isEmpty) {
                                Get.snackbar('Error', 'Stations list is empty');
                                return;
                              }

                              final nearestStation = locStations.minBy(
                                (station) => Geolocator.distanceBetween(
                                  location!.latitude,
                                  location.longitude,
                                  station.latitude,
                                  station.longitude,
                                ),
                              );

                              if (nearestStation == null) {
                                Get.snackbar(
                                  'Error',
                                  'No nearest station found',
                                );
                                return;
                              }

                              final distance =
                                  Geolocator.distanceBetween(
                                    location.latitude,
                                    location.longitude,
                                    nearestStation.latitude,
                                    nearestStation.longitude,
                                  ) /
                                  1000;

                              Get.snackbar(
                                'Info',
                                '${distance.toStringAsFixed(3)} km far from the target area',
                              );

                              destController.clear();
                              destController.text = nearestStation.station;

                              enabledRoute.value = startController.text
                                  .trim()
                                  .isNotEmpty;
                            },
                            icon: const Icon(Icons.location_searching),
                            style: IconButton.styleFrom(
                              backgroundColor: surfaceDark,
                              foregroundColor: textWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // مسافة صغيرة في آخر الشاشة عشان متلزقش في النهاية
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: textWhite,
      ),
    );
  }

  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      throw Exception('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Location permissions are permanently denied.');
      throw Exception('Location permissions are permanently denied');
    }
    return Geolocator.getCurrentPosition();
  }

  void func(final String start, final String goal) {
    if (start == goal) {
      Get.snackbar(
        'Warning!',
        'You Entered the same stations in start and goal.',
      );
      return;
    }
    dfsAll(lines, start, goal);
    result = result.sortedBy((result) => findTransStation(result).length);
    for (var path in result) {
      final int price;
      if (path.length <= 9) {
        price = 8;
      } else if (path.length <= 16) {
        price = 10;
      } else if (path.length <= 23) {
        price = 15;
      } else {
        price = 20;
      }
      final transStations = findTransStation(path);
      final time = path.length * 3 + transStations.length * 4 - 3;
      routes.add(
        RouteInfo(
          price: price,
          transStations: transStations,
          time: time,
          path: path,
        ),
      );
    }
  }
}
