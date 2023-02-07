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
import '../Appointment.dart';
import '../Profile/profile.dart';
import '../disease_page.dart';
import '../docter_page.dart';
import 'dart:ui';
import 'package:flutter/painting.dart';
import '../login/loginas.dart';

late BuildContext context1;
var uid;
UserModel loggedInUser = UserModel();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

var myDoc;

class _HomePageState extends State<HomePage> {
  List<Category> _categories = <Category>[];

  // UserModel loggedInUser = UserModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _doctorName = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference firebase =
      FirebaseFirestore.instance.collection('doctor');
  var appointment = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;
  final PrefService _prefService = PrefService();
  bool isLoading = true;
  double rating = 0.0;
  late TabController tabController;
  UserModel loggedInUser = UserModel();

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
    _categories = _getCategories();
    // tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("patient")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        sleep(Duration(microseconds: 10));
        isLoading = false;
        // dialog();/*Alert(context: HomePage);*/
      });
    });
  }

  // void initState() {
  //   // TODO: implement initState
  //
  //   super.initState();
  //
  //   tabController = TabController(length: 3, initialIndex: 0, vsync: this);
  //   loggedInUser = UserModel();
  //   FirebaseFirestore.instance
  //       .collection("patient")
  //       .doc(user!.uid)
  //       .get()
  //       .then((value) {
  //     loggedInUser = UserModel.fromMap(value.data());
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }

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
    // print("DialgUId: "+uid);
    sleep(Duration(seconds: 1));
    var _message;
    DateTime now = DateTime.now();
    String _currentHour = DateFormat('kk').format(now);
    int hour = int.parse(_currentHour);

    List<Widget> _pages = [
      HomePage(),
      // DoctorsList(),
      //Center(child: Text('New Appointment')),
      Appointment(),
      Profile_page(),
    ];
    // setState(
    //       () {
    //     if (hour >= 5 && hour < 12) {
    //       _message = 'Good Morning';
    //     } else if (hour >= 12 && hour <= 17) {
    //       _message = 'Good Afternoon';
    //     } else {
    //       _message = 'Good Evening';
    //     }
    //   },
    // );
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("HealthCare"),

        // actions: [
        //   loggedInUser.uid == null
        //       ? IconButton(
        //       onPressed: () async {
        //         await FirebaseAuth.instance.signOut();
        //         _prefService.removeCache("password");
        //         Navigator.of(context).pushReplacement(
        //             MaterialPageRoute(builder: (context) => Loginas()));
        //       },
        //       icon: SvgPicture.asset(
        //         'assets/images/power.svg',
        //         color: Colors.white,
        //       ))
        //       : SizedBox()
        // ],
      ),
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           actions: <Widget>[Container()],
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: Container(
//             padding: EdgeInsets.only(top: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   //width: MediaQuery.of(context).size.width/1.3,
//                   alignment: Alignment.center,
//                   child: Text(
//                     _message,
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   ),
//                 SizedBox(
//                   width: 55,
//                 ),
// // logout button
//             IconButton(
//                           onPressed: () async {
//                             await FirebaseAuth.instance.signOut();
//                             _prefService.removeCache("password");
//                             Navigator.of(context).pushReplacement(
//                                 MaterialPageRoute(builder: (context) => Loginas()));
//                           },
//                           icon: SvgPicture.asset(
//                             'assets/images/power.svg',
//                             color: Colors.black,
//                           )
//                          ),
// //Notification icon
//             IconButton(
//                           splashRadius: 20,
//                           icon: Icon(Icons.notifications_active),
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (contex) => NotificationList()));
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
// //Notification icon
//               iconTheme: IconThemeData(
//                 color: Colors.black,
//               ),
//             ),

      // ************************************
      // Drawer
      //*************************************
      drawer: loggedInUser.uid == null ? SizedBox() : MyDrawer(),

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
                      "Hello " + loggedInUser.name.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
