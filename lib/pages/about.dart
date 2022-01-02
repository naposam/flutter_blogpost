import 'package:flutter/material.dart';
class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),

      ),
      body: Container(
        child: Center(child: Text("About Us",style: TextStyle(fontSize: 20),)),
      ),
    );
  }
}
