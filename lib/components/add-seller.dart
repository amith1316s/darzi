import 'dart:collection';

import 'package:app_frontend/components/alertBox.dart';
import 'package:app_frontend/services/userService.dart';
import 'package:app_frontend/services/validateService.dart';
import 'package:flutter/material.dart';

class AddSeller extends StatefulWidget {
  @override
  _AddSellerState createState() => _AddSellerState();
}

class _AddSellerState extends State<AddSeller> {
  bool _autoValidate = false;
  double borderWidth = 1.0;
  final _formKey = GlobalKey<FormState>();
  HashMap userValues = new HashMap<String, String>();

  ValidateService validateService = ValidateService();
  UserService userService = UserService();

  setBorder(double width, Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(width: width, color: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            'Add Tayler',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                fontFamily: 'NovaSquare'),
          ),
          backgroundColor: Colors.white,
          elevation: 1.0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50.0),
                    TextFormField(
                      decoration: customFormField('Tayler Name'),
                      validator: (value) => validateService.isEmptyField(value),
                      onChanged: (String val) {
                        userValues['name'] = val;
                      },
                      style: TextStyle(fontSize: 17.0),
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      decoration: customFormField('Phone number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          validateService.validatePhoneNumber(value),
                      onChanged: (String val) {
                        userValues['mobileNumber'] = val;
                      },
                      style: TextStyle(fontSize: 17.0),
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      decoration: customFormField('E-mail Address'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          validateService.validateEmail(value),
                      onChanged: (String val) {
                        userValues['email'] = val;
                      },
                      style: TextStyle(fontSize: 17.0),
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      obscureText: true,
                      decoration: customFormField('Password'),
                      validator: (value) =>
                          validateService.validatePassword(value),
                      onChanged: (String val) {
                        userValues['password'] = val;
                      },
                      style: TextStyle(fontSize: 17.0),
                    ),
                    SizedBox(height: 50.0),
                    ButtonTheme(
                      minWidth: 250.0,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36),
                            side: BorderSide(color: Colors.black)),
                        padding: EdgeInsets.only(left: 30, right: 30),
                        color: Colors.blue[800],
                        textColor: Colors.white,
                        child: Text(
                          'Add seller',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (this._formKey.currentState.validate()) {
                            await userService.addSeller(userValues);
                            int statusCode = userService.statusCode;
                            if (statusCode == 400) {
                              AlertBox alertBox = AlertBox(userService.msg);
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alertBox.build(context);
                                  });
                            } else {
                              Navigator.pop(context);
                            }
                          } else {
                            setState(() {
                              _autoValidate = true;
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ))
        ])));
  }

  // signup() async {
  //   if (this._formKey.currentState.validate()) {
  //     _formKey.currentState.save();
  //     await userService.addSeller(userValues);
  //     int statusCode = userService.statusCode;
  //     if (statusCode == 400) {
  //       AlertBox alertBox = AlertBox(userService.msg);
  //       return showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return alertBox.build(context);
  //           });
  //     } else {
  //       Navigator.pushReplacementNamed(context, '/');
  //     }
  //   } else {
  //     setState(() {
  //       _autoValidate = true;
  //     });
  //   }
  // }

  InputDecoration customFormField(String hintText) {
    return InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(20.0),
        errorBorder: this.setBorder(1.0, Colors.red),
        focusedErrorBorder: this.setBorder(1.0, Colors.red),
        focusedBorder: this.setBorder(2.0, Colors.blue),
        enabledBorder: this.setBorder(1.0, Colors.black));
  }
}
