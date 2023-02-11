import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../componets/loadingindicator.dart';
import '../../../constants.dart';
import '../../../models/patient_data.dart';

class Pending extends StatefulWidget {
  const Pending({Key? key}) : super(key: key);

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  var appointment = FirebaseFirestore.instance;
  UserModel loggedInUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;
  var today_date = (DateFormat('dd-MM-yyyy')).format(DateTime.now()).toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("patient")
        .doc(user!.uid)
        .get()
        .then((value) {
      print(user!.uid);
      loggedInUser = UserModel.fromMap(value.data());
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          // Check that the widget is still mounted
          setState(() {
            isLoading = false;
          });
        }
      });
    });
  }

  // Stream<QuerySnapshot> pt = FirebaseFirestore.instance
  //     .collection('pending')
  //     .where("pid",
  //         isEqualTo: /*user!.uid.toString()*/ "SZlIi4DRdyaFNT9G54ZMKBSCpzD2")
  //     .snapshots();

  @override
  Widget build(BuildContext context) {
    var firebase = appointment
        .collection('pending')
        .orderBy('date', descending: false)
        .orderBy('time', descending: false)
        .where('pid', isEqualTo: loggedInUser.uid)
        .where('approve', isEqualTo: false)
        .where('date', isGreaterThanOrEqualTo: today_date)
        .snapshots();

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: firebase,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // final List ptdata = [];
              // snapshot.data!.docs.map((DocumentSnapshot document) {
              //   Map a = document.data() as Map<String, dynamic>;
              //   ptdata.add(a);
              //   print(ptdata);
              //   print(pt);
              // });

              if (!snapshot.hasData) {
                return Container(
                    height: size.height * 1,
                    child: Center(
                        child: Text("You Do Not Have An Appointment today.")));
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

                            return snapshot.hasError
                                ? Center(child: Text("Doctor Not Available"))
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    child: Container(
                                      height: 104,
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
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                top: 8.0),
                                                        child: Text(
                                                          "Dr." +
                                                              doc['doctor_name'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ) // child widget, replace with your own
                                                      ),
                                                  Container(
                                                      width: double.infinity,
                                                      margin: EdgeInsets.only(
                                                          top: 3),
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text(
                                                          "Date: " +
                                                              doc['date'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ) // child widget, replace with your own
                                                      ),
                                                  Container(
                                                      width: double.infinity,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text(
                                                          "Time: " +
                                                              doc['time'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87,
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
                                                bottom: 5,
                                                right: 10,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12), // <-- Radius
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
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
                                                        "Cancel ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
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
            height: MediaQuery.of(context).size.height * 0.27,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  Text(
                    'are you sure you want to cancel this Appointment?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
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
                            'NO',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
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
                                'YES',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
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
          Positioned(
              top: -50,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 50,
                child: Image.asset('assets/images/logo.jpg'),
              )),
        ],
      ),
    );
  }
}
