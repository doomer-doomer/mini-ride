import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationModel {
  static List<LatLng> nearestRoutePoints = [];
  static List<LatLng> routePoints = [];
  static List<String> instruction = [];
  static List<String> distances = [];
  static List<String> durations = [];
  static String tdistances = '';
  static String tdurations = '';

  Future<List<LatLng>> getNearestRoutePoints(LatLng latlng) async {
    var url =
        'https://router.project-osrm.org/nearest/v1/driving/${latlng.longitude},${latlng.latitude}?number=5&bearings=0,0';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      final List<dynamic> coordinates = data['waypoints'];
      final List<LatLng> routePoints = coordinates
          .map<LatLng>(
              (coord) => LatLng(coord['location'][1], coord['location'][0]))
          .toList();
      nearestRoutePoints = routePoints;
      return routePoints;
    } else {
      return [];
    }
  }

  Future<List> fetchRoute(LatLng start, LatLng end) async {
    final apiKey = '5b3ce3597851110001cf624889a34bb8834f4c4d8dbf4cd53a2f6638';
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=${apiKey}&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['features'][0]['geometry']['coordinates'];
      final instructions =
          data['features'][0]['properties']['segments'][0]['steps'];

      List<dynamic> segments = data['features'][0]['properties']['segments'];
      segments.forEach((segment) {
        List<dynamic> steps = segment['steps'];
        steps.forEach((step) {
          distances.add(step['distance'].toString());
          durations.add(step['duration'].toString());
        });
      });

      tdistances =
          (data['features'][0]['properties']['segments'][0]['distance'] / 1000)
              .toString();
      tdurations =
          (data['features'][0]['properties']['segments'][0]['duration'] / 60)
              .toString();

      routePoints = coordinates
          .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
          .toList();
      instruction = instructions
          .map<String>((step) => step['instruction'] as String)
          .toList();

      return [
        routePoints,
        instruction,
        distances,
        durations,
        tdistances,
        tdurations
      ];
    } else {
      return [];
    }
  }
}
