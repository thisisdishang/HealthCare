import 'package:flutter/material.dart';
import 'package:internship/Model/list.dart';
import 'package:internship/app_styles.dart';
import 'package:internship/category.dart';
import 'package:internship/productdetailpage.dart';
import 'package:internship/size_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> _categories = <Category>[];

  List<Category> _getCategories() {
    List<Category> categories = <Category>[];
    categories.add(Category(
      icon: "assets/resort.png",
      title: 'Hotel',
    ));
    categories.add(Category(
      icon: "assets/airplane-mode.png",
      title: 'Flight',
    ));
    categories.add(Category(
      icon: "assets/place.png",
      title: 'Place',
    ));
    categories.add(Category(
      icon: "assets/food.png",
      title: 'Food',
    ));
    return categories;
  }

  int current = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categories = _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPadding20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: SizeConfig.blockSizeVertical! * 0.5,
                        ),
                        Text(
                          "Where you \nwanna go?",
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 40,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical! * 0.5,
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0,
                            offset: const Offset(0, 18),
                            blurRadius: 18,
                            color: Colors.black12,
                          )
                        ],
                        border: Border.all(color: Colors.black12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              SizedBox(
                width: double.infinity,
                height: 115,
                child: ListView.builder(
                  itemCount: _categories.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          current = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: index == 0 ? kPadding20 : 12,
                          right:
                              index == _categories.length - 1 ? kPadding20 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: kPadding16,
                        ),
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 5,
                              offset: const Offset(0, 18),
                              blurRadius: 18,
                              color: current == index
                                  ? kBlue.withOpacity(0.1)
                                  : kBlue.withOpacity(0),
                            )
                          ],
                          gradient: current == index
                              ? kLinearGradientBlue
                              : kLinearGradientWhite,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                            child: Container(
                                width: 55,
                                child: CategoryCell(
                                    category: _categories[index]))),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kPadding20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Hotels",
                      style: TextStyle(
                          color: kBlack,
                          fontSize: 27,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(color: Colors.amber, fontSize: 15),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              SizedBox(
                height: 272,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (() => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductDetailPage(),
                              ),
                            )),
                        child: Container(
                          height: 190,
                          width: 160,
                          margin: EdgeInsets.only(
                            left: kPadding20,
                            right: index == 5 - 1 ? kPadding20 : 0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kBorderRadius20),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 0,
                                offset: const Offset(0, 18),
                                blurRadius: 18,
                                color: kBlack.withOpacity(0.1),
                              ),
                            ],
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://images.pexels.com/photos/70441/pexels-photo-70441.jpeg'),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 136,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft:
                                          Radius.circular(kBorderRadius20),
                                      bottomRight:
                                          Radius.circular(kBorderRadius20),
                                    ),
                                    gradient: kLinearGradientBlack,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: kPadding16,
                                      vertical: kPadding20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        kBorderRadius20)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: kPadding4,
                                                horizontal: kPadding8),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Satorini",
                                            style: kRalewayMedium.copyWith(
                                                color: kWhite, fontSize: 16),
                                          ),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    0.6,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                              Text(
                                                "Greece",
                                                style: kRalewayMedium.copyWith(
                                                    color: kWhite,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    0.6,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "\$" + "488/night",
                                                style: TextStyle(
                                                    color: kWhite,
                                                    fontSize: 14),
                                              ),
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 22,
                                              ),
                                              Text(
                                                "4.9",
                                                style: TextStyle(
                                                    color: kWhite,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kPadding20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hot Deals",
                      style: TextStyle(
                          color: kBlack,
                          fontSize: 27,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kPadding20),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductDetailPage(),
                            ),
                          )),
                      child: Center(
                        child: Container(
                          height: 190,
                          margin: const EdgeInsets.only(
                            bottom: kPadding24,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 190,
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius10),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 0,
                                        offset: const Offset(0, 18),
                                        blurRadius: 18,
                                        color: kBlack.withOpacity(0.1)),
                                  ],
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'https://assets.hyatt.com/content/dam/hyatt/hyattdam/images/2022/04/12/1329/MUMGH-P0765-Inner-Courtyard-Hotel-Exterior-Evening.jpg/MUMGH-P0765-Inner-Courtyard-Hotel-Exterior-Evening.16x9.jpg'),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 136,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(
                                                kBorderRadius20),
                                            bottomRight: Radius.circular(
                                                kBorderRadius20),
                                          ),
                                          gradient: kLinearGradientBlack,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: kPadding16,
                                            vertical: kPadding20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              kBorderRadius20)),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: kPadding4,
                                                      horizontal: kPadding8),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "BaLi Motel Vung Tau",
                                                      style: kRalewayMedium
                                                          .copyWith(
                                                              color: kWhite,
                                                              fontSize: 16),
                                                    ),
                                                    SizedBox(
                                                      width: 120,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 22,
                                                    ),
                                                    Text(
                                                      "4.9",
                                                      style: TextStyle(
                                                          color: kWhite,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color: Colors.white,
                                                          size: 22,
                                                        ),
                                                        Text(
                                                          "Indonesia",
                                                          style: kRalewayMedium
                                                              .copyWith(
                                                                  color: kWhite,
                                                                  fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 170.0,
                                                    ),
                                                    Text(
                                                      "\$" + "580/night",
                                                      style: TextStyle(
                                                          color: kWhite,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0, left: 10.0),
                                      child: Container(
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              kBorderRadius20,
                                            ),
                                            color: Colors.redAccent),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kPadding8,
                                          vertical: kPadding4,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "25% OFF",
                                              style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
