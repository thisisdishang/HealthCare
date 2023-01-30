import 'package:flutter/material.dart';
import 'package:hospital_appointment/constants.dart';
import 'package:hospital_appointment/models/category.dart';

import '../he_color.dart';

class CategoryCell extends StatelessWidget {
  final Category? category;

  const CategoryCell({this.category});

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      //width: size.width*0.8,
      height: 100,
      //  margin: EdgeInsets.only(right: 10),
      clipBehavior: Clip.hardEdge,
      //   padding: EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        color: kPrimarydark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Image.asset(
                category?.icon,
                height: size.height * 0.09,
                width: size.width * 0.09,
              )),
              Center(
                child: Text(
                  category?.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
