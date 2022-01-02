import 'dart:convert';

import 'package:blog_post/pages/postDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class TopCard extends StatefulWidget {
 final userName;
 TopCard({this.userName});

  @override
  _TopCardState createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  bool loading=true;
  List <dynamic> postCard  =[];
  Future showAllPost()async{
    var  FETCH_URL ="https://ultdev.org/flutterBlogBack/fetch.php";
    var response = await http.get(Uri.parse(FETCH_URL),headers: {"Accept":"application/json"});
    if(response.body.isNotEmpty){
      var data= jsonDecode(response.body);
      setState(() {
      loading=false;
        postCard=data;
      });
      return data;
    }

  }
  @override
  void initState() {

    super.initState();
    showAllPost();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
     width: MediaQuery.of(context).size.width,
    // color: Colors.amber,

     child: loading ? Center(child: CircularProgressIndicator(),):ListView.builder(
       scrollDirection: Axis.horizontal,

       itemCount: postCard.length,
         itemBuilder: (context,index){
           return  NewPostItem(
             id: postCard[index]['id'],
             title: postCard[index]['title'],
             author: postCard[index]['author'],
             body: postCard[index]['body'],
             categoryName: postCard[index]['category_name'],
             comments: postCard[index]['comment'],
             image: 'https://ultdev.org/flutterBlogBack/uploads/${postCard[index]['image']}',
             createdDate: postCard[index]['create_date'],
             postDate: postCard[index]['post_date'],
             totalLikes: postCard[index]['total_like'],
             userName: widget.userName,

           );



         }),
    );
  }
}
class NewPostItem extends StatefulWidget {
  final id;
  final  image ;
  final author;
  final postDate;
  final comments;
  final totalLikes;
  final title;
  final body;
  final categoryName;
  final createdDate;
  final userName;

  NewPostItem({
    this.id,
     this.image,
     this.author,
    this.postDate,
    this.comments,
    this.title,
     this.body,
    this.createdDate,
    this.categoryName,
    this.totalLikes,
    this.userName,

  });

  // const NewPostItem({Key? key}) : super(key: key);

  @override
  _NewPostItemState createState() => _NewPostItemState();
}

class _NewPostItemState extends State<NewPostItem> {
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.amber,
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.amber,Colors.pink]),
            ),

          ),
        ),
        Positioned(
          top: 30,
          left: 30,
          child: CircleAvatar(
            radius: 20,
            //child: Icon(Icons.person),
            backgroundImage: NetworkImage(widget.image),
          ),
        ),
        Positioned(
          top: 30,
          left:80,
          child:Text(widget.author,style: TextStyle(
              color: Colors.white,
              fontFamily: 'BebasNeue',
              fontWeight: FontWeight.bold
          ),),
        ),
        Positioned(
          top: 30,
          left:150,
          child:Text(widget.postDate,style: TextStyle(
            color: Colors.grey.shade200,
            fontFamily: 'BebasNeue',

          ),),
        ),
        Positioned(
          top: 50,
          left:100,
          child:Icon(Icons.comment,color: Colors.white,),
        ),
        Positioned(
          top: 50,
          left:140,
          child:Text(widget.comments,style: TextStyle(
              color: Colors.white,
              fontFamily: 'BebasNeue',
              fontWeight: FontWeight.bold
          ),),
        ),
        Positioned(
          top: 50,
          left:170,
          child:Icon(Icons.label,color: Colors.white,),
        ),
        Positioned(
          top: 50,
          left:200,
          child:Text(widget.totalLikes,style: TextStyle(
              color: Colors.white,
              fontFamily: 'BebasNeue',
              fontWeight: FontWeight.bold
          ),),
        ),
        Positioned(
          top: 100,
          left:30,
          child:Text(widget.title,style: TextStyle(
              color: Colors.white,
              fontFamily: 'BebasNeue',
              fontWeight: FontWeight.bold
          ),),
        ),
        Positioned(
          top: 145,
          left:30,
          child:Icon(Icons.arrow_back,color: Colors.white,),
        ),
        Positioned(
          top: 150,
          left:60,
          child:InkWell(
            child: Text("Read More",style: TextStyle(
                color: Colors.grey.shade200,
                fontFamily: 'BebasNeue',
                fontWeight: FontWeight.bold
            ),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PostDetails(
                id: widget.id,
                title: widget.title,
                body: widget.body,
                author: widget.author,
                image: widget.image,
                postDate: widget.postDate,
                userName: widget.userName,
              )));
            },
          ),
        ),

      ],
    );
  }
}

