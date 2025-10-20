import 'package:db_practise/DBProvider.dart';
import 'package:db_practise/data/local/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNotePage extends StatelessWidget {
  late bool isUpdate;
  String title;
  String desc;
  ///Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriController = TextEditingController();
 // DBHelper? dbRef = DBHelper.getInstance;

  var sno;

  AddNotePage({this.isUpdate = false, this.sno = 0, this.title = "", this.desc = ""});

  @override
  Widget build(BuildContext context) {
    if(isUpdate){
      titleController.text = title;
      descriController.text = desc;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? 'Update Note' : "Add Note",),
      ),
      body:Container(
        height: MediaQuery.of(context).size.height * 0.5 + MediaQuery.of(context).viewInsets.bottom,
        padding: EdgeInsets.only(top: 11,right: 11,left: 11,bottom: 11 + MediaQuery.of(context).viewInsets.bottom ),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Text(
              isUpdate ? 'Update Note' : "Add Note",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),*/
            SizedBox(height: 21),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter title here",
                label: Text("Title *"),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 21),
            TextField(
              maxLines: 6,
              controller: descriController,
              decoration: InputDecoration(
                hintText: "Enter description here",
                label: Text('Description *'),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 11),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    onPressed: () async {
                      var Title = titleController.text;
                      var Descri = descriController.text;

                      if (Title.isNotEmpty && Descri.isNotEmpty) {

                        if(isUpdate){
                          context.read<DBProvider>().updateNote(Title, Descri, sno);
                        }else{
                          context.read<DBProvider>().addNotes(Title, Descri);
                        }
                        Navigator.pop(context);
                        /*bool check = isUpdate
                            ? await dbRef!.updateNote(
                          mTitle: Title,
                          mDescri: Descri,
                          sno: sno,
                        )
                            : await dbRef!.addNote(mTitle: Title, mDesc: Descri);
                        if (check) {
                          Navigator.pop(context);
                        }*/
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "*Please fill all the requirements blanks!!",
                            ),
                          ),
                        );
                      }

                      titleController.clear();
                      descriController.clear();

                    },
                    child: Text(isUpdate ? 'Update Note' : "Add Note"),
                  ),
                ),
                SizedBox(width: 11),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }
}