import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UnSeenNotificationPage extends StatefulWidget {
  const UnSeenNotificationPage({Key? key}) : super(key: key);

  @override
  _UnSeenNotificationPageState createState() => _UnSeenNotificationPageState();
}

class _UnSeenNotificationPageState extends State<UnSeenNotificationPage> {
  List<dynamic> allUnseenNotifications = [];

  Future getAllUnseenNotification() async {
    final urlUnseenNotification = Uri.parse(
        "https://ultdev.org/flutterBlogBack/selectUnSeenNotification.php");
    var response = await http.get(urlUnseenNotification);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        allUnseenNotifications = data;
      });
    }
    print(allUnseenNotifications);
  }

  Future updateSeenNotification(String id) async {
    final urlSeenNotification =
        Uri.parse("https://ultdev.org/flutterBlogBack/updateNotification.php");
    var response = await http.post(urlSeenNotification, body: {"id": id});
    if (response.statusCode == 200) {
      print("ok");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllUnseenNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
            itemCount: allUnseenNotifications.length,
            itemBuilder: (context, index) {
              var list = allUnseenNotifications[index];
              return Card(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: ListTile(
                  title: Text(list['comment']),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_red_eye_outlined,color: Colors.white,),
                    onPressed: () {
                      updateSeenNotification(list["id"])
                          .whenComplete(() => getAllUnseenNotification());
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }
}
