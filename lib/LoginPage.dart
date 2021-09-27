import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loginPage/searchScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {



  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController=TextEditingController();

  logmein()async
  {    print("sending");
     String url = 'http://madhavapi.herokuapp.com/login';
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"email":"${emailController.text}" , "password":"${passwordController.text}" }';
      print(json); // make POST request
      Response response = await post(url,headers: headers, body: json); // check the status code for the result
     
      if(response.body=="success"){
        var prefs = await SharedPreferences.getInstance();
        prefs.setString("logged", "true");
 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
      }
      
      
       
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Text("SIGN IN",style: TextStyle(color: Colors.black,fontSize: 50),),
              SizedBox(height: 20,),
              Container(
                width:MediaQuery.of(context).size.width*0.8,
                // pading: EdgeInsets.only(lef),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline,color: Colors.grey,),
                    hintText: "Username",
                    focusColor: Colors.grey       ,
                    hoverColor: Colors.grey             
                  ),
                ),
              ),
              SizedBox(height: 10,),

              Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key,color: Colors.grey,),
                    hintText: "Password",
                    focusColor: Colors.grey       ,
                    hoverColor: Colors.grey             
                  ),
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap:(){
                logmein();
                },
                              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left:00,right: 00,top:10,bottom: 10),
                  width: MediaQuery.of(context).size.width*0.8,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    // boxShadow: 
                  ),
                  child: Text("Sign in",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                ),
              )
          ],
        ),
      ),
    );
  }
}