import 'dart:convert';

import 'package:blog_post/pages/postDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class SelectCategoryBy extends StatefulWidget {
  final categoryName;
  SelectCategoryBy({this.categoryName});


  @override
  _SelectCategoryByState createState() => _SelectCategoryByState();
}

class _SelectCategoryByState extends State<SelectCategoryBy> {
  List <dynamic> categoryByPost=[];
  Future categoryByData()async{
    final URL_POST_CATEGORY="https://ultdev.org/flutterBlogBack/categoryByPost.php";
    var response = await http.post(Uri.parse(URL_POST_CATEGORY),body:{"name": widget.categoryName,});
    if(response.body.isNotEmpty){
     var data = jsonDecode(response.body);
     setState(() {
       categoryByPost = data;
     });
    }

  }
  @override
  void initState() {
    super.initState();
    categoryByData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Container(child: ListView.builder(
          itemCount: categoryByPost.length,
          itemBuilder: (context, index){
            return  NewPostItem(
              title: categoryByPost[index]['title'],
              author: categoryByPost[index]['author'],
              body: categoryByPost[index]['body'],
              categoryName: categoryByPost[index]['category_name'],
              comments: categoryByPost[index]['comment'],
              image: 'https://ultdev.org/flutterBlogBack/uploads/${categoryByPost[index]['image']}',
              createdDate: categoryByPost[index]['create_date'],
              postDate: categoryByPost[index]['post_date'],
              totalLikes: categoryByPost[index]['total_like'],

            );

          }),),
    );
  }
}
class NewPostItem extends StatefulWidget {
  final  image ;
  final author;
  final postDate;
  final comments;
  final totalLikes;
  final title;
  final body;
  final categoryName;
  final createdDate;
  NewPostItem({
    this.image,
    this.author,
    this.postDate,
    this.comments,
    this.title,
    this.body,
    this.createdDate,
    this.categoryName,
    this.totalLikes
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
                title: widget.title,
                body: widget.body,
                author: widget.author,
                image: widget.image,
                postDate: widget.postDate,

              )));
            },
          ),
        ),

      ],
    );
  }
}
