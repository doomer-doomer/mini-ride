import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:latlong2/latlong.dart';
import 'package:mini_ride/model/LocationModel.dart';
import 'package:mini_ride/pages/homepage.dart';
import 'package:mini_ride/pages/map_screen.dart';
import 'package:mini_ride/model/UserModel.dart';
import 'package:mini_ride/provider/modelview.dart';
import 'package:mini_ride/pages/search.dart';
import 'package:mini_ride/pages/verification/Otp.dart';
import 'package:mini_ride/pages/verification/notify.dart';
import 'package:mini_ride/pages/verification/phone.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationApi.init();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]).then(
    (_) => runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ViewModel()),
          ],
          child: MaterialApp(
            initialRoute: '/homepage',
            routes: {
              '/search': (context) => SearchLocation(),
              '/map': (context) => MapScreen(
                    start: LatLng(0, 0),
                    end: LatLng(0, 0),
                  ),
              '/phone': (context) => Phone(),
              '/otp': (context) => OTP(
                    otp: UserModel().generateRandomCode(),
                  ),
              '/homepage': (context) => Home(),
            },
          )),
    ),
  );
}
