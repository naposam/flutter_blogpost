import 'dart:convert';

import 'package:blog_post/admin/dashboard.dart';
import 'package:blog_post/home.dart';
import 'package:blog_post/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toastr/flutter_toastr.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading= false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final _key = GlobalKey<FormState>();

 Future <dynamic>login()async{
   Map mapData  ={
     "username": username.text,
     "password": password.text,
   };

    final  LOGIN_URL ="https://ultdev.org/flutterBlogBack/newLogin.php";
    if(_key.currentState!.validate()){
      final response = await http.post(Uri.parse(LOGIN_URL),body: mapData);
      if(response.statusCode==200) {

        var data = jsonDecode(response.body);
        print(data);
        if(data== "Error"){
          FlutterToastr.show("Invalid Username or Password",
            context,
            duration: FlutterToastr.lengthLong,
            position:  FlutterToastr.bottom,
            backgroundColor: Colors.red,
          );

        }else{
          if(data==null){
            print("no data");
          }
          else if(data[0]['status']=="Admin"){
            FlutterToastr.show("Login Successful",
              context,
              duration: FlutterToastr.lengthLong,
              position: FlutterToastr.bottom,
              backgroundColor: Colors.green,

            );
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=>Dashboard(
                  userName: data[0]["username"],
                  fullName: data[0]["fullname"],


                )));
          }else {
            FlutterToastr.show("Login Successful",
              context,
              duration: FlutterToastr.lengthLong,
              position: FlutterToastr.bottom,
              backgroundColor: Colors.green,
            );

            Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => Home(
                  userName: data[0]["username"],
                  fullName: data[0]["fullname"],

                )));
          }
        }
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(44, 44, 44, 0.6),
      body: Center(

        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  Image(image: AssetImage("images/profile.png",),width: 200,height: 200,),
                  Card(
                    child: TextFormField(
                      controller: username,
                      validator: (e)=>e!.isEmpty ? "Enter your username": null,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 15),
                          child: Icon(Icons.person,size: 30,),
                        ),
                        labelText: "Username",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: password,
                      validator: (e)=>e!.isEmpty ? "Enter your password": null,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 15),
                          child: Icon(Icons.lock,size: 30,),
                        ),
                        labelText: "Password",
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      onPrimary: Colors.lightBlueAccent,
                    ),
                      onPressed: (){},
                      child: Text("Forgot Password",
                        style: TextStyle(color: Colors.lightBlue,fontWeight: FontWeight.bold),
                      ),
                  ),
                  ElevatedButton(
                      onPressed: login,
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 19,color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have Account ?",style: TextStyle(color: Colors.white),),
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         primary: Colors.transparent,
                         onPrimary: Colors.lightBlueAccent,
                         shadowColor: Colors.transparent
                       ),
                         onPressed: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                         },
                         child: Text("Sign Up"))
                    ],
                  )


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
