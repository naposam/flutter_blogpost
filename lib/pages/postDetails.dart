import 'dart:convert';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_share/flutter_share.dart';

class PostDetails extends StatefulWidget {
  final id;
  final title;
  final body;
  final comments;
  final image;
  final author;
  final postDate;
  final userName;
  PostDetails({this.id,this.title,this.comments,this.body,this.author,this.image,this.postDate,this.userName});

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  TextEditingController commentController = TextEditingController();

  FlutterLocalNotificationsPlugin ? flutterLocalNotificationsPlugin;

  String isLikeOrDislike = "";


  Future addLikes()async{
    final addLikes=Uri.parse("https://ultdev.org/flutterBlogBack/addLikes.php");
    final response = await http.post(addLikes,body: {
      "username":widget.userName,
      "post_id": widget.id,
    });
    if(response.statusCode==200){
      print('Done');
    }
  }


  Future getLikes()async{
    final getLikeURL=Uri.parse("https://ultdev.org/flutterBlogBack/selectLike.php");
    final response = await http.post(getLikeURL,body: {
      "username":widget.userName,
      "post_id": widget.id,
    });
    if(response.statusCode==200){
      var data = jsonDecode(response.body);
       setState(() {
         isLikeOrDislike=data;
       });
      print(isLikeOrDislike);
    }
  }




  Future addComment()async{
    final addCommentUrl=Uri.parse("https://ultdev.org/flutterBlogBack/addComment.php");
    final response = await http.post(addCommentUrl,body: {
      "comment":commentController.text,
      "username":widget.userName,
      "post_id": widget.id,
    });
    if(response.statusCode==200){
      showNotification();
      FlutterToastr.show("Comment Successfully Posted",
        context,
        duration: FlutterToastr.lengthLong,
        position:  FlutterToastr.bottom,
        backgroundColor: Colors.green,
      );
      Navigator.pop(context);

    }
  }
  @override
  void initState() {
    super.initState();
    getLikes();

    var androidInit = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInit = new IOSInitializationSettings();
    var initialized = InitializationSettings(android: androidInit,iOS: iosInit);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.initialize(initialized);
  }
    Future onSelectNotification(dynamic payload)async{
      if(payload !=""){
        debugPrint("Notification: " +payload);
      }

    }
    Future showNotification()async{
      var androidDetails = AndroidNotificationDetails('channelId', 'channelName', 'channelDescription',importance: Importance.high);
      var iosDetails = IOSNotificationDetails();
      var platform = NotificationDetails(android: androidDetails,iOS: iosDetails);
      await flutterLocalNotificationsPlugin!.show(0, 'ULTDEV post', commentController.text, platform);

    }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Post Details"),

      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.title,style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'BebasNeue',

              ),),
            ),
            SizedBox(height: 20,),
            Container(child: Image.network(widget.image,height: 250,),),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
              widget.body==null ? "" : widget.body,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ),
            Container(
              child: Row(
                children: [
                  isLikeOrDislike=="ONE" ?
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        addLikes().whenComplete(() => getLikes());
                      },
                      child: Text(
                        'Unlike',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                  :IconButton(onPressed: (){
                    addLikes().whenComplete(() => getLikes());
                  }, icon: Icon(Icons.thumb_up,color: Colors.green,)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.thumb_down)),
                  InkWell(child: Icon(Icons.share),
                    onTap: ()async{
                      await FlutterShare.share(
                          title: widget.title,
                          text: widget.body,
                          linkUrl: 'https://flutter.dev/',
                          chooserTitle: 'Flutter Blogs'
                      );
                  },)
                ],
              ),
            ),
           Row(
             children: [
               Container(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text(
                     "by "+ widget.author,
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
                     "Posted on : "+ widget.postDate,
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
                      controller: commentController,

                      decoration: InputDecoration(
                        labelText: "Enter Comments here"
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: Colors.blue,
                      child: Text("Publish",style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        addComment();
                      },
                    )
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
