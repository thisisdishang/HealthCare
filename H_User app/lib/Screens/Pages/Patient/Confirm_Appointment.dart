import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../componets/loadingindicator.dart';
import '../../../models/patient_data.dart';
import 'Pending.dart';

class Confirm_Appointment extends StatefulWidget {
  const Confirm_Appointment({Key? key}) : super(key: key);

  @override
  State<Confirm_Appointment> createState() => _Confirm_AppointmentState();
}

class _Confirm_AppointmentState extends State<Confirm_Appointment> {
  var appointment = FirebaseFirestore.instance;
  UserModel loggedInUser = UserModel();
  var user = FirebaseAuth.instance.currentUser;
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var firebase = appointment
        .collection('pending')
        .orderBy('date', descending: true)
        .orderBy('time', descending: false)
        .where("pid", isEqualTo: loggedInUser.uid)
        .where('approve', isEqualTo: true)
        .where('status', isEqualTo:  false)
        .where('date', isGreaterThanOrEqualTo: today_date)
        .snapshots();
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: firebase,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    height: size.height*1,
                    child: Center(child: Text("You Do Not Have An Appointment today.")));
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
                            // return Text("Popat");
                            /*  return ListData(doc['name'], doc['time'], size, doc['phone'],"Confirm",(){
                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        firebaseFirestore
                            .collection('doctor/' + doc['did'] + '/user')
                            .add({
                          'name': doc['name'],
                          'date': doc['date'],
                          'time': doc['time'],
                        }).catchError((e) {
                          print("Error Data " + e.toString());
                        });
                        firebaseFirestore
                            .collection('patient/' +doc['pid']+toString() +
                            '/appointment')
                            .add({
                          'name':loggedInUser.name,
                          'date': doc['date'],
                          'time': doc['time']
                        }).catchError((e) {
                          print('Error Data2' + e.toString());
                        });
                      //  await Future.delayed(Duration(seconds: 2));
                                  appointment.collection('pending').doc(doc.id).delete();

                      });*/
                            Future.delayed(Duration(seconds: 3));
                            return snapshot.hasData == null
                                ? Center(child: Text("Doctor Not Available"))
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Container(
                                      height: 110,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: Colors.green.shade400,
                                          ),

                                          /*  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(8.0),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green,
                                          Colors.green.shade400,
                                          Colors.white,
                                       //   Colors.yellow.shade300,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),*/
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
                                                          /* "Your confirm appointment with Dr." +
                                                        doc['doctor_name'] +
                                                        " is Confirmed at  " +
                                                        doc['date'] +
                                                        " and  " +
                                                        doc['time'].toString(),*/
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                          /* "Your confirm appointment with Dr." +
                                                        doc['doctor_name'] +
                                                        " is Confirmed at  " +
                                                        doc['date'] +
                                                        " and  " +
                                                        doc['time'].toString(),*/
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                          /* "Your confirm appointment with Dr." +
                                                        doc['doctor_name'] +
                                                        " is Confirmed at  " +
                                                        doc['date'] +
                                                        " and  " +
                                                        doc['time'].toString(),*/
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                  "Status : Confirm",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                            /*if(!snapshot.hasData){
                              return Center(child: Text("Doctor Not Available"));
                            }*/
                            /*
                            Card(
                             child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: doc['approve'] == false ?Colors.orangeAccent:Colors.green//kPrimaryColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                          "Mr." +
                                              loggedInUser.name.toString() +
                                              " confirm appointmentpon with Dr." +
                                              doc['doctor_name'] +
                                              " on " +
                                              doc['date'] +
                                              " and  " +
                                              doc['time'].toString(),
                                          style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                                        )),
                                  ) // child widget, replace with your own
                              ),
                            );*/
                          },
                        ),
                      );
              }
            }),
      ),
    );
  }
}
