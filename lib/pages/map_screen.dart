import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:mini_ride/model/UserModel.dart';
import 'package:mini_ride/provider/modelview.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final LatLng start;
  final LatLng end;

  MapScreen({required this.start, required this.end});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<LatLng> routePoints = [];
  List<String> instruction = [];
  List<String> distances = [];
  List<String> durations = [];
  List<LatLng> nearestRoutePoints = [];
  String tdistances = '';
  String tdurations = '';

  @override
  void initState() {
    super.initState();
    ViewModel().getRoute(widget.start, widget.end).then((value) => {
          setState(() {
            routePoints = value[0];
            instruction = value[1];
            distances = value[2];
            durations = value[3];
            tdistances = value[4];
            tdurations = value[5];
          })
        });
    ViewModel().updateNearestRoutePoints(widget.start).then((value) => {
          setState(() {
            nearestRoutePoints = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    ViewModel model = context.watch<ViewModel>();
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: routePoints.isNotEmpty
            ? Stack(children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                      initialCenter: widget.start,
                      initialZoom: 15.0,
                      interactionOptions: InteractionOptions(
                        flags: InteractiveFlag.pinchZoom |
                            InteractiveFlag.drag |
                            InteractiveFlag.doubleTapZoom,
                      )),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                      // Plenty of other options available!
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: widget.start,
                          child: GestureDetector(
                            onTap: () {
                              _mapController.move(widget.start, 15.0);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Start Location : ${widget.start.latitude}, ${widget.start.longitude}')));
                            },
                            child: Container(
                                child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40.0,
                            )),
                          ),
                        ),
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: widget.end,
                          child: GestureDetector(
                            onTap: () {
                              _mapController.move(widget.end, 15.0);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'End Location : ${widget.end.latitude}, ${widget.end.longitude}')));
                            },
                            child: Container(
                                child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40.0,
                            )),
                          ),
                        ),
                      ],
                    ),

                    MarkerLayer(
                      markers: nearestRoutePoints.isNotEmpty
                          ? nearestRoutePoints
                              // Flatten and take only the first 5 points from each route
                              .map((point) => Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: point,
                                    child: GestureDetector(
                                      onTap: () {
                                        _mapController.move(point, 18.0);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Taxi : ${point.latitude}, ${point.longitude}')));
                                      },
                                      child: Container(
                                        child: Icon(
                                          Icons.local_taxi_sharp,
                                          color: Colors.green,
                                          size: 40.0,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList()
                          : [
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: LatLng(0, 0),
                                child: Container(
                                  child: Icon(
                                    Icons.local_taxi_sharp,
                                    color: Colors.blueAccent,
                                    size: 40.0,
                                  ),
                                ),
                              ),
                            ],
                    ),

                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routePoints,
                          strokeWidth: 4.0,
                          color: Colors.blue,
                        ),
                      ],
                    ),

                    // Your bottom sheet or other content goes here

                    AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: 1,
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.3,
                        minChildSize: 0.3,
                        maxChildSize: 0.7,
                        expand: true,
                        builder: (context, scrollController) {
                          return Container(
                            margin: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 0),
                                  child: Text(
                                    double.parse(tdistances)
                                            .toStringAsFixed(1) +
                                        ' km, ' +
                                        ((double.parse(tdurations) ~/ 60) > 0
                                            ? (double.parse(tdurations) ~/ 60)
                                                    .toStringAsFixed(0) +
                                                ' hr '
                                            : '') +
                                        (double.parse(tdurations) % 60)
                                            .toStringAsFixed(0) +
                                        ' min',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: instruction
                                        .length, // Ensure 'instructions' is a valid list in your state
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        subtitle: Text(
                                          '${distances[index]} m, ${durations[index]} s',
                                        ),
                                        title: Text(
                                          instruction[index],
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ])
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
