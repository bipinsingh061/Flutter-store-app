
import 'package:flutter/material.dart';
import 'package:loginPage/LoginPage.dart';
import 'package:loginPage/searchScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

     _SplashScreenState(){
            Future.delayed(Duration(seconds: 1),(){
              checknow();
            });
     }
  
    checknow()async{
      var prefs = await SharedPreferences.getInstance();
      String k = prefs.getString("logged")??"false";
      if(k=="true"){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      }
    }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Icon(Icons.personal_video)
    );
  }
}