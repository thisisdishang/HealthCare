import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital_appointment/constants.dart';
import 'package:intl/intl.dart';

import '../models/patient_data.dart';
import 'home/patient_home_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Appoin_time extends StatefulWidget {
  var uid;
  var name;

  Appoin_time({
    this.uid,
    this.name,
  });

  @override
  _Appoin_timeState createState() => _Appoin_timeState();
}

class _Appoin_timeState extends State<Appoin_time> {
  final morining = [
    "09:00am - 10:00am",
    "10:30am - 12:00am",
  ];
  final afternoon = [
    "12:00pm - 1:00pm",
    "3:00pm - 4:00pm",
    "4:30pm - 6:00pm",
  ];
  final evening = [
    "6:00pm - 7:00pm",
    "7:30pm - 9:00pm",
  ];
  bool isEnabled1 = false;
  bool sloact_book = false;
  var isEnabled2 = 2;
  var mydate;
  var c_date;
  var time;
  final now = DateTime.now();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  var firestoreInstance = FirebaseFirestore.instance;
  var today_app1 = 0;
  var today_app2 = 0;
  var today_app3 = 0;
  var today_app4 = 0;
  var today_app5 = 0;
  var today_app6 = 0;
  var today_app7 = 0;

  var timeslot;

  @override
  void initState() {
    super.initState();
    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("patient")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());

      setState(() {});