// les's find doctor
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20, bottom: 25),
                    child: Text(
                      "Let's Find Your\nDoctor",
                      style: TextStyle(
                        fontSize: 35,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 16),
                      child: _hDoctorsSection()),
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
//                   Container(
//                     padding: EdgeInsets.only(left: 23, bottom: 10),
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "We care for you",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           color: Colors.blue[800],
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18),
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Carouselslider(),
//                   ),

                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _pages[_selectedIndex],
                        Text(
                          'Appointment',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Appointment()),
                            );
                          },
                          child: Text(
                            'More..',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: appointment
                              .collection('pending')
                              .where('pid', isEqualTo: loggedInUser.uid)
                              .where('date', isEqualTo: today_date)
                              .where('status', isEqualTo: false)
                              .orderBy('time', descending: false)
                              .snapshots(),
                          /*.collection(
                            'patient/' + loggedInUser.uid.toString() + '/appointment')
                            .snapshots(),*/
                          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              print("snapshot =" + snapshot.toString());
                              return Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text("Appointment not Available"));
                            } else {
                              ub() {
                                if (snapshot.data?.docs.length == 0) {
                                  return 0;
                                } else if (snapshot.data?.docs.length == 1) {
                                  return 1;
                                } else {
                                  return 2;
                                }
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                // shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: ub(),
                                itemBuilder: (BuildContext context, int index) {
                                  final DocumentSnapshot doc =
                                      snapshot.data!.docs[index];
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: doc['approve'] == false
                                                    ? Colors.orangeAccent
                                                    : Colors
                                                        .green //kPrimaryColor,
                                                ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: doc['approve'] == false
                                                    ? Text(
                                                        "Your appointment with Dr." +
                                                            doc['doctor_name'] +
                                                            " is Pending at  " +
                                                            doc['date'] +
                                                            " and  " +
                                                            doc['time']
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                        " Your confirm appointment with Dr." +
                                                            doc['doctor_name'] +
                                                            " is Confirmed at " +
                                                            doc['date'] +
                                                            " and  " +
                                                            doc['time']
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                              ),
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
                  ),
                  //*************************************
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _categorySection(),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          child: _trDoctorsSection(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _hDoctorsSection() {
    return SizedBox(
      height: 199,
      child: Container(
          // height: mediyaquery.height * 0.78,
          child: StreamBuilder<QuerySnapshot>(
              stream: firebase.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text("Loding.."));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot doc = snapshot.data!.docs[index];
                      return HDCell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  uid: doc['uid'],
                                  name: doc['name'],
                                  email: doc['email'],
                                  address: doc['address'],
                                  experience: doc['experience'],
                                  specialist: doc['specialist'],
                                  profileImage: doc['profileImage'],
                                  description: doc['description'],
                                  phone: doc['phone'],
                                  doctor: _doctorName,
                                ),
                              ));
                        },
                        name: doc["name"].toString(),
                        email: doc["email"].toString(),
                        specialist: doc["specialist"].toString(),
                        profileImage: doc['profileImage'],
                      );
                    },
                  );
                }
              })),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    return snapshot.data!.docs
        .map((doc) => Container(
            width: double.infinity,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: kPrimaryColor,
            ),
            child: Center(
                child: Text(
              "Mr." +
                  loggedInUser.name.toString() +
                  " confirm appointmentpon with Dr." +
                  doc['age'] +
                  " on " +
                  doc['date'] +
                  " and  " +
                  doc['time'].toString(),
              style: TextStyle(color: Colors.white),
            )) // child widget, replace with your own
            ))
        .toList();
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************

  /// Highlighted Doctors Section

  /// Category Section
  Column _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Disease()),
                );
              },
              child: Text(
                'More..',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(indent: 16),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Docter_page(
                                _categories[index].title.toString())));
                  },
                  child: Container(
                      width: 100,
                      child: CategoryCell(category: _categories[index])),
                );
              }
              //  ,
              ),
        ),
      ],
    );
  }

  //Top Rated

  /// Top Rated Doctors Section
  _trDoctorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Rated ',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 32,
        ),

        StreamBuilder<QuerySnapshot>(
            stream: firebase.orderBy('rating', descending: true).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return new Text("Loding..");
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot doc = snapshot.data!.docs[index];
                    return TrdCell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                uid: doc['uid'],
                                name: doc['name'],
                                //last_name: doc['last name'],
                                email: doc['email'],
                                address: doc['address'],
                                experience: doc['experience'],
                                specialist: doc['specialist'],
                                profileImage: doc['profileImage'],
                                description: doc['description'],
                                phone: doc['phone'],
                                doctor: null,
                              ),
                            ));
                      },
                      name: doc["name"].toString(),
                      email: doc["email"].toString(),
                      rating: doc["rating"],
                      specialist: doc["specialist"].toString(),
                      profileImage: doc['profileImage'],
                    );
                  },
                );
              }
            }), // doctor

        SizedBox(
          height: 0,
        ),
      ],
    );
  }

  getTrdCell(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return snapshot.data!.docs
        .map((doc) => TrdCell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        uid: doc['uid'],
                        name: doc['name'],
                        email: doc['email'],
                        address: doc['address'],
                        experience: doc['experience'],
                        specialist: doc['specialist'],
                        profileImage: doc['profileImage'],
                        description: doc['description'],
                        phone: doc['phone'],
                        doctor: _doctorName,
                      ),
                    ));
              },
              //_onCellTap(doc),
              name: doc["name"].toString(),
              email: doc["email"].toString(),
              profileImage: doc['profileImage'],
              rating: doc['rating'].toString(),
              specialist: doc["specialist"].toString(),
            ))
        .toList();
  }

  /// **********************************************
  /// DUMMY DATA
  /// **********************************************

  /// Get Highlighted Doctors List
  List<Doctor> _getHDoctors() {
    List<Doctor> hDoctors = <Doctor>[];

    hDoctors.add(Doctor(
      firstName: 'Elisa',
      lastName: 'Alexander',
      image: 'albert.png',
      type: 'Kidney',
      rating: 4.5,
    ));
    hDoctors.add(Doctor(
      firstName: 'Elisa',
      lastName: 'Rose',
      image: 'albert.png',
      type: 'Kidney',
      rating: 4.5,
    ));

    return hDoctors;
  }

  /// Get Categories
  List<Category> _getCategories() {
    List<Category> categories = <Category>[];
    categories.add(Category(
      title: 'Neuro',
      icon: "assets/svg/brainstorm.png",
    ));
    categories.add(Category(
      icon: "assets/svg/ear.png",
      title: 'Ear',
    ));
    categories.add(Category(
      icon: "assets/svg/eye.png",
      title: 'Eyes',
    ));
    categories.add(Category(
      icon: "assets/svg/hair.png",
      title: 'Hair',
    ));
    return categories;
  }

  /// Get Top Rated Doctors List
  List<Doctor> _getTRDoctors() {
    final CollectionReference firebase =
        FirebaseFirestore.instance.collection('doctor');

    List<Doctor> trDoctors = <Doctor>[];

    trDoctors.add(Doctor(
      firstName: 'Mathew',
      lastName: 'Chambers',
      image: 'mathew.png',
      type: 'Bone',
      rating: 4.3,
    ));
    trDoctors.add(Doctor(
        firstName: 'Cherly',
        lastName: 'Bishop',
        image: 'cherly.png',
        type: 'Kidney',
        rating: 4.7));
    trDoctors.add(Doctor(
        firstName: 'Albert',
        lastName: 'Alexander',
        image: 'albert.png',
        type: 'Kidney',
        rating: 4.3));
    trDoctors.add(Doctor(
      firstName: 'Elisa',
      lastName: 'Rose',
      image: 'albert.png',
      type: 'Kidney',
      rating: 4.5,
    ));
    return trDoctors;
  }
}

void initFeatureBuilder() {
  print("Feature Builder Calling");
  FutureBuilder(
    future: FirebaseFirestore.instance
        .collection('pending')
        .where("pid", isEqualTo: loggedInUser.uid)
        .where('visited', isEqualTo: true)
        .where('rating', isEqualTo: true)
        .get()
        .then((myDocuments) {
      myDoc = myDocuments.docs.length.toString();
      print("${"lenght ub = " + myDocuments.docs.length.toString()}");

      return myDocuments;
    }),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text("Something went wrong");
      }
      print("Snapshot: " + snapshot.toString());
      snapshot.data?.docs.forEach((doc) {
        // uid = doc.id.toString();
        print("Pending id " + doc.id);
        print("Pending id " + doc['did']);
        print("Pending id " + doc['rating'].toString());
        print("Pending id " + doc['visited'].toString());
        print("Pending id " + doc['doctor_name']);
      });
      // dialog(context);
      return SizedBox();
      /*Alert(context: HomePage);*/
    },
  );
}

dialog(BuildContext context) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                        'Doctor Rating',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // buildRating(),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor),
                        child: Text(
                          'Okay',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                    // Icon(Icons.assistant_photo, color: Colors.white, size: 50,),
                  )),
            ],
          ),
        ));
