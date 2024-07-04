import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_ride/pages/homepage.dart';
import 'package:mini_ride/provider/modelview.dart';
import 'package:mini_ride/pages/search.dart';
import 'package:provider/provider.dart';

class OTP extends StatelessWidget {
  final otp;
   OTP({super.key, required this.otp});

  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ViewModel model = context.watch<ViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('OTP Verification'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Enter the OTP sent to your phone'),
              TextField(
                keyboardType: TextInputType.number,
                controller: otpController,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                ),
              ),
              Row(
                children: [
                  Text('Did not receive OTP?'),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Resend OTP',
                        textAlign: TextAlign.start,
                      )),
                ],
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueAccent),
                    ),
                    onPressed: () {
                      if ((otp).toString() == otpController.text) {
                        model.updateStatus(true);
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(builder: (context) => Home()),
                            (route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Invalid OTP')));
                      }
                    },
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