      print("++++++++++++++++++++++++++++++++++++++++++" + user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 10;
    final double itemWidth = size.width / 4;

    /*   firestoreInstance.collection('docter/' + widget.uid + '/user').where('date', isEqualTo: c_date)
        .snapshots().listen(
            (data) => print()
    );*/

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Appointment Time",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                       // primary: kPrimaryColor,
                        backgroundColor: kPrimaryColor,
                        fixedSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () async {
                      mydate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(Duration(days: 1)),
                          firstDate: DateTime.now().add(Duration(days: 1)),
                          lastDate: DateTime.now().add(Duration(days: 2)));

                      setState(() {
                        final now = DateTime.now();
                        c_date = DateFormat('dd-MM-yyyy').format(mydate);
                      });
                    },
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          c_date == null
                              ? Text(
                            "Select Date",
                            style: TextStyle(color: Colors.white),
                          )
                              : Text(
                            c_date,
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                //************************************************
                //  MORNING
                //************************************************
                Row(
                  children: [
                    Icon(
                      Icons.wb_twighlight,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "MORNING",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // MORNING Button 1.........................................
                    GestureDetector(
                        child: today_app1 >= 2
                            ? time_Button(morining[0])
                            : Container(
                            height: 50,
                            width: 150,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: time == morining[0]
                                  ? Colors.green
                                  : kPrimaryColor,
                            ),
                            child: Center(
                                child: Text(
                                  morining[0],
                                  style: TextStyle(color: Colors.white),
                                )) // child widget, replace with your own
                        ),
                        onTap: () {
                          if (today_app1 < 2) {
                            if (c_date == null) {
                              Fluttertoast.showToast(
                                  msg: " Please Select Date First");
                            } else {
                              time = morining[0];
                              timeslot = 1;
                              isEnabled1 = true;
                            }
                          } else
                            Fluttertoast.showToast(msg: "Slot Full");
                        }),

                    // MORNING Button 2.........................................
                    GestureDetector(
                      onTap: () {
                        if (today_app2 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First");
                          } else {
                            time = morining[1];
                            isEnabled1 = true;
                            timeslot = 2;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app2 >= 2
                          ? time_Button(morining[1])
                          : Container(
                          height: 50,
                          width: 150,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: time == morining[1]
                                ? Colors.green
                                : kPrimaryColor,
                          ),
                          child: Center(
                              child: Text(
                                morining[1],
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                      ),
                    ),
                  ],
                ),

                //************************************************
                //  AFTERNOON
                //************************************************
                Row(
                  children: [
                    Icon(Icons.wb_sunny, color: Colors.amber),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "AFTERNOON",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AFTERNOON Button 1.......................................
                    GestureDetector(
                      onTap: () {
                        if (today_app3 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First");
                          } else {
                            time = afternoon[0];
                            timeslot = 3;
                            isEnabled1 = true;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app3 >= 2
                          ? time_Button(afternoon[0])
                          : Container(
                          height: 50,
                          width: 150,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: time == afternoon[0]
                                ? Colors.green
                                : kPrimaryColor,
                          ),
                          child: Center(
                              child: Text(
                                afternoon[0],
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                      ),
                    ),
                    // AFTERNOON Button 2.......................................
                    GestureDetector(
                      onTap: () {
                        if (today_app4 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First");
                          } else {
                            time = afternoon[1];
                            timeslot = 4;
                            isEnabled1 = true;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app4 >= 2
                          ? time_Button(afternoon[1])
                          : Container(
                          height: 50,
                          width: 150,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: time == afternoon[1]
                                ? Colors.green
                                : kPrimaryColor,
                          ),
                          child: Center(
                              child: Text(
                                afternoon[1],
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                      ),
                    ),
                  ],
                ),
                // AFTERNOON Button 3...........................................
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (today_app5 < 2) {
                        if (c_date == null) {
                          Fluttertoast.showToast(
                              msg: " Please Select Date First");
                        } else {
                          time = afternoon[2];
                          timeslot = 5;
                          isEnabled1 = true;
                        }
                      } else
                        Fluttertoast.showToast(msg: "Slot Full");
                    },
                    child: today_app5 >= 2
                        ? time_Button(afternoon[2])
                        : Container(
                        height: 50,
                        width: 150,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: time == afternoon[2]
                              ? Colors.green
                              : kPrimaryColor,
                        ),
                        child: Center(
                            child: Text(
                              afternoon[2],
                              style: TextStyle(color: Colors.white),
                            )) // child widget, replace with your own
                    ),
                  ),
                ),
                //************************************************
                //  EVENING
                //************************************************
                Row(
                  children: [
                    Icon(Icons.wb_twighlight, color: Colors.amber),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "EVENING",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // EVENING Button 1.........................................
                    GestureDetector(
                      onTap: () {
                        if (today_app6 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First");
                          } else {
                            time = evening[0];
                            timeslot = 6;
                            isEnabled1 = true;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app6 >= 2
                          ? time_Button(evening[0])
                          : Container(
                          height: 50,
                          width: 150,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: time == evening[0]
                                ? Colors.green
                                : kPrimaryColor,
                          ),
                          child: Center(
                              child: Text(
                                evening[0],
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                      ),
                    ),
                    // EVENING Button 2.........................................
                    GestureDetector(
                      onTap: () {
                        if (today_app7 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First");
                          } else {
                            time = evening[1];
                            timeslot = 7;
                            isEnabled1 = true;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app7 >= 2
                          ? time_Button(evening[1])
                          : Container(
                          height: 50,
                          width: 150,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: time == evening[1]
                                ? Colors.green
                                : kPrimaryColor,
                          ),
                          child: Center(
                              child: Text(
                                evening[1],
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                      ),
                    ),
                  ],
                ),
                /* Center(
                  child: Container(
                    width: size.width * 0.8,
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      color: kPrimaryColor,
                      onPressed: today_app1 <=2
                          ?() {}: null,
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                ),*/
                SizedBox(
                  height: size.height * 0.25,
                ),
                Center(
                  child: Container(
                    width: size.width * 0.8,
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: kPrimaryColor,
                      ),
                      onPressed: isEnabled1
                          ? () {
                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        firebaseFirestore
                            .collection('pending')
                            .add({
                          'pid': loggedInUser.uid.toString(),
                          'name': loggedInUser.name.toString() +
                              " " +
                              loggedInUser.last_name.toString(),
                          'date': c_date,
                          'time': time,
                          'approve': false,
                          'did': widget.uid,
                          'phone': loggedInUser.phone,
                          'doctor_name': widget.name.toString(),
                          'visited': false,
                          'rating': false,
                          'status': false,
                        })
                            .then((value) =>
                            Fluttertoast.showToast(
                                msg: "Pending Appointment",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0))
                            .then((value) =>
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) =>
                                    AdvanceCustomAlert(
                                        widget.name.toString())))
                            .catchError((e) {
                          print('Error Data2' + e.toString());
                        });

                        /*setState(() {
                            print("Sleact Time" + time);
                          });*/
                      }
                          : null,
                      child: Text(
                        'Book Appointment',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    /*RaisedButton(
                  shape: StadiumBorder(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  color: kPrimaryColor,
                  onPressed: isEnabled1
                      ? () {
                          FirebaseFirestore firebaseFirestore =
                              FirebaseFirestore.instance;
                          firebaseFirestore
                              .collection('doctor/' + widget.uid + '/user')
                              .add({
                            'name': loggedInUser.name,
                            'date': c_date,
                            'time': time,
                            'timeslot': timeslot,
                          }).catchError((e) {
                            print("Error Data " + e.toString());
                          });
                          firebaseFirestore
                              .collection('patient/' +
                                  loggedInUser.uid.toString() +
                                  '/appointment')
                              .add({
                                'name': widget.name,
                                'date': c_date,
                                'time': time
                              })
                              .then((value) => Fluttertoast.showToast(
                                  msg: "Confirm Appointment",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: kPrimaryColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0))
                              .then((value) => showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) =>
                                      AdvanceCustomAlert(
                                          widget.name.toString())))
                              .catchError((e) {
                                print('Error Data2' + e.toString());
                              });

                          /*setState(() {
                            print("Sleact Time" + time);
                          });*/
                        }
                      : null,
                  child: Text(
                    'Book Appointment',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),*/
                  ),
                ),
                /*  Container(
                  width: 100,
                  height: 50,
                  child: AnimatedButton(
                    text: 'Warning Dialog',
                    color: Colors.orange,
                    pressEvent: () {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.WARNING,
                          headerAnimationLoop: false,
                          animType: AnimType.TOPSLIDE,
                          showCloseIcon: true,
                          closeIcon: Icon(Icons.close_fullscreen_outlined),
                          title: 'Warning',
                          desc:
                          'Dialog description here..................................................',
                          btnCancelOnPress: () {},
                          onDissmissCallback: (type) {
                            debugPrint('Dialog Dissmiss from callback $type');
                          },
                          btnOkOnPress: () {})
                          .show();
                    },
                  ),
                ),*/

                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: morining[0])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app1 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                    // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: morining[1])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app2 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                    // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: afternoon[0])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app3 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                    // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: afternoon[1])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app4 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                    // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: afternoon[2])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app5 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                    // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: evening[0])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app6 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox(); /*Text(
                        today_app6.toString(),
                        style: const TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );*/
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                    // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: evening[1])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app7 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget time_Button(time) {
    return Container(
        height: 50,
        width: 150,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.black26,
        ),
        child: Center(
            child: Text(
              time,
              style: TextStyle(color: Colors.white),
            )) // child widget, replace with your own
    );
  }

  Widget time_Button_active(time,
      button_time,) {
    return Container(
        height: 50,
        width: 150,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: time == button_time ? Colors.green : kPrimaryColor,
        ),
        child: Center(
            child: Text(
              time,
              style: TextStyle(color: Colors.white),
            )) // child widget, replace with your own
    );
  }
}

class AdvanceCustomAlert extends StatelessWidget {
  var name;

  AdvanceCustomAlert(String name) {
    this.name = name;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          // overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 280,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 120, 10, 10),
                child: Column(
                  children: [
                    Text(
                      'Dr. ' + name,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Pending till doctor confirm this appointment request.',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => HomePage()),
                                (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor),
                      child: Text(
                        'Okay',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: 15,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 45,
                  child: Image.asset('assets/images/logo.jpg'),
                  // Icon(Icons.assistant_photo, color: Colors.white, size: 50,),
                )),
          ],
        ));
  }
}
