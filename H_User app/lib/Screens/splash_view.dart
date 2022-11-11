import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hospital_appointment/Screens/home/mainPage.dart';
import '../services/shared_preferences_service.dart';
import 'home/patient_home_page.dart';
import 'login/loginas.dart';

class SplashView extends StatefulWidget {
  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  final PrefService _prefService = PrefService();

  @override
  void initState() {
    _prefService.readCache("password").then((value) {
      print(value.toString());
      if (value == 1) {
        return Timer(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => HomePage(),
            ),
                (route) => false, //if you want to disable back feature set to false
          );
        });
      } else if (value == 2) {
        return Timer(
            Duration(seconds: 2),
                () => Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => HomePage()),
                        (route) => false),
        );
      } else {
        return Timer(Duration(seconds: 2), () {

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (BuildContext context) => Loginas()));
          //  Navigator.pop(context);
          //  Duration(seconds: 2);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset("assets/images/l2.png",
              width: 200, height: 200),),
    );
  }
}
