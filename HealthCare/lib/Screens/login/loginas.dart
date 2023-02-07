import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital_appointment/Screens/login/patientlogin.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../constants.dart';
import '../../widget/Alert_Dialog.dart';
import '../home/patient_home_page.dart';
import 'Patient_registration.dart';

class Loginas extends StatefulWidget {
  const Loginas({Key? key}) : super(key: key);

  @override
  State<Loginas> createState() => _LoginasState();
}

class _LoginasState extends State<Loginas> {
  var _isObscure = false;

  // var t_email, t_password;
  var user = FirebaseFirestore.instance.collection("patient").snapshots();

  var auth = FirebaseAuth.instance;
  var result;
  var subscription;
  bool status = false;

  getConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
// I am connected to a mobile network.
      status = true;
      print("Mobile Data Connected !");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Wifi Connected !");
      status = true;
// I am connected to a wifi network.
    } else {
      print("No Internet !");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          status = false;
        });
      } else {
        setState(() {
          status = true;
        });
      }
    });
  }

  Future<bool> getInternetUsingInternetConnectivity() async {
    result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
    }
    return result;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // t_password.dispose();
    // t_email.dispose();
    subscription.cancel();
    super.dispose();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isEmailValid(String email) {
      var pattern =
          r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      return regex.hasMatch(email);
    }

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/1.jpeg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // SafeArea(
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: Container(
          //       alignment: Alignment.topLeft,
          //       padding: EdgeInsets.only(top: 280.0, left: 25),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'HELLO',
          //             style: TextStyle(
          //                 color: Colors.black,
          //                 fontSize: 50,
          //                 fontWeight: FontWeight.w700),
          //           ),
          //           Text(
          //             'Welcome to DocsApp!',
          //             style: TextStyle(
          //                 color: Colors.indigo[800],
          //                 fontSize: 17,
          //                 fontWeight: FontWeight.w400),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.black26.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: ElevatedButton(
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (contex) => login_page()));
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                primary: Colors.deepPurple[600],
                                onPrimary: Colors.deepPurple[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: ElevatedButton(
                              child: Text(
                                "Create an Account",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (contex) => Registration()));
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                primary: Colors.white,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                        ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width / 1.1,
                        //   child: ButtonTheme(
                        //     minWidth: double.infinity,
                        //     height: 50.0,
                        //     child: RaisedButton(
                        //       color: Colors.indigo[800],
                        //       child: Text(
                        //         "Create an account",
                        //         style: GoogleFonts.lato(
                        //           color: Colors.white,
                        //           fontSize: 18.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //       onPressed: () => _pushPage(context, Register()),
                        //     ),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: new BorderRadius.circular(25),
                        //     ),
                        //   ),
                        //   padding: const EdgeInsets.all(16),
                        //   alignment: Alignment.center,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    void _pushPage(BuildContext context, Widget page) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => page),
      );
    }
  }

  void sigin(var email, var password) async {
    if (_formkey.currentState!.validate()) {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                print("Login Successful"),
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                ),
              })
          .catchError((e) {
        print(e);
      });
    }
  }
}
