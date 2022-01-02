import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toastr/flutter_toastr.dart';
class AddEditCategory extends StatefulWidget {

final categoryList;
final index;
AddEditCategory({this.index,this.categoryList});
  @override
  _AddEditCategoryState createState() => _AddEditCategoryState();
}

class _AddEditCategoryState extends State<AddEditCategory> {
  TextEditingController categoryName=TextEditingController();
  bool editMode=false;

  Future addEditCategory()async{
    if(categoryName.text !="") {
      if (editMode) {
        final URL = "https://ultdev.org/flutterBlogBack/updateCategory.php";
        var response = await http.post(Uri.parse(URL), body: {
          "id": widget.categoryList[widget.index]["id"],
          "name": categoryName.text
        });
        if (response.statusCode == 200) {
          FlutterToastr.show("Category Updated Successfully",
            context,
            duration: FlutterToastr.lengthLong,
            position:  FlutterToastr.bottom,
            backgroundColor: Colors.green,
          );
          Navigator.pop(context);
        }
      } else {
        final URL_ADD = "https://ultdev.org/flutterBlogBack/addCategory.php";
        var response = await http.post(Uri.parse(URL_ADD), body: {
          "name": categoryName.text
        });
        if (response.statusCode == 200) {
          FlutterToastr.show("Category Add Successfully",
            context,
            duration: FlutterToastr.lengthLong,
            position:  FlutterToastr.bottom,
            backgroundColor: Colors.green,
          );
          Navigator.pop(context);
        }
      }
    }
  }
@override
  void initState() {
    super.initState();
    if(widget.index != null){
      editMode=true;
      categoryName.text = widget.categoryList[widget.index]['name'];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editMode ? "Update": "Add"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: categoryName,
              decoration: InputDecoration(
                labelText: "Category Name",

              ),
            ),
          ),
          MaterialButton(onPressed: (){
            addEditCategory();

          },color: Colors.purple,
            child: Text(editMode ? "Update" :"Save",style: TextStyle(
            color: Colors.white
          ),),)
        ],
      ),
    );
  }
}
