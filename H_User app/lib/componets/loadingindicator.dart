import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


void showLoadingDialog({
  @required BuildContext? context,
}) {
  Future.delayed(const Duration(seconds: 0), () {
    showDialog(
        context: context!,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Material(
              color: Colors.white,
              child:Center(
                child: Container(
                  width: 50,
                  height: 50,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballGridBeat,
                    colors: _kDefaultRainbowColors,
                    strokeWidth: 4.0,
                  ),
                ),
              ),
            ),
          );
        });
  });
}
List<Color> _kDefaultRainbowColors = const [
  kPrimaryColor,
  kPrimarydark,
  kPrimaryLightColor,
  kPrimaryLightdark,
  kprimaryLightBlue,
  kPrimaryhinttext
];
class Loading extends StatelessWidget {
   /*List<Color> _kDefaultRainbowColors = const [
    kPrimaryColor,
    kPrimarydark,
    kPrimaryLightColor,
    kPrimaryLightdark,
    kprimaryLightBlue,
    kPrimaryhinttext
  ];*/

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: 50,
          height: 50,
          child: LoadingIndicator(
            indicatorType: Indicator.ballGridPulse,
            colors: _kDefaultRainbowColors,
            strokeWidth: 4.0,
          ),
        ),

    );
  }
}

void hideLoadingDialog({@required BuildContext? context}) {
  Navigator.pop(context!, false);
}
/*

Future<bool> getInternetUsingInternetConnectivity() async {
  bool result = await InternetConnectionChecker().hasConnection;
   if (result == true) {
     print('YAY! Free cute dog pics!');
   } else {
     print('No internet :( Reason:');
   }
  return result;
}*/

