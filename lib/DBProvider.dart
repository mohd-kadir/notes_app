import 'package:db_practise/data/local/db_helper.dart';
import 'package:flutter/widgets.dart';

class DBProvider extends ChangeNotifier{
  DBHelper dbHelper;
  DBProvider({required this.dbHelper});
  List<Map<String, dynamic>> _mData =[];

  ///events
  void addNotes(String title, String desc)async{
    bool check = await dbHelper.addNote(mTitle: title, mDesc: desc);
    if(check){
     _mData =  await dbHelper.getALLNotes();
     notifyListeners();
    }
  }

  void updateNote(String title, String desc, int sno)async{
    bool check = await dbHelper.updateNote(mTitle: title, mDescri: desc, sno: sno);
    if(check){
      _mData =  await dbHelper.getALLNotes();
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getNotes() => _mData;

  void getInitialNotes()async{
    _mData =  await dbHelper.getALLNotes();
    notifyListeners();
  }



}