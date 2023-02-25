import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hospital_appointment/Screens/detail_page.dart';
import 'package:hospital_appointment/cells/category_cell.dart';
import 'package:hospital_appointment/cells/hd_cell.dart';
import 'package:hospital_appointment/cells/trd_cell.dart';
import 'package:hospital_appointment/models/category.dart';
import 'package:hospital_appointment/models/doctor.dart';
import 'package:hospital_appointment/widget/drawer.dart';
import 'package:intl/intl.dart';
import '../../newapp/carouselSlider.dart';
import '../../newapp/notificationList.dart';
import '../../constants.dart';
import '../../models/patient_data.dart';
import '../../newapp/searchList.dart';
import '../../services/shared_preferences_service.dart';
import '../../widget/DoctorDrawer.dart';
import '../Appointment.dart';
import '../Profile/profile.dart';
import '../disease_page.dart';
import '../docter_page.dart';
import 'dart:ui';
import 'package:flutter/painting.dart';
import '../login/loginas.dart';

late BuildContext context1;
var uid;
DoctorModel loggedInUser = DoctorModel();

class DocHomePage extends StatefulWidget {
  @override
  _DocHomePageState createState() => _DocHomePageState();
}

var myDoc;

class _DocHomePageState extends State<DocHomePage> {
  List<Category> _categories = <Category>[];

  // UserModel loggedInUser = UserModel();
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
  double rating = 0.0;
  late TabController tabController;
  DoctorModel loggedInUser = DoctorModel();

  // DoctorModel loggedInUser = DoctorModel();

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
    context1 = context;
    var today_date =
    (new DateFormat('dd-MM-yyyy')).format(DateTime.now()).toString();

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
        // automaticallyImplyLeading: false,
        // actions: <Widget>[Container()],
        // backgroundColor: kPrimaryColor,
        // elevation: 0,
        // title: Container(
        //   padding: EdgeInsets.only(top: 5),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Container(
        //         //width: MediaQuery.of(context).size.width/1.3,
        //         alignment: Alignment.center,
        //         child: Text(
        //           _message,
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 20,
        //             fontWeight: FontWeight.w400,
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         width: 55,
        //       ),
        //       //Notification icon
        //       IconButton(
        //         splashRadius: 20,
        //         icon: Icon(Icons.notifications_active),
        //         onPressed: () {
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => NotificationList()));
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ),
      body: loggedInUser.uid == null
          ? Center(
        child: Text("Wait for few seconds"),
      )
          : SingleChildScrollView(
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
                  fontSize: 30,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
// les's find doctor
//             Container(
//               alignment: Alignment.centerLeft,
//               padding: EdgeInsets.only(left: 20, bottom: 15),
//               child: Text(
//                 "Let's Find Your\nDoctor",
//                 style: TextStyle(
//                   fontSize: 35,
//                   color: kPrimaryColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Container(
//                 margin: EdgeInsets.only(top: 5),
//                 child: _hDoctorsSection()),

// Search doctor
//                   Container(
//                     padding: EdgeInsets.fromLTRB(20, 0, 20, 25),
//                     child: TextFormField(
//                       textInputAction: TextInputAction.search,
//                       controller: _doctorName,
//                       decoration: InputDecoration(
//                         contentPadding:
//                         EdgeInsets.only(left: 20, top: 10, bottom: 10),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                           borderSide: BorderSide.none,
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         hintText: 'Search doctor',
//                         hintStyle: TextStyle(
//                           color: Colors.black26,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w800,
//                         ),
//                         suffixIcon: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.blue[900]?.withOpacity(0.9),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: IconButton(
//                             iconSize: 20,
//                             splashRadius: 20,
//                             color: Colors.white,
//                             icon: Icon(FlutterIcons.search1_ant),
//                             onPressed: () {},
//                           ),
//                         ),
//                       ),
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w800,
//                       ),
//                       onFieldSubmitted: (String value) {
//                         setState(
//                               () {
//                             value.length == 0
//                                 ? Container()
//                                 : Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SearchList(
//                                   searchKey: value,
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),

//ads..
//             Container(
//               padding: EdgeInsets.only(top: 18, left: 23, bottom: 15),
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "We care for you",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: kPrimaryColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18),
//               ),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               child: Carouselslider(),
//             ),


          ],
        ),
      ),
    );
  }
}


