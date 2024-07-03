import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mini_ride/pages/map_screen.dart';
import 'package:mini_ride/pages/search.dart';
import 'package:mini_ride/provider/modelview.dart';
import 'package:mini_ride/pages/verification/phone.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  onDidChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ViewModel model = context.watch<ViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Mini Ride',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Roboto',
                  ),
                ),
                Spacer(),
                model.status
                    ? ElevatedButton(
                        onPressed: () {
                          model.logoutUser();
                          Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(builder: (context) => Home()),
                              (route) => false);
                        },
                        child: Text('Logout'))
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Phone()));
                        },
                        child: Text('Login'))
              ]),
              Text(
                  'Your logged in as ${model.phoneNumber == '' ? 'Guest' : model.phoneNumber}'),
              Text('Status: ${model.status ? 'Verified' : 'Not Verified'}'),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Searches",
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => SearchLocation()));
                        },
                        icon: Icon(Icons.search))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            style: ListTileStyle.list,
                            title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    model.searches[index][0],
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                  Icon(Icons.arrow_downward,
                                      size: 20, color: Colors.black),
                                  Text(
                                    model.searches[index][1],
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                ]),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => MapScreen(
                                            start: model.latlng[index][0],
                                            end: model.latlng[index][1],
                                          )));
                            },
                          ),
                          Divider(),
                        ],
                      );
                    },
                    itemCount: model.searches.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
