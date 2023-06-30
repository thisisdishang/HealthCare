import 'package:flutter/material.dart';
import 'package:internship/Model/list.dart';
import 'package:internship/app_styles.dart';
import 'package:internship/category.dart';
import 'package:internship/size_config.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int current = 0;

  List<Category> _categories = <Category>[];

  List<Category> _getCategories() {
    List<Category> categories = <Category>[];
    categories.add(Category(
      icon: "assets/bed.png",
      title: '2 Bed',
    ));
    categories.add(Category(
      icon: "assets/dinner.png",
      title: 'Dinner',
    ));
    categories.add(Category(
      icon: "assets/tub.png",
      title: 'Hot Tub',
    ));
    categories.add(Category(
      icon: "assets/ac.png",
      title: '1 AC',
    ));
    return categories;
  }

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: kPadding8),
        height: 60,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: kPadding20),
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  debugPrint("Buy Now Tapped");
                },
                child: Container(
                  width: 335,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    gradient: kLinearGradientBlue,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: kPadding24),
                  child: Center(
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                          color: kWhite,
                          fontSize: SizeConfig.blockSizeHorizontal! * 5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.40,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://assets.hyatt.com/content/dam/hyatt/hyattdam/images/2022/04/12/1329/MUMGH-P0765-Inner-Courtyard-Hotel-Exterior-Evening.jpg/MUMGH-P0765-Inner-Courtyard-Hotel-Exterior-Evening.16x9.jpg'))),
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 235,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.share_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.thumb_up_alt_outlined,
                                color: Colors.black,
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
            Padding(
              padding: const EdgeInsets.only(top: 250.0, left: 150),
              child: Container(
                height: 20,
                width: 85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      kBorderRadius20,
                    ),
                    color: kBlack.withOpacity(0.6)),
                child: Row(
                  children: [
                    Text(
                      "  124 photos",
                      style: TextStyle(
                          fontStyle: FontStyle.normal, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 280.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kPadding16, vertical: kPadding8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 0.8,
                      ),
                      Text(
                        "BaLi Motel\nVung Tu",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 0.8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.black,
                            size: 22,
                          ),
                          Text(
                            "Indonesia",
                            style: kRalewayMedium.copyWith(
                                color: kBlack, fontSize: 12),
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 0.8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 22,
                          ),
                          Text(
                            "4.9 ",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          Text(
                            "(6.8K Review)",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          SizedBox(
                            width: 105.0,
                          ),
                          Text(
                            "\$" + "488/night",
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(color: Colors.grey),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Set in Vung Tau, 100 metres from Front Beach,Bali Motel Vung Tau offers accommodationwith a garden, private parking and a share...",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Read More",
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.amber,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 0.45,
                      ),
                      Text(
                        "What we offer",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(
                        height: 15,
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
                                  left: index == 0 ? 5 : 12,
                                  right: index == _categories.length - 1
                                      ? kPadding20
                                      : 0,
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
                      SizedBox(height: 15),
                      Text(
                        "Hosted By",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
