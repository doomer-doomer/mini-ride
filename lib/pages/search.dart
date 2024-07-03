import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:latlong2/latlong.dart';
import 'package:mini_ride/pages/map_screen.dart';
import 'package:mini_ride/provider/modelview.dart';
import 'package:provider/provider.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  TextEditingController initialLocationController = TextEditingController();
  TextEditingController finalLocationController = TextEditingController();

  List<String> searchResults = [];
  List<String> name = [];
  List<LatLng> latlng = [];
  int count = 0;
  LatLng start = LatLng(0.0, 0.0);
  LatLng end = LatLng(0.0, 0.0);
  String initial_pos = '';
  String final_pos = '';
  bool loading = false;

  Timer _debounce = Timer(Duration(milliseconds: 500), () => {});

  @override
  Widget build(BuildContext context) {
    ViewModel model = context.watch<ViewModel>();
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: TextField(
                onChanged: (value) async {
                  setState(() {
                    searchResults = [];
                    latlng = [];
                    name = [];
                    loading = true;
                    count = 0;
                  });
                  if (_debounce.isActive) {
                    _debounce.cancel();
                  }
                  _debounce = Timer(Duration(milliseconds: 500), () async {
                    List success = await model.searchLocations(
                        initialLocationController.text, '');
                    setState(() {
                      searchResults = success[0];
                      latlng = success[1];
                      name = success[2];
                      loading = false;
                    });
                  });
                },
                controller: initialLocationController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  icon: Icon(
                    Icons.start_sharp,
                    color: Colors.green,
                  ),
                  hintText: 'Initial location',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      initialLocationController.clear();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: TextField(
                onChanged: (value) async {
                  setState(() {
                    searchResults = [];
                    latlng = [];
                    name = [];
                    loading = true;
                    count = 1;
                  });
                  if (_debounce.isActive) {
                    _debounce.cancel();
                  }
                  _debounce = Timer(Duration(milliseconds: 500), () async {
                    List success = await model.searchLocations(
                        '', finalLocationController.text);
                    setState(() {
                      searchResults = success[0];
                      latlng = success[1];
                      name = success[2];
                      loading = false;
                    });
                  });
                },
                controller: finalLocationController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  icon: Icon(
                    Icons.location_on_sharp,
                    color: Colors.red,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      finalLocationController.clear();
                    },
                  ),
                  hintText: 'Final location',
                ),
              ),
            ),
            loading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.location_searching),
                              subtitle: Text(searchResults[index]),
                              title: Text(name[index]),
                              onTap: () {
                                if (count == 0) {
                                  initialLocationController.text =
                                      searchResults[index];
                                  setState(() {
                                    start = latlng[index];
                                    initial_pos = searchResults[index];
                                  });
                                } else {
                                  finalLocationController.text =
                                      searchResults[index];
                                  setState(() {
                                    end = latlng[index];
                                    final_pos = searchResults[index];
                                  });
                                }
                              },
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (initialLocationController.text.isEmpty ||
                        finalLocationController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please select a location'),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }
                    model.updateSearches([initial_pos, final_pos]);
                    model.updateLatlng([start, end]);

                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => MapScreen(
                          start: start,
                          end: end,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Get Directions',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
