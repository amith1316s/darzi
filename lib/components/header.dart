import 'package:app_frontend/components/loader.dart';
import 'package:app_frontend/components/orders/orderHistory.dart';

import 'package:flutter/material.dart';

capitalizeHeading(String text){
  if(text == null){
    return text = "";
  }
  else{
    text = "${text[0].toUpperCase()}${text.substring(1)}";
    return text;
  }
}

Widget header(String headerText,GlobalKey<ScaffoldState> scaffoldKey,bool  showIcon, BuildContext context){
  final GlobalKey<State> keyLoader = new GlobalKey<State>();

  return AppBar(
    centerTitle: true,
    title: Text(
      capitalizeHeading(headerText),
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 22.0,
        fontFamily: 'NovaSquare'
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 1.0,
    automaticallyImplyLeading: false,
    leading: IconButton(
      icon: Icon(
        Icons.menu,
        size: 35.0,
        color: Colors.black
      ),
      onPressed: (){
        if(scaffoldKey.currentState.isDrawerOpen == false){
          scaffoldKey.currentState.openDrawer();
        }
        else{
          scaffoldKey.currentState.openEndDrawer();
        }
      },
    ),
  );
}