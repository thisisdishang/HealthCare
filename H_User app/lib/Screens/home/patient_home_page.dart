import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
        title: Text("Mediplus+"),

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
                          style:  TextStyle(
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
                    itemCount: 5,
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
                                  phone: doc['phone'], doctor: _doctorName,
                                ),
                              ));
                        },
                        name: doc["name"].toString(),
                        email: doc["email"].toString(),
                        specialist: doc["specialist"].toString(),
                        profileImage: doc['profileImage'],
                      );
                      /*Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name:     ${documentSnapshot['name']}"),
                              Text("Email:     ${documentSnapshot['email']}"),
                              Text("address: ${documentSnapshot['address']}"),
                              Text("phone:    ${documentSnapshot['phone']}"),
                              Text("gender:   ${documentSnapshot['gender']}"),
                            /*  Row(
                                children: [
                                  // Press this button to edit a single product
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () =>
                                          _createOrUpdate(documentSnapshot)),
                                  // This icon button is used to delete a single product
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteProduct(documentSnapshot.id);
                                      }),
                                ],
                              ),*/
                            ],
                          ),
                        ));*/
                    },
                  ); /*new ListView(
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    children: getTrdCell(snapshot, context));*/
                }
              })
          /*StreamBuilder<QuerySnapshot>(
         //   stream: firebase.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return new Text("There is no expense");
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot doc =
                    snapshot.data!.docs[index];
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
                              ),
                            ));
                      },
                      name: doc["name"].toString(),
                      email: doc["email"].toString(),
                      specialist: doc["specialist"].toString(),
                    );
                    /*Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name:     ${documentSnapshot['name']}"),
                              Text("Email:     ${documentSnapshot['email']}"),
                              Text("address: ${documentSnapshot['address']}"),
                              Text("phone:    ${documentSnapshot['phone']}"),
                              Text("gender:   ${documentSnapshot['gender']}"),
                            /*  Row(
                                children: [
                                  // Press this button to edit a single product
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () =>
                                          _createOrUpdate(documentSnapshot)),
                                  // This icon button is used to delete a single product
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteProduct(documentSnapshot.id);
                                      }),
                                ],
                              ),*/
                            ],
                          ),
                        ));*/
                  },
                );
                /* ListView(
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    children: getExpenseItems(snapshot, context));*/
              }
            }),*/
          ),
      /*ListView.separated(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24),
        itemCount: _hDoctors.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(indent: 16),
        itemBuilder: (BuildContext context, int index) => HDCell(
          doctor: _hDoctors[index],
          onTap: () => _onCellTap(_hDoctors[index]),
        ),
      ),*/
      //),
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
                )
      /*HDCell(
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
                          ),
                        ));
                  },
                  name: doc["name"].toString(),
                  email: doc["email"].toString(),
                  specialist: doc["specialist"].toString(),
                )*/
            /*Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: ListTile(
      title: Text(doc["name"]),
      subtitle: Text(doc.id),
      onTap: () {},
    ),
  )*/
            )
        .toList();
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************

  /*AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: HexColor('#150047')),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 25,
        ),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            size: 25,
          ),
          onPressed: () {},
        ),
      ],
    );
  }*/

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
              style:  TextStyle(
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

//box...


//         Container(
//           height: 150,
//           padding: EdgeInsets.only(top: 14),
//           child: ListView.builder(
//             physics: ClampingScrollPhysics(),
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 20.0),
//             itemCount: cards.length,
//             itemBuilder: (context, index) {
//               //print("images path: ${cards[index].cardImage.toString()}");
//               return Container(
//                 margin: EdgeInsets.only(right: 14),
//                 height: 150,
//                 width: 140,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Color(cards[index].cardBackground),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey,
//                         blurRadius: 4.0,
//                         spreadRadius: 0.0,
//                         offset: Offset(3, 3),
//                       ),
//                     ]
//                   // image: DecorationImage(
//                   //   image: AssetImage(cards[index].cardImage),
//                   //   fit: BoxFit.fill,
//                   // ),
//                 ),
//                 // ignore: deprecated_member_use
//                 child: FlatButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => Docter_page(
//                               _categories[index].title.toString
//                           )),
//                     );
//                   },
//                   shape: new RoundedRectangleBorder(
//                       borderRadius: new BorderRadius.circular(20)),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         height: 16,
//                       ),
//                       Container(
//                         child: CircleAvatar(
//                             backgroundColor: Colors.white,
//                             radius: 29,
//                             child: Icon(
//                               cards[index].cardIcon,
//                               size: 26,
//                               color:
//                               Color(cards[index].cardBackground),
//                             )),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         alignment: Alignment.bottomCenter,
//                         child: Text(
//                           cards[index].doctor,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ]
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
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
                    stream: firebase.orderBy('rating' ,descending: true).snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loding..");
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: 5,
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
                            /*Card(
                                margin: const EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Name:     ${documentSnapshot['name']}"),
                                      Text("Email:     ${documentSnapshot['email']}"),
                                      Text("address: ${documentSnapshot['address']}"),
                                      Text("phone:    ${documentSnapshot['phone']}"),
                                      Text("gender:   ${documentSnapshot['gender']}"),
                                    /*  Row(
                                        children: [
                                          // Press this button to edit a single product
                                          IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () =>
                                                  _createOrUpdate(documentSnapshot)),
                                          // This icon button is used to delete a single product
                                          IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                _deleteProduct(documentSnapshot.id);
                                              }),
                                        ],
                                      ),*/
                                    ],
                                  ),
                                ));*/
                          },
                        ); /*new ListView(
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            children: getTrdCell(snapshot, context));*/

                      }

                    }),// doctor
                //*************************************

                SizedBox(
                  height: 0,
                ),
                /* ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: _trDoctors.length,
                  separatorBuilder: (BuildContext context, int index) => Divider(
                    thickness: 16,
                    color: Colors.transparent,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                    doctor: _hDoctors[1],
                                  )),
                        );
                      },
                      child: TrdCell(
                        doctor: _trDoctors[index],
                      ),
                    );
                  },
                ),*/
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
                        phone: doc['phone'], doctor: _doctorName,
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

