import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../../constants.dart';
import '../../models/doctor.dart';
import '../../services/shared_preferences_service.dart';

import '../models/patient_data.dart';
import 'Pages/Patient/Confirm_Appointment.dart';
import 'Pages/Patient/Patient_RecentList.dart';
import 'Pages/Patient/Pending.dart';


class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> with SingleTickerProviderStateMixin {
  UserModel loggedInUser = UserModel();
  final CollectionReference firebase =
      FirebaseFirestore.instance.collection('doctor');
  var appointment = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    tabController = TabController(length: 3, initialIndex: 0, vsync: this);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[600],
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Container(
            width: 50,
            child: Icon(
              Icons.arrow_back,
              size: 35,
            ),
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Appointment', style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
        actions: <Widget>[],
        bottom: TabBar(
          controller: tabController,
          labelStyle: TextStyle(fontSize: 18),
          indicatorColor: Colors.white,
          tabs: [

            Tab(
              text: 'Confirm',
            ),
            Tab(text: 'Pending',),
            Tab(text: 'Recent',),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Confirm_Appointment(),
          Pending(),
          Patient_RecentList()

        ],
      ),
      /*Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: appointment
                  .collection('pending')
                  .where('pid', isEqualTo: loggedInUser.uid)
                  .snapshots(),
              /*.collection(
                            'patient/' + loggedInUser.uid.toString() + '/appointment')
                            .snapshots(),*/
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return new Text("There is no expense");
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    // shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot doc = snapshot.data!.docs[index];

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: kPrimaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    "Mr." +
                                        loggedInUser.name.toString() +
                                        " confirm appointmentpon with Dr." +
                                        doc['name'] +
                                        " on " +
                                        doc['date'] +
                                        " and  " +
                                        doc['time'].toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                                ) // child widget, replace with your own
                                ),
                          ],
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ),*/
    );
  }


}
