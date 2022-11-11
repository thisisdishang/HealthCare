import 'package:flutter/material.dart';
import 'package:hospital_appointment/componets/text_field_container.dart';

import '../constants.dart';

class RoundedPasswordField extends StatefulWidget {
  Function onChanged;
   RoundedPasswordField({

    required this.onChanged,
  }) ;

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  @override
  Widget build(BuildContext context) {
    bool hidePassword = true;
    return TextFieldContainer(
      child: TextField(
        onChanged: (value) {
          print(value);
        },
        obscureText: hidePassword,//show/hide password
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: hidePassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
          ),

        ),
      ),
    );
  }
}