/*

class EventRepository {

  static Future<List> getEvents() async {

    List events = [];

    if (await _shouldRefreshLocalEvents()) {
      events = await _getEventsFromFirestore();
      _setLastRefreshToNow();
      _persistEventsInDatabase(events);
    } else {
      events = await _getEventsFromDatabase();
    }

    return events;
  }

  static Future<List> _getEventsFromFirestore() async {
    final CollectionReference fir = FirebaseFirestore.instance.collection('docter');
    //CollectionReference ref = fir.instance.collection('events');
   /* QuerySnapshot eventsQuery = await ref
        .where("time", isGreaterThan: new DateTime.now().millisecondsSinceEpoch)
        .where("food", isEqualTo: true)
        .getDocuments();*/

    HashMap<String, DoctorModel> eventsHashMap = new HashMap<String, DoctorModel>();

    fir.get(
        forEach((document) {
          eventsHashMap.putIfAbsent(document['id'], () => new DoctorModel(
              name: document['name'];

          })
    );

    return eventsHashMap.values.toList();
  }

  static Future<List<AustinFeedsMeEvent>> _getEventsFromDatabase() async {
    Database dbClient = await EventsDatabase().db;
    List<Map<String, dynamic>> eventRecords = await dbClient.query(EVENT_TABLE_NAME);
    return eventRecords.map((record) => AustinFeedsMeEvent.fromMap(record)).toList();
  }

  static String _getEventPhotoUrl(Map<dynamic, dynamic> data) {
    String defaultImage = "";
    if (data == null) {
      return defaultImage;
    }

    Map<dynamic, dynamic> groupPhotoObject = data['groupPhoto'];
    if (groupPhotoObject == null) {
      return defaultImage;
    }

    String photoUrl = groupPhotoObject['photoUrl'];
    return photoUrl;
  }

  static LatLng _getLatLng(DocumentSnapshot data) {
    LatLng defaultLocation = new LatLng(0.0, 0.0);
    if (data == null) {
      return defaultLocation;
    }

    Map<dynamic, dynamic> venueObject = data['venue'];
    if (venueObject == null) {
      return defaultLocation;
    }

    return new LatLng(
        double.parse(venueObject['lat']), double.parse(venueObject['lon']));
  }

  static Future<bool> _shouldRefreshLocalEvents() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    int lastFetchTimeStamp = prefs.getInt(KEY_LAST_FETCH);

    if (lastFetchTimeStamp == null) {
      print("last timestamp is null");
      return true;
    }

    return(new DateTime.now().millisecondsSinceEpoch - lastFetchTimeStamp) > (REFRESH_THRESHOLD);
  }

  static void _setLastRefreshToNow() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.setInt(KEY_LAST_FETCH, new DateTime.now().millisecondsSinceEpoch);
  }

  static void _persistEventsInDatabase(List<AustinFeedsMeEvent> events) async {
    Database dbClient = await EventsDatabase().db;

    dbClient.delete(EVENT_TABLE_NAME);

    events.forEach((event) async {
      int eventId = await dbClient.insert(EVENT_TABLE_NAME, event.toMap());
      print(eventId.toString());
    });
  }

}*/

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
//
// class Alert extends StatefulWidget {
//   var context;
//
//   Alert({this.context});
//
//   @override
//   State<Alert> createState() => _AlertState();
// }
//
// class _AlertState extends State<Alert> {
//   var rating;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Text("Pratik"),
//     );
//     // return Dialog(
//     //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
//     //     child: Stack(
//     //       overflow: Overflow.visible,
//     //       alignment: Alignment.topCenter,
//     //       children: [
//     //
//     //         Container(
//     //           height: 230,
//     //           child: Padding(
//     //             padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
//     //             child: Column(
//     //               children: [
//     //                 Text(
//     //                   'Dr. ',
//     //                   style:
//     //                   TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//     //                 ),
//     //                 SizedBox(
//     //                   height: 5,
//     //                 ),
//     //                 Text(
//     //                   'Pending till doctor confirm this appointment request.',
//     //                   style: TextStyle(fontSize: 20),
//     //                   textAlign: TextAlign.center,
//     //                 ),
//     //                 SizedBox(
//     //                   height: 20,
//     //                 ),
//     //                 RaisedButton(
//     //                   onPressed: () {
//     //                     // Navigator.of(context).pop();
//     //                     Navigator.pushAndRemoveUntil<dynamic>(
//     //                         context,
//     //                         MaterialPageRoute<dynamic>(
//     //                             builder: (BuildContext context) => HomePage()),
//     //                             (route) => false);
//     //
//     //                   },
//     //                   color: kPrimaryColor,
//     //                   child: Text(
//     //                     'Okay',
//     //                     style: TextStyle(color: Colors.white),
//     //                   ),
//     //                 )
//     //               ],
//     //             ),
//     //           ),
//     //         ),
//     //         Positioned(
//     //             top: -60,
//     //             child: CircleAvatar(
//     //               backgroundColor: Colors.grey,
//     //               radius: 50,
//     //               child: Image.asset('assets/images/logo.jpg'),
//     //               // Icon(Icons.assistant_photo, color: Colors.white, size: 50,),
//     //             )),
//     //       ],
//     //     ));
//   }
//
//   Widget buildRating() => RatingBar.builder(
//         itemBuilder: (context, _) => Icon(
//           Icons.star,
//           color: Colors.amber,
//         ),
//         initialRating: rating,
//         itemSize: 40,
//         itemPadding: EdgeInsets.symmetric(horizontal: 4),
//         updateOnDrag: true,
//         onRatingUpdate: (velue) {
//           setState(() {
//             rating = velue;
//           });
//         },
//         maxRating: 1,
//       );
// }


