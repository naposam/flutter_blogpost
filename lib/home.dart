import 'dart:convert';
import 'package:blog_post/login.dart';
import 'package:blog_post/pages/about.dart';
import 'package:blog_post/pages/categoryListItem.dart';
import 'package:blog_post/pages/contact.dart';
import 'package:blog_post/pages/recentPostItem.dart';
import 'package:blog_post/top_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
class Home extends StatefulWidget {

final userName;
final fullName;

Home({this.fullName,this.userName="Guest"});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var curdate = DateFormat("d MMM y").format(DateTime.now());
  bool loading=true;
  List <dynamic> searchList  =[];
  Future showAllPost()async{
    var  FETCH_URL ="https://ultdev.org/flutterBlogBack/fetch.php";
    var response = await http.get(Uri.parse(FETCH_URL),headers: {"Accept":"application/json"});
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
    for(var i=0; i< data.length;i++){
      searchList.add(data[i]['title']);
    }
      //return data;
    }

  }

  Widget menuDrawer(){
    return Drawer(
      child: ListView(children: [

        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Colors.pink
          ),
          currentAccountPicture: GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person),),),
            accountName: Text(widget.fullName),
            accountEmail: Text(widget.userName)),
        ListTile(
          onTap: (){
            Navigator.of(context).pop();
          },
          leading: Icon(Icons.home,color: Colors.green,),
          title: Text("Home",style: TextStyle(color: Colors.green),),
        ),

        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUs()));
          },
          leading: Icon(Icons.label,color: Colors.grey,),
          title: Text("About Us",style: TextStyle(color: Colors.grey),),
        ),
        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Contact()));
          },
          leading: Icon(Icons.phone,color: Colors.amber,),
          title: Text("Contact",style: TextStyle(color: Colors.amber),),
        ),
        widget.userName=="Guest" ?
        ListTile(
          onTap: (){},
          leading: Icon(Icons.lock,color: Colors.red,),
          title: Text("Login",style: TextStyle(color: Colors.red),),
        ):
        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
          },
          leading: Icon(Icons.lock_open,color: Colors.red,),
          title: Text("LogOut",style: TextStyle(color: Colors.red),),
        ),
      ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    showAllPost();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
        //automaticallyImplyLeading: false,
        actions: [
        IconButton(
            onPressed: (){
              showSearch(context: context, delegate: SearchPost(list: searchList));

            },
            icon: Icon(Icons.search))
        ],
      ),
      drawer: menuDrawer(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Blog Today",style: TextStyle(fontSize: 25,fontFamily: 'BebasNeue'),),
          ) ,
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text(curdate,style: TextStyle(fontSize: 18,fontFamily: 'BebasNeue',color: Colors.grey),),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Icon(Icons.today,color: Colors.pink,),),

           ],
         ),
        TopCard(userName: widget.userName,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(child: Text("Top Categories",style: TextStyle(
              fontSize: 25,

            ),),),
          ),
          CategoryListItem(),
          RecentPostItem(),
        ],
      ),
    );
  }
}

class SearchPost extends SearchDelegate <String>{
  List <dynamic> list;
  SearchPost({required this.list});
  List <dynamic> searchTitle  =[];

  Future showAllPost()async{
    var  FETCH_URL ="https://ultdev.org/flutterBlogBack/searchPost.php";
    var response = await http.post(Uri.parse(FETCH_URL),body:{'title':query} );
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      return data;
    }

  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: (){
            query = "";
            showSuggestions(context);

          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){
          // Navigator.pop(context);
          close(context, "");
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
   return FutureBuilder<dynamic>(
     future: showAllPost(),
       builder: (context,snapshot){
     if(snapshot.hasData){
       return ListView.builder(
         itemCount: snapshot.data.length,
           itemBuilder: (context,index){
           var list = snapshot.data[index];
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
         Padding(
         padding: const EdgeInsets.all(8.0),
             child: Text(list['title'],style: TextStyle(
             fontSize: 22,
             fontWeight: FontWeight.bold,
             ),),
             ),
             Center(child: Container(child: Image.network("https://ultdev.org/flutterBlogBack/uploads/${list['image']}",height: 250,),)),
             Padding(
                 padding: const EdgeInsets.all(8.0),
               child: Text(
                 list['body']==null ? "" : list['body'],
                 style: TextStyle(
                   fontSize: 20,
                 ),
               ),
             ),

             Row(
               children: [
                 Container(
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text(
                       "by "+ list['author'],
                       style: TextStyle(
                           fontSize: 16,
                           color: Colors.grey
                       ),
                     ),
                   ),),
                 SizedBox(width: 5,),
                 Container(
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text(
                       "Posted on : "+ list['post_date'],
                       style: TextStyle(
                           fontSize: 16,
                           color: Colors.grey
                       ),
                     ),
                   ),),
               ],
             ),
             SizedBox(height: 20,),
             Container(
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(
                   "Comments Area",
                   style: TextStyle(
                     fontSize: 20,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ),),
             Container(
               child: Column(
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextField(
                       decoration: InputDecoration(
                           labelText: "Enter Comments here"
                       ),
                     ),
                   ),
                   Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: MaterialButton(
                         color: Colors.blue,
                         child: Text("send",style: TextStyle(color: Colors.white),),
                         onPressed: (){},
                       )
                   ),
                 ],
               ),
             )


           ],
         );
       });
     }
     return Center(child: CircularProgressIndicator());
   });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
   var listData= query.isEmpty ? list : list.where((element) => element.toLowerCase().contains(query)).toList();
   return listData.isEmpty ?  Center(child: Text("No Data found")):ListView.builder(

     itemCount: listData.length,
       itemBuilder: (context,index){
     return ListTile(
       onTap: (){
         query = listData[index];
         showResults(context);
       },
       title: Text(listData[index]),
     );
   });
  }

}
