import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_frontend/pages/signup.dart';
import 'package:app_frontend/pages/login.dart';
import 'package:app_frontend/pages/start.dart';
import 'package:app_frontend/pages/home.dart';
import 'package:app_frontend/pages/profile/editProfile.dart';
import 'package:app_frontend/pages/profile/setting.dart';
import 'package:app_frontend/pages/profile/contactUs.dart';
import 'package:app_frontend/components/orders/orderHistory.dart';
import 'package:app_frontend/pages/onBoardingScreen/onboardingScreen.dart';

bool firstTime;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  firstTime = (prefs.getBool('initScreen') ?? false);
  if(!firstTime){
    prefs.setBool('initScreen', true);
  }
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: firstTime ? '/': '/onBoarding',
      initialRoute: '/',
      routes: {
        '/': (context) => Start(),
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/home': (context) => Home(),
        '/profile/settings': (context) => ProfileSetting(),
        '/profile/edit': (context) => EditProfile(),
        '/profile/contactUs': (context) => ContactUs(),
        '/placedOrder': (context) => OrderHistory(),
        "/onBoarding": (context) => OnBoardingScreen()
      },
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.white
        )
      ),
    );
  }
}
