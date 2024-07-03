import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class Searchmodel{

  Future searchLocations(String initialLocation,String finalLocation) async {
    
    if (finalLocation.isNotEmpty) {

      final url ='https://nominatim.openstreetmap.org/search?q=$finalLocation&format=json&limit=10';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> results = data.map((location) {
          return location['display_name'] as String ?? 'Unnamed Location';
        }).toList();

         List<String> names = data.map((location) {
          return location['name'] as String ?? 'Unnamed Location';
        }).toList();

         List<LatLng> coordinates = data.map((location) {
          double lat = double.parse(location['lat']);
          double lon = double.parse(location['lon']);
          return LatLng(lat, lon);
        }).toList();

      
         return [results,coordinates,names];
      } else {
        print('Failed to load locations: ${response.statusCode}');
      }
    }else{
      final url ='https://nominatim.openstreetmap.org/search?q=$initialLocation&format=json&limit=10';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> results = data.map((location) {
          return location['display_name'] as String ?? 'Unnamed Location';
        }).toList();

         List<String> names = data.map((location) {
          return location['name'] as String ?? 'Unnamed Location';
        }).toList();

         List<LatLng> coordinates = data.map((location) {
          double lat = double.parse(location['lat']);
          double lon = double.parse(location['lon']);
          return LatLng(lat, lon);
        }).toList();

       
          return [results,coordinates,names];
     
      } else {
        print('Failed to load locations: ${response.statusCode}');
      }
    }
  }
}