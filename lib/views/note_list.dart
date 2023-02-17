import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_news_api/models/note_model.dart';
import 'package:flutter_news_api/helper/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_news_api/views/note_detail.dart';


class NoteList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (noteList == null) {
      noteList = <Note>[];
      updateListView();
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        backgroundColor: Colors.white,
        title: Text('Notes',style: TextStyle(color: Colors.black87),),
      ),

      body: getNoteListView(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Note('', '',   2), 'Add Note');
        },

        // tooltip: 'Add Note',

        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white70,
          child: ListTile(

            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),

            title: Text(this.noteList[position].title, style: titleStyle,),

            subtitle: Text(this.noteList[position].date),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),

            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList[position],'Edit Note');
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {

    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}







