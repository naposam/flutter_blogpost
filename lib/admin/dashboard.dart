import 'dart:convert';

import 'package:blog_post/admin/categoryDetails.dart';
import 'package:blog_post/admin/postDetails.dart';
import 'package:blog_post/login.dart';
import 'package:blog_post/pages/unSeenNotificationPage.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';

class Dashboard extends StatefulWidget {
  final fullName;
  final userName;
  final author;

  Dashboard({this.userName = "Guest", this.fullName = "hi", this.author});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isSeen = true;
  var total;
  var totalPost;
  var totalCategory;
  bool toggle = false;
  Map<String,double> dataMap = Map();
  List<Color> colorList =[
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.deepOrangeAccent,
    Colors.pink,
  ];



  Future getTotalUnseenNotification() async {
    final urlUnseenNotification = Uri.parse(
        "https://ultdev.org/flutterBlogBack/selectCommentsNotification.php");
    var response = await http.get(urlUnseenNotification);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        total = data;
      });
    }
    print(total);
  }

  Future getTotalPost() async {
    final urlTotalPost = Uri.parse(
        "https://ultdev.org/flutterBlogBack/totalPost.php");
    var response = await http.get(urlTotalPost);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        totalPost = data;
        //dataMap.addAll({"Post": double.parse('$totalPost')});

      });
    }
    print('total post is $totalPost');
  }
  Future getTotalCategory() async {
    final urlTotalCategory = Uri.parse(
        "https://ultdev.org/flutterBlogBack/totalCategory.php");
    var response = await http.get(urlTotalCategory);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        totalCategory = data;
        //dataMap.addAll({"Category": double.parse('$totalCategory')});

      });
    }
    print('total Category is $totalCategory');
  }
  Future chartDataLoader() async {
    final urlChartData = Uri.parse(
        "https://ultdev.org/flutterBlogBack/chart_data.php");
    var response = await http.get(urlChartData);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
     List chartData= data;
     chartData.forEach((element) { 
       dataMap.addAll({element['category_name']:double.parse(element['comment'])});

     });
    }
    
  }
  //not displayed yet
  Future chartData() async {
    final urlChart = Uri.parse(
        "https://ultdev.org/flutterBlogBack/chart_data.php");
    var response = await http.get(urlChart);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List chartData= data;
      chartData.forEach((element) {
        dataMap.addAll({element['category_name']:double.parse(element['total_like'])});
      });
    }

  }


  @override
  void initState() {
    super.initState();
    getTotalUnseenNotification();
    getTotalPost();
    getTotalCategory();
    chartDataLoader();

  }

  @override
  Widget build(BuildContext context) {
    Widget menuDrawer() {
      return Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.pink),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                ),
                accountName: Text(widget.fullName),
                accountEmail: Text(widget.userName)),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
              },
              leading: Icon(
                Icons.home,
                color: Colors.green,
              ),
              title: Text(
                "Home",
                style: TextStyle(color: Colors.green),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CategoryDetails()));
              },
              leading: Icon(
                Icons.label,
                color: Colors.grey,
              ),
              title: Text(
                "Add Category",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PostDetails()));
              },
              leading: Icon(
                Icons.contacts,
                color: Colors.blue,
              ),
              title: Text(
                "Add Post",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            widget.userName == "Guest"
                ? ListTile(
                    onTap: () {},
                    leading: Icon(
                      Icons.lock,
                      color: Colors.red,
                    ),
                    title: Text(
                      "Login",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    leading: Icon(
                      Icons.lock_open,
                      color: Colors.red,
                    ),
                    title: Text(
                      "LogOut",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        actions: [
          isSeen
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UnSeenNotificationPage())).whenComplete(() => getTotalUnseenNotification());
                    },
                    child: Badge(
                      badgeContent: Text(
                        "$total",
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Icon(Icons.notifications_active),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {},
                    child: Badge(
                      badgeContent: Text(
                        '0',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Icon(Icons.notifications_none),
                    ),
                  ),
                ),
        ],
      ),
      drawer: menuDrawer(),
      body: ListView(
        children: [
          myGridView(),
          Column(

            children: [
              Center(
                child: Container(
                  child:
                  toggle ?
                  PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32.0,
                    chartRadius: MediaQuery.of(context).size.width / 3.2 > 300
                        ? 300
                        : MediaQuery.of(context).size.width / 3.2,
                    colorList: colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.disc,
                      //ringStrokeWidth: 32,
                       //centerText: "Comment",

                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,


                    ),
                    emptyColor: Colors.grey,
                  )
                      :CircularProgressIndicator(),
                  ),

                ),

              ElevatedButton(onPressed: (){togglePieChart();}, child: Text("Show Chart")),
            ],
          )

        ],
      ),
    );
  }

  Widget myGridView() {
    return SingleChildScrollView(
      child: Container(
        height: 250,
        child: GridView.count(
          crossAxisSpacing: 5,
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          padding: EdgeInsets.all(5.0),
          children: [
            Container(
                color: Colors.purple,
                child: Center(
                  child: Text(
                    "Total Post $totalPost",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )),
            Container(
                color: Colors.deepOrangeAccent,
                child: Center(
                  child: Text(
                    "Total Category $totalCategory",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )),
          ],
        ),
      ),
    );
  }
  void togglePieChart(){
    setState((){
      toggle = !toggle;
    });
  }
}
