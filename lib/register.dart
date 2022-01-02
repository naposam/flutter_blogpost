import 'dart:convert';
import 'package:blog_post/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController fullName= TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordc = TextEditingController();
  final _key = GlobalKey<FormState>();

  Future register()async{

   var  ADD_URL ="https://ultdev.org/flutterBlogBack/newRegister.php";
    if(_key.currentState!.validate()){
      final response = await http.post(Uri.parse(ADD_URL),body: {
        "fullname": fullName.text,
        "username": username.text,
        "password": password.text,

      });
     if(response.body.isNotEmpty) {
       var data = jsonDecode(response.body);

      if(data == "Error"){
        FlutterToastr.show("The Username Has Been Taken ",
            context,
            duration: FlutterToastr.lengthLong,
            position:  FlutterToastr.bottom,
          backgroundColor: Colors.red,
        );
      }else{
        FlutterToastr.show("Registration Successful ",
          context,
          duration: FlutterToastr.lengthLong,
          position:  FlutterToastr.bottom,
          backgroundColor: Colors.green,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));

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
                 CircleAvatar(

                   child: Icon(Icons.add_circle_outlined,size: 80,),
                   backgroundColor: Colors.white,
                   maxRadius: 40,



                 ),
                  SizedBox(height: 10,),
                  Card(
                    child: TextFormField(
                      controller: fullName,
                      validator: (e)=>e!.isEmpty ? "Enter your FullName": null,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 15),
                          child: Icon(Icons.person,size: 30,),
                        ),
                        labelText: "FullName",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
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
                  Card(
                    child: TextFormField(
                      controller: passwordc,
                      validator: (e)=>e!.isEmpty ? "Confirm password": null,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 15),
                          child: Icon(Icons.lock,size: 30,),
                        ),
                        labelText: "Confirm Password",
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                  ),

                  ElevatedButton(
                    onPressed:register,

                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 19,color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have Account ?",style: TextStyle(color: Colors.white),),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              onPrimary: Colors.lightBlueAccent,
                              shadowColor: Colors.transparent
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                          },
                          child: Text("Login"))
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
