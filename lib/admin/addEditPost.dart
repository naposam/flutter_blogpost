import 'dart:convert';
import 'dart:io';

import 'package:blog_post/admin/postDetails.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toastr/flutter_toastr.dart';
class AddEditPost extends StatefulWidget {
  final postList;
  final index;
  final author;
  AddEditPost({this.index,this.postList,this.author});

  @override
  _AddEditPostState createState() => _AddEditPostState();
}

class _AddEditPostState extends State<AddEditPost> {
   File ? _image;
  final ImagePicker _picker = ImagePicker();


  String ? selectedCategory ;
  List <dynamic> categoryItem=[];


  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  TextEditingController author = TextEditingController();

  bool editMode=false;
  Future choiceImage()async{
    var pickedImage =await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image=File(pickedImage!.path);
    });
  }

  Future addEditPost()async{
    if(editMode){
      var uri=Uri.parse("https://ultdev.org/flutterBlogBack/updatePost.php");
      var request = http.MultipartRequest("POST",uri);
      request.fields["id"]= widget.postList[widget.index]['id'];
      request.fields["title"]= title.text;
      request.fields["body"]= body.text;
      //request.fields["author"]= widget.author;
      request.fields["category_name"]= selectedCategory!;

      var pic = await http.MultipartFile.fromPath("image", _image!.path,filename: _image!.path);
      request.files.add(pic);
      var response = await request.send();
      if(response.statusCode==200){
        FlutterToastr.show("Post Updated Successfully",
          context,
          duration: FlutterToastr.lengthLong,
          position:  FlutterToastr.bottom,
          backgroundColor: Colors.green,
        );
        Navigator.pop(context);

      }
    }else{
      var uri=Uri.parse("https://ultdev.org/flutterBlogBack/addPost.php");
      var request = http.MultipartRequest("POST",uri);
      request.fields["title"]= title.text;
      request.fields["body"]= body.text;
       request.fields["author"]= author.text;
      request.fields["category_name"]= selectedCategory!;

      var pic = await http.MultipartFile.fromPath("image", _image!.path,filename: _image!.path);
      request.files.add(pic);
      var response = await request.send();
      if(response.statusCode==200){
        FlutterToastr.show("Post Added Successfully",
          context,
          duration: FlutterToastr.lengthLong,
          position:  FlutterToastr.bottom,
          backgroundColor: Colors.green,
        );
        Navigator.pop(context);

      }

    }



  }

    Future getAllCategory()async{
      final URL="https://ultdev.org/flutterBlogBack/CategoryAll.php";
      var response = await http.get(Uri.parse(URL));
      if(response.statusCode==200){
        var jsonData= jsonDecode(response.body);
        setState(() {
          categoryItem= jsonData;
        });
      }
      print(categoryItem);
    }


  @override
  void initState() {
    super.initState();
    getAllCategory();
    if(widget.index !=null){
      editMode =true;
      title.text = widget.postList[widget.index]['title'];
      body.text = widget.postList[widget.index]['body'];
      selectedCategory = widget.postList[widget.index]['category_name'];

    }
    // choiceImage().whenComplete(() {
    //   setState(() {});
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editMode ? "Update Post":"Add Post"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller:title ,
              decoration: InputDecoration(
                labelText: "Post Title",

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 4,
              keyboardType: TextInputType.text,
              controller:body ,
              decoration: InputDecoration(
                labelText: "Post Body",

              ),
            ),
          ),
          editMode  ? Text(''):
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.text,
              controller:author ,
              decoration: InputDecoration(
                labelText: "Author",

              ),
            ),
          ),
           IconButton(onPressed: (){choiceImage();}, icon: Icon(Icons.image,size: 50,)),
          SizedBox(height: 20,),
          editMode ? Container(child: Image.network("https://ultdev.org/flutterBlogBack/uploads/${widget.postList[widget.index]['image']}"),width: 100,height: 100,):Text(''),
           Container(
            child: _image == null ? Center(child: Text("No Image Selected")): Image.file(_image!),width: 100,height: 100,),
          //imageProfile(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              isExpanded: true,
              value: selectedCategory,
              hint: Text("Select Category"),
              items: categoryItem.map((category){
                return DropdownMenuItem(
                    child: Text(category['name']),
                  value: category['name'],
                );
              }).toList(),
              onChanged: (newValue){
                setState(() {
                  selectedCategory=newValue as String?;
                });
              },),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: (){
                  addEditPost();
                }, child: Text(editMode ? "Update Post":"Save Post")),
          ),

        ],
      ),
    );
  }

}
