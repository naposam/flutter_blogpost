import 'package:blog_post/pages/postDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecentPostItem extends StatefulWidget {
  const RecentPostItem({Key? key}) : super(key: key);

  @override
  _RecentPostItemState createState() => _RecentPostItemState();
}

class _RecentPostItemState extends State<RecentPostItem> {
  bool loading=true;
  List <dynamic> recentPost  =[];
  Future recentPostData()async{
    var  FETCH_URL ="https://ultdev.org/flutterBlogBack/fetch.php";
    var response = await http.get(Uri.parse(FETCH_URL),headers: {"Accept":"application/json"});
    if(response.body.isNotEmpty){
      var data= jsonDecode(response.body);
      setState(() {
        loading=false;
        recentPost=data;
      });
      return data;
    }

  }
  @override
  void initState() {

    super.initState();
    recentPostData();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: recentPost.length,
          itemBuilder: (context,index){
          return RecentItem(
            title:recentPost[index]["title"],
            author: recentPost[index]['author'],
            date: recentPost[index]['create_date'],
            image: 'https://ultdev.org/flutterBlogBack/uploads/${recentPost[index]['image']}',
            id: recentPost[index]["id"],
            body: recentPost[index]['body'],
          );
          }),
    );
  }
}

class RecentItem extends StatefulWidget {
  final id;
  final title;
  final author;
  final image;
  final date;
  final body;

  RecentItem({this.author,this.title,this.image,this.id,this.date,this.body});

  @override
  _RecentItemState createState() => _RecentItemState();
}

class _RecentItemState extends State<RecentItem> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>PostDetails(
                        image: widget.image,
                        author: widget.author,
                        title: widget.title,
                        postDate: widget.date,
                        body: widget.body,
                      )));
                },
                  child: Container(
                    width: 300,
                      child: Text(widget.title,style: TextStyle(fontSize: 20),))),
            ),

            Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text("posted By:"+widget.author,style: TextStyle(color: Colors.grey),),
               ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(widget.date,style: TextStyle(color: Colors.grey)),
               ),
             ],
           ),

          ],
        ),
         Container(child: Padding(
           padding: const EdgeInsets.all(5.0),
           child: Image.network(widget.image,height: 70,width: 70,),
         ),),
      ],
    );
  }
}

