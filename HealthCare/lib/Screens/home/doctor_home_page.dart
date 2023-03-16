import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital_appointment/models/doctor.dart';
import 'package:intl/intl.dart';
import '../../componets/loadingindicator.dart';
import '../../constants.dart';
import '../../services/shared_preferences_service.dart';
import '../../widget/DoctorDrawer.dart';
import 'dart:ui';
import 'package:flutter/painting.dart';

late BuildContext context1;
var uid;

class DocHomePage extends StatefulWidget {
  @override
  _DocHomePageState createState() => _DocHomePageState();
}

var myDoc;

class _DocHomePageState extends State<DocHomePage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  var today_date = (DateFormat('dd-MM-yyyy')).format(DateTime.now()).toString();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _doctorName = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference firebase =
      FirebaseFirestore.instance.collection("doctor");
  var appointment = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;
  final PrefService _prefService = PrefService();
  bool isLoading = true;
  late TabController tabController;
  DoctorModel loggedInUser = DoctorModel();

  /// **********************************************
  /// ACTIONS
  /// **********************************************

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  Future _signOut() async {
    await _auth.signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _doctorName = new TextEditingController();
    // tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    loggedInUser = DoctorModel();
    FirebaseFirestore.instance
        .collection("doctor")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = DoctorModel.fromMap(value.data());
      setState(() {
        sleep(Duration(microseconds: 10));
        isLoading = false;
        // dialog();/*Alert(context: HomePage);*/
      });
    });
  }

  @override
  void dispose() {
    _doctorName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var firebase = appointment
        .collection('pending')
        .orderBy('date', descending: false)
        .orderBy('time', descending: false)
        .where('did', isEqualTo: loggedInUser.uid)
        .where('approve', isEqualTo: false)
        .where('date', isGreaterThanOrEqualTo: today_date)
        .snapshots();

    var size = MediaQuery.of(context).size;

    context1 = context;

    sleep(Duration(seconds: 1));
    var _message;
    DateTime now = DateTime.now();
    String _currentHour = DateFormat('kk').format(now);
    int hour = int.parse(_currentHour);

    List<Widget> _pages = [
      DocHomePage(),
    ];
    setState(
      () {
        if (hour >= 5 && hour < 12) {
          _message = 'Good Morning';
        } else if (hour >= 12 && hour <= 17) {
          _message = 'Good Afternoon';
        } else {
          _message = 'Good Evening';
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: loggedInUser.uid == null ? SizedBox() : DocDrawer(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 78),
          child: Text("HealthCare"),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            // Hello
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Text(
                "Hello \nDr. " + loggedInUser.name.toString() + "\n" + _message,
                style: TextStyle(
                  fontSize: 32,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Text(
                "Your's Today Appointment :",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firebase,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        height: size.height * 1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 300),
                          child: Center(
                              child: Text(
                                  "You Do Not Have An Appointment today.")),
                        ));
                  } else {
                    return isLoading
                        ? Container(
                            margin: EdgeInsets.only(top: size.height * 0.4),
                            child: Center(
                              child: Loading(),
                            ),
                          )
                        : SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final DocumentSnapshot doc =
                                    snapshot.data!.docs[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  child: Container(
                                    height: 108,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: kPrimaryLightColor,
                                        ),
                                        child: Stack(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 8.0),
                                                      child: Text(
                                                        doc['name'],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ) // child widget, replace with your own
                                                    ),
                                                Container(
                                                    width: double.infinity,
                                                    margin:
                                                        EdgeInsets.only(top: 3),
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Text(
                                                        "Date: " + doc['date'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ) // child widget, replace with your own
                                                    ),
                                                Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,top: 4),
                                                      child: Text(
                                                        "Time: " + doc['time'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ) // child widget, replace with your own
                                                    ),
                                              ],
                                            ),
                                            Positioned(
                                              bottom: 5,
                                              left: 8,
                                              child: Text(
                                                "Status : Pending",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              right: 10,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: kPrimarydark,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12), // <-- Radius
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext
                                                              context) =>
                                                          confirm(id: doc.id));
                                                  // alertdialog(doc.id);

                                                  //   Navigator.pop(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10),
                                                    child: Text(
                                                      "✅",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 4,
                                              right: 10,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: kPrimarydark,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12), // <-- Radius
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext
                                                              context) =>
                                                          alertdialog(
                                                              id: doc.id));
                                                  // alertdialog(doc.id);

                                                  //   Navigator.pop(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10),
                                                    child: Text(
                                                      "❌",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class alertdialog extends StatelessWidget {
  var id;

  alertdialog({required this.id});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Stack(
        //overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.30,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      'Are you sure you want to cancel this Appointment?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  //child: ),

                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('pending')
                                  .doc(id)
                                  .delete();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 19),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Positioned(
                top: -50,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50,
                  child: Image.asset('assets/images/account.png'),
                )),
          ),
        ],
      ),
    );
  }
}

class confirm extends StatelessWidget {
  var id;

  confirm({required this.id});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Stack(
        //overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.30,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      'Are you sure you want to confirm this Appointment?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  //child: ),

                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('pending')
                                  .doc(id)
                                  .update({
                                'approve': true,
                              });
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 19),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Positioned(
                top: -50,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50,
                  child: Image.asset('assets/images/account.png'),
                )),
          ),
        ],
      ),
    );
  }
}
