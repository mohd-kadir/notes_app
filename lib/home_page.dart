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
                  leading: Text("${allNotes[index][DBHelper.COLUMN_NOTE_SNO]}"),
                  title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESCRI]),
                  trailing: SizedBox(
                    width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(

                            child: Icon(Icons.edit)),
                        InkWell(child: Icon(Icons.delete,color: Colors.red))
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
            context: context,
            builder: (context) {
              return getBottomSheetWidget();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
  Widget getBottomSheetWidget(){
    return Container(
      padding: EdgeInsets.all(11),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            "Add Note",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 21),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Enter title here",
              label: Text("Title *"),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.deepPurpleAccent,
                ),
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
                borderSide: BorderSide(
                  color: Colors.deepPurpleAccent,
                ),
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
                      side: BorderSide(
                          width: 1
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      )
                  ),
                  onPressed: () async{
                    var Title = titleController.text;
                    var Descri = descriController.text;

                    if(Title.isNotEmpty && Descri.isNotEmpty){
                      bool check = await dbRef!.addNote(mTitle: Title, mDesc: Descri);
                      if(check){
                        getNotes();
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("*Please fill all the requirements blanks!!")));
                    }

                    titleController.clear();
                    descriController.clear();

                    Navigator.pop(context);
                  },
                  child: Text("Add Note"),
                ),
              ),
              SizedBox(width: 11),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          width: 1
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      )
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
