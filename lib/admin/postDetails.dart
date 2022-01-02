import 'dart:convert';

import 'package:blog_post/admin/addEditPost.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toastr/flutter_toastr.dart';
class PostDetails extends StatefulWidget {
  const PostDetails({Key? key}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {

  List <dynamic> post =[];

  Future getAllPost()async{
    final URL="https://ultdev.org/flutterBlogBack/fetch.php";
    var response = await http.get(Uri.parse(URL));
    if(response.statusCode==200){
      var jsonData= jsonDecode(response.body);
      setState(() {
        post= jsonData;
      });
    }
    print(post);
  }

  @override
  void initState() {
    super.initState();
    getAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Details"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEditPost())).whenComplete(() {
              getAllPost();
            });
          }, icon: Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemCount: post.length,
          itemBuilder: (context, index){
        return Card(
          elevation: 2,
          child: ListTile(
            leading: IconButton(onPressed:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEditPost(
                postList: post,index: index,
              ))).whenComplete(() => getAllPost());
            } ,icon: Icon(Icons.edit,color: Colors.green,),),
            title: Text(post[index]['title']),
            subtitle: Text(post[index]['body'],maxLines: 2,),
            trailing:  IconButton(onPressed:(){
              showDialog(context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text("Message"),
                        content: Text("Are You Sure You want to Delete?"),
                        actions: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {

                                });
                              },
                              child: Text("Cancel")),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              onPressed: ()async {
                                var urlDelete=Uri.parse("https://ultdev.org/flutterBlogBack/deletePost.php");
                                var response = await http.post(urlDelete,body: {"id":post[index]['id']});
                                if(response.statusCode==200){
                                  FlutterToastr.show("Post Deleted Successfully",
                                    context,
                                    duration: FlutterToastr.lengthLong,
                                    position:  FlutterToastr.bottom,
                                    backgroundColor: Colors.green,
                                  );
                                  setState(() {
                                    getAllPost();
                                  });
                                  Navigator.pop(context);
                                }


                              },
                              child: Text("Confirm")),
                        ],
                      ));
            } ,icon: Icon(Icons.delete,color: Colors.red,),),
          ),
        );
      }),
    );
  }
}
