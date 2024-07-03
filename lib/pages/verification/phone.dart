import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mini_ride/provider/modelview.dart';
import 'package:mini_ride/pages/search.dart';
import 'package:mini_ride/pages/verification/Otp.dart';
import 'package:mini_ride/pages/verification/notify.dart';

class Phone extends StatefulWidget {
  const Phone({super.key});

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  TextEditingController phone = TextEditingController();

  verifyPhone() async {
    log('Phone number: ${phone.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Phone Verification'),
        backgroundColor: Colors.white,
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Verify your phone number'),
            TextField(
              keyboardType: TextInputType.phone,
              controller: phone,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.phone,
                  color: Colors.green,
                ),
                hintText: '1234567890',
              ),
            ),
            SizedBox(height: 20),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                ),
                onPressed: () {
                  if (phone.text.isNotEmpty && phone.text.length == 10) {
                    ViewModel().updatePhoneNumber(phone.text);
                    int code = ViewModel().generateRandomCode();
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => OTP(
                                  otp: code,
                                )));

                    NotificationApi.showInstantNotification(
                      title: 'OTP Verification',
                      body: 'Your OTP is $code',
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter a valid phone number'),
                    ));
                  }
                },
                child: Text('Verify', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
