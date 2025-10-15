import 'package:db_practise/data/local/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getALLNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.deepPurpleAccent.shade100,
        centerTitle: true,
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Text("${index+1}"),
                  title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESCRI]),
                  trailing: SizedBox(
                    width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                titleController.text =
                                    allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                                descriController.text =
                                    allNotes[index][DBHelper
                                        .COLUMN_NOTE_DESCRI];
                                return getBottomSheetWidget(
                                  isUpdate: true,
                                  sno:
                                      allNotes[index][DBHelper.COLUMN_NOTE_SNO],
                                );
                              },
                            );
                          },
                          child: Icon(Icons.edit),
                        ),
                        InkWell(
                            onTap: () async{
                              bool check = await dbRef!.deleteNote(sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                              if(check){
                                getNotes();
                              }
                            },
                            child: Icon(Icons.delete, color: Colors.red)),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(child: Text("No Notes yet!!")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String errorMsg = '';

          ///Note to be added here
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              titleController.clear();
              descriController.clear();
              return getBottomSheetWidget();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetWidget({bool isUpdate = false, int sno = 0}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5 + MediaQuery.of(context).viewInsets.bottom,
      padding: EdgeInsets.only(top: 11,right: 11,left: 11,bottom: 11 + MediaQuery.of(context).viewInsets.bottom ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isUpdate ? 'Update Note' : "Add Note",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
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
                      bool check = isUpdate
                          ? await dbRef!.updateNote(
                              mTitle: Title,
                              mDescri: Descri,
                              sno: sno,
                            )
                          : await dbRef!.addNote(mTitle: Title, mDesc: Descri);
                      if (check) {
                        getNotes();
                      }
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

                    Navigator.pop(context);
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
    );
  }
}
