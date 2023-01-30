import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hospital_appointment/Screens/Appointment.dart';
import '../Screens/Profile/profile.dart';
import '../constants.dart';
import '../models/category.dart';
import '../models/patient_data.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital_appointment/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path/path.dart';
import '../../componets/loadingindicator.dart';
import '../../models/patient_data.dart';
import '../../widget/Alert_Dialog.dart';

late BuildContext context1;
var uid;
UserModel loggedInUser = UserModel();

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

// List<Category> _categories = <Category>[];
//
// final CollectionReference firebase =
// FirebaseFirestore.instance.collection('doctor');
// var appointment = FirebaseFirestore.instance;
User? user = FirebaseAuth.instance.currentUser;
var file;

class _UserProfileState extends State<UserProfile> {
  //
  // final CollectionReference firebase =
  // FirebaseFirestore.instance.collection('doctor');
  // var appointment = FirebaseFirestore.instance;
  // User? user = FirebaseAuth.instance.currentUser;
  // FirebaseAuth _auth = FirebaseAuth.instance;
  //
  //
  // Future<void> _getUser() async {
  //   user = _auth.currentUser;
  // }
  User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var t_address;
  var mydate;
  var t_date;
  var t_age;
  var name;
  var last_name;
  var file;
  var phoneController;
  var gender;
  var subscription;
  bool status = false;

  var result;

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

  @override
  void initState() {
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
    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("patient")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        isLoading = false;
      });
      print("++++++++++++++++++++++++++++++++++++++++++" + user!.uid);
    });
  }

  // void initState() {
  //   super.initState();
  //
  //   // _categories = _getCategories();
  //
  //   loggedInUser = UserModel();
  //   FirebaseFirestore.instance
  //       .collection("patient")
  //       .doc(user!.uid)
  //       .get()
  //       .then((value) {
  //     loggedInUser = UserModel.fromMap(value.data());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // var margin_left = size.width * 0.07;
    // var margin_top = size.width * 0.03;
    // var margin_right = size.width * 0.07;
    // var boder = size.width * 0.6;
    return Scaffold(
      body: SafeArea(
        // child: NotificationListener<OverscrollIndicatorNotification>(
        //   onNotification: (OverscrollIndicatorNotification overscroll) {
        //     overscroll.disallowGlow();
        //
        //   },
        child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            kPrimaryColor,
                            kPrimaryLightColor,
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height / 8,
                      child: Container(
                        padding: EdgeInsets.only(top: 10, right: 7),
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            FlutterIcons.gear_faw,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile_page(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 5,
                      padding: EdgeInsets.only(top: 75),
                    ),
                  ],
                ),

                // Container(
                //   child: CircleAvatar(
                //     radius: 80,
                //     backgroundColor: Colors.white,
                //     backgroundImage: AssetImage(
                //         'assets/images/account.png'),
                //     // backgroundImage:
                //     // NetworkImage(
                //     //     loggedInUser
                //     //         .profileImage),
                //                   ),
                //
                //   decoration: BoxDecoration(
                //       border: Border.all(
                //         color: Color(0xD5E0F3EE),
                //         width: 5,
                //       ),
                //       shape: BoxShape.circle),
                // ),
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        kPrimaryColor,
                        kPrimaryLightColor,
                      ],
                    ),
                  ),
                  accountName: Text(loggedInUser.name.toString()),
                  accountEmail: Text(loggedInUser.email.toString()),
                  currentAccountPicture: Container(
                    // child: loggedInUser.profileImage == false
                    //     ? CircleAvatar(
                    //   backgroundImage:
                    //   AssetImage('assets/images/account.png'),
                    //   radius: 50,
                    // )
                    //     : CircleAvatar(
                    //   backgroundImage:
                    //   NetworkImage(loggedInUser.profileImage),
                    //   backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white, // ),
                      backgroundImage: AssetImage('assets/images/person.jpg'),
                      // backgroundImage:
                      // NetworkImage(
                      //     loggedInUser
                      //         .profileImage),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              padding: EdgeInsets.only(left: 20),
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey[50],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
//Email icon
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 27,
                          width: 27,
                          color: Colors.red[900],
                          child: Icon(
                            Icons.mail_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
// Email

                      Text(
                        "${loggedInUser.email}".toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
// Phone icon
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 27,
                          width: 27,
                          color: Colors.blue[800],
                          child: Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        loggedInUser.phone.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Container(
            //   margin:
            //   EdgeInsets.only(left: margin_left, top: margin_top),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text(
            //         "Email",
            //         style: TextStyle(
            //             color: kPrimaryColor,
            //             fontWeight: FontWeight.w600),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(
            //             left: margin_left, right: margin_right),
            //         width: boder,
            //         decoration: BoxDecoration(
            //           border: Border.all(
            //               width: 1.0, color: Colors.black12),
            //           borderRadius: BorderRadius.all(
            //               Radius.circular(5.0)
            //             //                 <--- border radius here
            //           ),
            //         ),
            //         padding: EdgeInsets.all(8),
            //         child: Text("${loggedInUser.email}".toString()),
            //       )
            //     ],
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 20),
              padding: EdgeInsets.only(left: 20, top: 20),
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey[50],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 27,
                          width: 27,
                          color: Colors.indigo[500],
                          child: Icon(
                            FlutterIcons.pencil_ent,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Bio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: getBio(),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 20),
              padding: EdgeInsets.only(left: 20, top: 20),
              height: MediaQuery.of(context).size.height / 5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey[50],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 27,
                          width: 27,
                          color: Colors.green[900],
                          child: Icon(
                            FlutterIcons.history_faw,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Appointment History",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 30,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (contex) => Appointment(),
                                ));
                              },
                              child: Text('View all'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: Container(
                        padding: EdgeInsets.only(left: 35, right: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget getBio() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        var userData = snapshot.data;
        return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10, left: 40),
          child: Text(
            'No bio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black38,
            ),
          ),
        );
      },
    );
  }
}
