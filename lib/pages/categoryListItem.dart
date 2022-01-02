import 'dart:convert';

import 'package:blog_post/pages/selectCategoryBy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class CategoryListItem extends StatefulWidget {
  @override
  _CategoryListItemState createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  bool isLoading =true;
  List <dynamic>categories =[];
  Future getAllCategory()async{
    final CATE_URL="https://ultdev.org/flutterBlogBack/CategoryAll.php";
    var response = await http.get(Uri.parse(CATE_URL),);
    if(response.body.isNotEmpty){
      var data = jsonDecode(response.body);
      setState(() {
        isLoading = false;
        categories = data;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
          itemBuilder: (context,index){
            return CategoryItem(categoryName: categories[index]['name'] ,);
          }),
    );
  }

}
class CategoryItem extends StatefulWidget {
  final categoryName;

  CategoryItem({this.categoryName});

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {

  @override

  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: Text(widget.categoryName,style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectCategoryBy(
              categoryName: widget.categoryName,
            )));

          },
        ),
      ),
    );
  }
}

