import 'package:flutter/material.dart';

import '../constants.dart';
import '../he_color.dart';

class TrdCell extends StatefulWidget {
  final name;
  final email;
  final specialist;
  final profileImage;
  final rating;
  final Function onTap;

  const TrdCell({
    required this.name,
    required this.email,
    required this.specialist,
    required this.rating,
    required this.onTap,
    required this.profileImage,
  });

  @override
  State<TrdCell> createState() => _TrdCellState();
}

class _TrdCellState extends State<TrdCell> {
  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        // padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 10),
        // width: double.infinity,
        alignment: Alignment.centerLeft,
        // height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration
          (

          color: kPrimarydark1,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              color: HexColor('#404B63').withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSection(),
            SizedBox(
              width: 20,
            ),

            _detailsSection(),
          ],
        ),
      ),
    );
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************

  /// Image Section
  Container _imageSection() {
    return Container(
      height: 90,
      width: 70,
      child: Center(
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(50),
            image: widget.profileImage == false
                ? DecorationImage(
                    image: AssetImage('assets/images/account1.png'),
                    fit: BoxFit.fill)
                : DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.profileImage),
                  ),
          ),
        ),
      ),
    );
  }

  /// Details Section
  Row _detailsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 24,),
            Text(
              'Dr. '+widget.name /* ' ' + widget.email*/,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
              ),
            ),

            SizedBox(
              height: 8,
            ),
            Text(
              widget.specialist + ' Specialist',
              style: TextStyle(
                color: kPrimaryhinttext,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        // SizedBox(
        //   width : 10,
        // ),
        // Container(
        //   width: 50,
        //   child: Row(
        //     children: [
        //       SizedBox(height: 10,),
        //       Text(
        //         widget.rating.toString(),
        //         style: TextStyle(
        //           color: Colors.indigoAccent,
        //           fontSize: 14,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       SizedBox(
        //         width: 4,
        //       ),
        //       Icon(
        //         Icons.star_rounded,
        //         color: Colors.indigoAccent,
        //         size: 25,
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
