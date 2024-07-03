import 'dart:math';

import 'package:latlong2/latlong.dart';

class UserModel {
  static String phoneNumber = 'Guest';
  static bool status = false;
  static List<List<String>> searches = [];
  static List<List<LatLng>> latlng = [];

  static String get _phoneNumber => phoneNumber;
  static bool get _status => status;
  static List<List<String>> get _searches => searches;
  static List<List<LatLng>> get _latlng => latlng;

  void setPhoneNumber(String phno) {
    phoneNumber = phno;
  }

  void setStatus(bool stat) {
    status = stat;
  }

  void setSearches(List<String> search) {
    searches.add(search);
  }

  void setLatlng(List<LatLng> lat) {
    latlng.add(lat);
  }

  int generateRandomCode() {
    Random random = Random();
    int min = 100000;
    int max = 999999;
    return min + random.nextInt(max - min + 1);
  }
}
