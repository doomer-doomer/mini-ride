import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:mini_ride/model/LocationModel.dart';
import 'package:mini_ride/model/SearchModel.dart';
import 'package:mini_ride/model/UserModel.dart';

class ViewModel extends ChangeNotifier {
  UserModel _userModel = UserModel();
  LocationModel _locationModel = LocationModel();
  Searchmodel _searchModel = Searchmodel();

  String get phoneNumber => UserModel.phoneNumber;
  bool get status => UserModel.status;
  List<List<String>> get searches => UserModel.searches;
  List<List<LatLng>> get latlng => UserModel.latlng;
  List<LatLng> get nearestRoutePoints => LocationModel.nearestRoutePoints;

  static bool loading = false;

  Future<List> getRoute(LatLng start, LatLng end) async {
    loading = true;
    notifyListeners();
    List success = await _locationModel.fetchRoute(start, end);
    loading = false;
    notifyListeners();
    return success;
  }

  Future<List> searchLocations(
      String initialLocation, String finalLocation) async {
    List success =
        await _searchModel.searchLocations(initialLocation, finalLocation);
    return success;
  }

  Future<List<LatLng>> updateNearestRoutePoints(LatLng latlng) async {
    List<LatLng> routePoints =
        await _locationModel.getNearestRoutePoints(latlng);
    if (routePoints.isNotEmpty) {
      return routePoints;
    }
    return [];
  }

  void updatePhoneNumber(String phoneNumber) {
    _userModel.setPhoneNumber(phoneNumber);
    notifyListeners();
  }

  void updateStatus(bool status) {
    _userModel.setStatus(status);
    notifyListeners();
  }

  void updateSearches(List<String> searches) {
    if (!UserModel.searches.contains(searches)) {
      _userModel.setSearches(searches);
    }
    notifyListeners();
  }

  void updateLatlng(List<LatLng> latlng) {
    if (!UserModel.latlng.contains(latlng)) {
      _userModel.setLatlng(latlng);
    }
    notifyListeners();
  }

  bool logoutUser() {
    updatePhoneNumber('');
    updateStatus(false);
    return true;
  }

  bool loginUser(String phoneNumber) {
    if (phoneNumber.isNotEmpty) {
      updatePhoneNumber(phoneNumber);
      return true;
    }

    return false;
  }

  int generateRandomCode() {
    return _userModel.generateRandomCode();
  }
}
