import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital_appointment/Screens/Profile/profile.dart';
import 'package:hospital_appointment/Screens/login/doctorlogin.dart';
import 'package:hospital_appointment/Screens/login/patientlogin.dart';
import 'package:hospital_appointment/constants.dart';
import 'package:hospital_appointment/newapp/notificationList.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Screens/login/loginas.dart';
import '../models/patient_data.dart';
import '../newapp/docuserProfile.dart';
import '../newapp/userProfile.dart';
import '../services/shared_preferences_service.dart';

class DocDrawer extends StatefulWidget {
  @override
  State<DocDrawer> createState() => _DocDrawerState();
}

class _DocDrawerState extends State<DocDrawer> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final PrefService _prefService = PrefService();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("Doctor")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      Future<void>.delayed(const Duration(microseconds: 1), () {
        if (mounted) {
          // Check that the widget is still mounted
          setState(() {
            isLoading = false;
          });
        }
      });
      print("++++++++++++++++++++++++++++++++++++++++++" + user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: <Widget>[
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
              child: loggedInUser.profileImage == false
                  ? CircleAvatar(
                backgroundImage:
                AssetImage('assets/images/account.png'),
                radius: 50,
              )
                  : CircleAvatar(
                backgroundImage:
                NetworkImage(loggedInUser.profileImage),
                backgroundColor: Colors.grey,
              ),
            ),
          ),

          //profile
          // CustomList(Icons.person, "Profile", () {
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => DocUserProfile()));
          // }),

          // Privacy Policy
          CustomList(Icons.announcement, "Privacy Policy", () async {
            if (!await launch(
              'https://nik-jordan-privacy-policy.blogspot.com/2021/08/privacy-policy.html',
              forceSafariVC: false,
              forceWebView: false,
              headers: <String, String>{
                HttpHeaders.authorizationHeader: 'my_header_value'
              },
            )) {
              throw 'Could not launch ';
            }
          }),
          // CustomList(Icons.notifications_active, "Notification", () {
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => NotificationList()));
          // }),
          CustomList(Icons.lock, "Log Out", () async {
            await FirebaseAuth.instance.signOut();
            _prefService.removeCache("password");
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => doctor_page()));
          }),
        ],
      ),
    );
  }
}

class CustomList extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomList(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12))),
        child: InkWell(
          splashColor: kPrimaryColor,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Colors.grey.shade600,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
          onTap: () {
            onTap();
          },
        ),
      ),
    );
  }
}
