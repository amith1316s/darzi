import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:app_frontend/services/userService.dart';

class Start extends StatelessWidget{
  final UserService _userService = new UserService();

  validateToken(context) async{
    final storage = new FlutterSecureStorage();
    String value = await storage.read(key: 'token');
    if(value != null){
      String decodedToken = _userService.validateToken(value);
      if(decodedToken != null){
        Navigator.of(context).pushReplacementNamed('/home');
      }
      else{
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
    else{
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 40.0),
                Image.asset('assets/logo.png', height: 180.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                  child: Text(
                      'Welcome to Darzi',
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NovaSquare',
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(48.0, 35.0, 48.0, 0.0),
                  child: Text(
                    'Your tayler partner',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19.0,
                        letterSpacing: 1.0
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
                  child: ButtonTheme(
                    minWidth: 180.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () {
                        validateToken(context);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: ButtonTheme(
                    minWidth: 180.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                        side: BorderSide(color: Colors.blueAccent)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
