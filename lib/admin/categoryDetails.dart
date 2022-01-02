import 'dart:convert';
import 'package:blog_post/admin/addEditCategory.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toastr/flutter_toastr.dart';
class CategoryDetails extends StatefulWidget {
  const CategoryDetails({Key? key}) : super(key: key);

  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {

  List <dynamic>category=[];

  Future getAllCategory()async{
    final URL="https://ultdev.org/flutterBlogBack/CategoryAll.php";
    var response = await http.get(Uri.parse(URL));
    if(response.statusCode==200){
      var jsonData= jsonDecode(response.body);
      setState(() {
        category= jsonData;
      });
    }
    print(category);
  }
  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category Details"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEditCategory())).whenComplete(() => getAllCategory());
          },
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemCount: category.length,
          itemBuilder: (context,index){
        return Card(
          elevation: 2,
          child: ListTile(
            leading:IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEditCategory(
                categoryList: category,index: index,
              ))).whenComplete(() => getAllCategory());
            },icon: Icon(Icons.edit),),
            title: Text(category[index]['name']),
            trailing: IconButton(onPressed: ()async{
              final URL_DELETE="https://ultdev.org/flutterBlogBack/deleteCategory.php";
              var response = await http.post(Uri.parse(URL_DELETE),body: {
                "id": category[index]["id"],
              });
              if(response.statusCode==200){
                FlutterToastr.show("Category Deleted Successfully",
                  context,
                  duration: FlutterToastr.lengthLong,
                  position:  FlutterToastr.bottom,
                  backgroundColor: Colors.green,
                );
                getAllCategory();
              }
            }, icon: Icon(Icons.delete),),
          ),
        );
      }),
    );
  }
}
