import 'package:flutter/material.dart';
class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),

      ),
      body: Container(
        child: Center(child: Text("Contact",style: TextStyle(fontSize: 20),)),
      ),
    );
  }
}
